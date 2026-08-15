import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  BadRequestException,
  InternalServerErrorException,
  ForbiddenException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { ConfigService } from '@nestjs/config';
import { User, UserRole } from './user.entity';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { AuthenticatedUser } from './jwt.strategy';

export interface AuthResponse {
  accessToken: string;
  refreshToken: string;
  user: {
    id: string;
    email: string;
    name: string;
    role: string;
    tenantId: string | null;
  };
}

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async validateUser(dto: LoginDto): Promise<User> {
    const user = await this.userRepo.findOne({
      where: { email: dto.email.toLowerCase().trim() },
      relations: ['tenant'],
    });
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }
    const valid = await bcrypt.compare(dto.password, user.passwordHash);
    if (!valid) {
      throw new UnauthorizedException('Invalid credentials');
    }
    if (!user.isActive) {
      throw new UnauthorizedException('Account is inactive');
    }
    return user;
  }

  async login(dto: LoginDto): Promise<AuthResponse> {
    const user = await this.validateUser(dto);
    return this.buildTokens(user);
  }

  async register(dto: RegisterDto): Promise<User> {
    const existing = await this.userRepo.findOneBy({
      email: dto.email.toLowerCase().trim(),
    });
    if (existing) {
      throw new ConflictException('Email already registered');
    }

    const role = dto.role ?? 'member';
    const allowedRoles = [
      'super_system_admin',
      'national_admin',
      'national_executive',
      'regional_admin',
      'regional_bishop',
      'district_admin',
      'district_pastor',
      'area_admin',
      'local_church_admin',
      'senior_pastor',
      'associate_pastor',
      'church_secretary',
      'finance_officer',
      'ministry_head',
      'youth_ministry_head',
      'men_fellowship_head',
      'women_fellowship_head',
      'children_ministry_head',
      'welfare_head',
      'cell_leader',
      'volunteer',
      'member',
      'guest',
    ];
    if (!allowedRoles.includes(role)) {
      throw new BadRequestException('Invalid role');
    }

    const passwordHash = await bcrypt.hash(dto.password, 12);
    const user = this.userRepo.create({
      email: dto.email.toLowerCase().trim(),
      passwordHash,
      name: dto.name,
      role: role as UserRole,
      tenantId: dto.tenantId ?? null,
      isActive: true,
    });

    try {
      return await this.userRepo.save(user);
    } catch (err) {
      throw new InternalServerErrorException('Failed to create user');
    }
  }

  /// Roles that a local_church_admin can assign when onboarding users.
  /// These are tenant-scoped roles only — no above-church or system admin roles.
  private readonly localChurchAdminAssignableRoles = [
    'local_church_admin',
    'senior_pastor',
    'associate_pastor',
    'church_secretary',
    'finance_officer',
    'ministry_head',
    'youth_ministry_head',
    'men_fellowship_head',
    'women_fellowship_head',
    'children_ministry_head',
    'welfare_head',
    'cell_leader',
    'volunteer',
    'member',
    'guest',
  ];

  async onboardUser(caller: AuthenticatedUser, dto: RegisterDto): Promise<User> {
    const existing = await this.userRepo.findOneBy({
      email: dto.email.toLowerCase().trim(),
    });
    if (existing) {
      throw new ConflictException('Email already registered');
    }

    const role = dto.role ?? 'member';

    // super_system_admin can assign any role to any tenant
    if (caller.role === 'super_system_admin') {
      const allowedRoles = [
        'super_system_admin',
        'national_admin',
        'national_executive',
        'regional_admin',
        'regional_bishop',
        'district_admin',
        'district_pastor',
        'area_admin',
        ...this.localChurchAdminAssignableRoles,
      ];
      if (!allowedRoles.includes(role)) {
        throw new BadRequestException('Invalid role');
      }
    } else {
      // local_church_admin (and other tenant admins) can only:
      // 1. Assign tenant-scoped roles
      // 2. Onboard to their own tenant
      if (!this.localChurchAdminAssignableRoles.includes(role)) {
        throw new ForbiddenException(
          'You can only assign roles within your church',
        );
      }
    }

    // Force tenantId to the caller's tenant for non-super admins
    const tenantId =
      caller.role === 'super_system_admin'
        ? (dto.tenantId ?? caller.tenantId)
        : caller.tenantId;

    const passwordHash = await bcrypt.hash(dto.password, 12);
    const user = this.userRepo.create({
      email: dto.email.toLowerCase().trim(),
      passwordHash,
      name: dto.name,
      role: role as UserRole,
      tenantId,
      isActive: true,
    });

    try {
      return await this.userRepo.save(user);
    } catch (err) {
      throw new InternalServerErrorException('Failed to create user');
    }
  }

  async refreshToken(userId: string): Promise<AuthResponse> {
    const user = await this.userRepo.findOne({
      where: { id: userId, isActive: true },
      relations: ['tenant'],
    });
    if (!user) {
      throw new UnauthorizedException('User not found');
    }
    return this.buildTokens(user);
  }

  async updateUser(caller: AuthenticatedUser, userId: string, dto: UpdateUserDto): Promise<User> {
    const user = await this.userRepo.findOneBy({ id: userId });
    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    // local_church_admin can only update users in their own tenant
    if (caller.role !== 'super_system_admin' && user.tenantId !== caller.tenantId) {
      throw new ForbiddenException('You can only manage users in your own church');
    }

    if (dto.email && dto.email !== user.email) {
      const existing = await this.userRepo.findOneBy({
        email: dto.email.toLowerCase().trim(),
      });
      if (existing) {
        throw new ConflictException('Email already in use');
      }
      user.email = dto.email.toLowerCase().trim();
    }

    if (dto.name) {
      user.name = dto.name;
    }

    if (dto.password) {
      user.passwordHash = await bcrypt.hash(dto.password, 12);
    }

    return await this.userRepo.save(user);
  }

  async getUsersByTenant(tenantId: string) {
    return this.userRepo.find({
      where: { tenantId, isActive: true },
      select: ['id', 'email', 'name', 'role', 'tenantId', 'createdAt'],
      order: { createdAt: 'DESC' },
    });
  }

  async findSuperAdmin(): Promise<User | null> {
    return this.userRepo.findOneBy({ role: 'super_system_admin' as UserRole });
  }

  private buildTokens(user: User): AuthResponse {
    const payload = {
      sub: user.id,
      email: user.email,
      role: user.role,
      tenantId: user.tenantId,
    };
    const accessToken = this.jwtService.sign(payload, {
      expiresIn: this.configService.get<string>('JWT_EXPIRES_IN', '15m'),
    });
    const refreshToken = this.jwtService.sign(
      { sub: user.id, type: 'refresh' },
      {
        expiresIn: this.configService.get<string>('JWT_REFRESH_EXPIRES_IN', '7d'),
      },
    );
    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        tenantId: user.tenantId,
      },
    };
  }
}
