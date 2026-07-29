import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Tenant } from './tenant.entity';
import { CreateTenantDto } from './dto/create-tenant.dto';
import { UpdateTenantDto } from './dto/update-tenant.dto';

@Injectable()
export class TenantsService {
  constructor(
    @InjectRepository(Tenant)
    private readonly tenantRepo: Repository<Tenant>,
  ) {}

  async create(dto: CreateTenantDto): Promise<Tenant> {
    const existing = await this.tenantRepo.findOneBy({ slug: dto.slug });
    if (existing) {
      throw new ConflictException('Tenant slug already exists');
    }
    const tenant = this.tenantRepo.create({
      ...dto,
      subscriptionTier: dto.subscriptionTier ?? 'basic',
      primaryColor: dto.primaryColor ?? '#2E7D32',
      isActive: true,
    });
    return this.tenantRepo.save(tenant);
  }

  findAll(): Promise<Tenant[]> {
    return this.tenantRepo.find({ order: { createdAt: 'DESC' } });
  }

  async findBySlug(slug: string): Promise<Tenant> {
    const tenant = await this.tenantRepo.findOneBy({ slug });
    if (!tenant) {
      throw new NotFoundException('Tenant not found');
    }
    return tenant;
  }

  async findById(id: string): Promise<Tenant> {
    const tenant = await this.tenantRepo.findOneBy({ id });
    if (!tenant) {
      throw new NotFoundException('Tenant not found');
    }
    return tenant;
  }

  async update(id: string, dto: UpdateTenantDto): Promise<Tenant> {
    const tenant = await this.findById(id);
    if (dto.slug && dto.slug !== tenant.slug) {
      const existing = await this.tenantRepo.findOneBy({ slug: dto.slug });
      if (existing) {
        throw new ConflictException('Tenant slug already exists');
      }
    }
    Object.assign(tenant, dto);
    return this.tenantRepo.save(tenant);
  }

  async remove(id: string): Promise<void> {
    const tenant = await this.findById(id);
    tenant.isActive = false;
    await this.tenantRepo.save(tenant);
  }
}
