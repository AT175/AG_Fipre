import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  UseGuards,
  ParseUUIDPipe,
} from '@nestjs/common';
import { MembersService } from './members.service';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';
import { CurrentUser } from '../auth/current-user.decorator';
import { AuthenticatedUser } from '../auth/jwt.strategy';

@Controller('tenants/:tenantId/members')
@UseGuards(JwtAuthGuard)
export class MembersController {
  constructor(private readonly membersService: MembersService) {}

  @Get()
  @Roles('super_system_admin', 'church_admin', 'branch_admin', 'secretary')
  findAll(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
  ) {
    return this.membersService.findAll(user, tenantId);
  }

  @Get(':id')
  @Roles('super_system_admin', 'church_admin', 'branch_admin', 'secretary')
  findOne(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.membersService.findOne(user, tenantId, id);
  }

  @Post()
  @Roles('super_system_admin', 'church_admin', 'branch_admin', 'secretary')
  create(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Body() dto: CreateMemberDto,
  ) {
    return this.membersService.create(user, tenantId, dto);
  }

  @Patch(':id')
  @Roles('super_system_admin', 'church_admin', 'branch_admin', 'secretary')
  update(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateMemberDto,
  ) {
    return this.membersService.update(user, tenantId, id, dto);
  }

  @Delete(':id')
  @Roles('super_system_admin', 'church_admin', 'branch_admin')
  remove(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.membersService.remove(user, tenantId, id);
  }
}
