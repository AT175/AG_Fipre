import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';

export interface JwtPayload {
  sub: string;
  email: string;
  role: string;
  tenantId: string | null;
}

export interface AuthenticatedUser {
  userId: string;
  email: string;
  role: string;
  tenantId: string | null;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    config: ConfigService,
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.getOrThrow<string>('JWT_SECRET'),
    });
  }

  async validate(payload: JwtPayload): Promise<AuthenticatedUser> {
    const user = await this.userRepo.findOne({
      where: { id: payload.sub, isActive: true },
      relations: ['tenant'],
    });
    if (!user) {
      throw new UnauthorizedException('User not found or inactive');
    }
    return {
      userId: user.id,
      email: user.email,
      role: user.role,
      tenantId: user.tenantId ?? payload.tenantId ?? null,
    };
  }
}
