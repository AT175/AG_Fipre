import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Tenant } from '../tenants/tenant.entity';

export type UserRole =
  | 'super_system_admin'
  | 'national_admin'
  | 'national_executive'
  | 'regional_admin'
  | 'regional_bishop'
  | 'district_admin'
  | 'district_pastor'
  | 'area_admin'
  | 'local_church_admin'
  | 'senior_pastor'
  | 'associate_pastor'
  | 'church_secretary'
  | 'finance_officer'
  | 'ministry_head'
  | 'youth_ministry_head'
  | 'men_fellowship_head'
  | 'women_fellowship_head'
  | 'children_ministry_head'
  | 'welfare_head'
  | 'cell_leader'
  | 'volunteer'
  | 'member'
  | 'guest';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 255, unique: true })
  email: string;

  @Column({ name: 'password_hash', type: 'varchar', length: 255 })
  passwordHash: string;

  @Column({ type: 'varchar', length: 255 })
  name: string;

  @Column({ type: 'varchar', length: 50 })
  role: UserRole;

  @Column({ name: 'tenant_id', type: 'uuid', nullable: true })
  tenantId: string | null;

  @ManyToOne(() => Tenant, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn({ name: 'tenant_id' })
  tenant: Tenant | null;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
