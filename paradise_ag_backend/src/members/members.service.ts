import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Member } from './member.entity';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { AuthenticatedUser } from '../auth/jwt.strategy';

@Injectable()
export class MembersService {
  constructor(
    @InjectRepository(Member)
    private readonly memberRepo: Repository<Member>,
  ) {}

  private ensureTenantScope(user: AuthenticatedUser, tenantId: string) {
    if (user.role === 'super_system_admin') return;
    if (user.tenantId !== tenantId) {
      throw new ForbiddenException('Cross-tenant access denied');
    }
  }

  findAll(user: AuthenticatedUser, tenantId: string): Promise<Member[]> {
    this.ensureTenantScope(user, tenantId);
    return this.memberRepo.find({
      where: { tenantId, isActive: true },
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(
    user: AuthenticatedUser,
    tenantId: string,
    id: string,
  ): Promise<Member> {
    this.ensureTenantScope(user, tenantId);
    const member = await this.memberRepo.findOneBy({ id, tenantId, isActive: true });
    if (!member) {
      throw new NotFoundException('Member not found');
    }
    return member;
  }

  async create(
    user: AuthenticatedUser,
    tenantId: string,
    dto: CreateMemberDto,
  ): Promise<Member> {
    this.ensureTenantScope(user, tenantId);
    const member = this.memberRepo.create({
      ...dto,
      tenantId,
      dateOfBirth: dto.dateOfBirth ? new Date(dto.dateOfBirth) : null,
      isActive: true,
    });
    return this.memberRepo.save(member);
  }

  async update(
    user: AuthenticatedUser,
    tenantId: string,
    id: string,
    dto: UpdateMemberDto,
  ): Promise<Member> {
    this.ensureTenantScope(user, tenantId);
    const member = await this.findOne(user, tenantId, id);
    Object.assign(member, {
      ...dto,
      dateOfBirth: dto.dateOfBirth ? new Date(dto.dateOfBirth) : member.dateOfBirth,
    });
    return this.memberRepo.save(member);
  }

  async remove(
    user: AuthenticatedUser,
    tenantId: string,
    id: string,
  ): Promise<void> {
    this.ensureTenantScope(user, tenantId);
    const member = await this.findOne(user, tenantId, id);
    member.isActive = false;
    await this.memberRepo.save(member);
  }
}
