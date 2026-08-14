import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  ParseUUIDPipe,
  ForbiddenException,
} from '@nestjs/common';
import { TenantsService } from './tenants.service';
import { CreateTenantDto } from './dto/create-tenant.dto';
import { UpdateTenantDto } from './dto/update-tenant.dto';
import { Roles } from '../auth/roles.decorator';
import { Public } from '../auth/public.decorator';
import { CurrentUser } from '../auth/current-user.decorator';
import { AuthenticatedUser } from '../auth/jwt.strategy';

@Controller('tenants')
export class TenantsController {
  constructor(private readonly tenantsService: TenantsService) {}

  @Post()
  @Roles('super_system_admin')
  create(@Body() dto: CreateTenantDto) {
    return this.tenantsService.create(dto);
  }

  @Get()
  @Roles('super_system_admin')
  findAll() {
    return this.tenantsService.findAll();
  }

  @Get('public/all')
  @Public()
  findAllPublic() {
    return this.tenantsService.findAllPublicBranding();
  }

  @Get('public/:slug')
  @Public()
  findPublicBySlug(@Param('slug') slug: string) {
    return this.tenantsService.findPublicBranding(slug);
  }

  @Get(':slug')
  findBySlug(@Param('slug') slug: string) {
    return this.tenantsService.findBySlug(slug);
  }

  @Get('by-id/:id')
  @Public()
  findById(@Param('id', ParseUUIDPipe) id: string) {
    return this.tenantsService.findById(id);
  }

  @Patch(':id')
  @Roles('super_system_admin', 'local_church_admin')
  update(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateTenantDto,
  ) {
    // local_church_admin can only update their own tenant
    if (user.role !== 'super_system_admin' && user.tenantId !== id) {
      throw new ForbiddenException('You can only manage your own church');
    }
    return this.tenantsService.update(id, dto);
  }

  @Delete(':id')
  @Roles('super_system_admin')
  remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.tenantsService.remove(id);
  }
}
