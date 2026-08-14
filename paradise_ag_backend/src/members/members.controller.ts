import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  ParseUUIDPipe,
} from '@nestjs/common';
import { MembersService } from './members.service';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { Roles } from '../auth/roles.decorator';
import { CurrentUser } from '../auth/current-user.decorator';
import { AuthenticatedUser } from '../auth/jwt.strategy';

@Controller('tenants/:tenantId/members')
export class MembersController {
  constructor(private readonly membersService: MembersService) {}

  @Get()
  @Roles('super_system_admin', 'national_admin', 'regional_admin', 'district_admin', 'area_admin', 'local_church_admin', 'church_secretary', 'senior_pastor', 'associate_pastor', 'cell_leader')
  findAll(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
  ) {
    return this.membersService.findAll(user, tenantId);
  }

  @Get(':id')
  @Roles('super_system_admin', 'national_admin', 'regional_admin', 'district_admin', 'area_admin', 'local_church_admin', 'church_secretary', 'senior_pastor', 'associate_pastor', 'cell_leader')
  findOne(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.membersService.findOne(user, tenantId, id);
  }

  @Post()
  @Roles('super_system_admin', 'national_admin', 'regional_admin', 'district_admin', 'area_admin', 'local_church_admin', 'church_secretary', 'cell_leader')
  create(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Body() dto: CreateMemberDto,
  ) {
    return this.membersService.create(user, tenantId, dto);
  }

  @Patch(':id')
  @Roles('super_system_admin', 'national_admin', 'regional_admin', 'district_admin', 'area_admin', 'local_church_admin', 'church_secretary', 'cell_leader')
  update(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateMemberDto,
  ) {
    return this.membersService.update(user, tenantId, id, dto);
  }

  @Delete(':id')
  @Roles('super_system_admin', 'national_admin', 'regional_admin', 'district_admin', 'area_admin', 'local_church_admin')
  remove(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.membersService.remove(user, tenantId, id);
  }
}
