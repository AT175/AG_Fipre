import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  ParseUUIDPipe,
  Query,
} from '@nestjs/common';
import { AttendanceService } from './attendance.service';
import {
  CreateAttendanceDto,
  UpdateAttendanceDto,
  SelfCheckInDto,
} from './dto/attendance.dto';
import { Roles } from '../auth/roles.decorator';
import { CurrentUser } from '../auth/current-user.decorator';
import { AuthenticatedUser } from '../auth/jwt.strategy';

@Controller('tenants/:tenantId/attendance')
export class AttendanceController {
  constructor(private readonly attendanceService: AttendanceService) {}

  @Get()
  @Roles(
    'super_system_admin',
    'church_admin',
    'branch_admin',
    'secretary',
    'treasurer',
    'member',
  )
  findAll(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Query('branchId') branchId?: string,
  ) {
    if (branchId) {
      return this.attendanceService.findByBranch(user, tenantId, branchId);
    }
    return this.attendanceService.findAll(user, tenantId);
  }

  @Get(':id')
  @Roles(
    'super_system_admin',
    'church_admin',
    'branch_admin',
    'secretary',
    'treasurer',
    'member',
  )
  findOne(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.attendanceService.findOne(user, tenantId, id);
  }

  @Post()
  @Roles('super_system_admin', 'church_admin', 'branch_admin', 'secretary')
  create(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Body() dto: CreateAttendanceDto,
  ) {
    return this.attendanceService.create(user, tenantId, dto);
  }

  @Patch(':id')
  @Roles('super_system_admin', 'church_admin', 'branch_admin', 'secretary')
  update(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateAttendanceDto,
  ) {
    return this.attendanceService.update(user, tenantId, id, dto);
  }

  @Delete(':id')
  @Roles('super_system_admin', 'church_admin', 'branch_admin')
  remove(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.attendanceService.remove(user, tenantId, id);
  }

  // Admin manually marks members present
  @Post(':id/mark-present')
  @Roles('super_system_admin', 'church_admin', 'branch_admin', 'secretary')
  markPresent(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body('memberIds') memberIds: string[],
  ) {
    return this.attendanceService.markPresent(user, tenantId, id, memberIds);
  }

  // Admin manually marks members absent
  @Post(':id/mark-absent')
  @Roles('super_system_admin', 'church_admin', 'branch_admin', 'secretary')
  markAbsent(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body('memberIds') memberIds: string[],
  ) {
    return this.attendanceService.markAbsent(user, tenantId, id, memberIds);
  }

  // Member self-check-in with GPS proximity validation
  @Post(':id/self-checkin')
  @Roles('super_system_admin', 'church_admin', 'branch_admin', 'secretary', 'member')
  selfCheckIn(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: SelfCheckInDto,
  ) {
    // Use the authenticated user's id as the member id
    return this.attendanceService.selfCheckIn(user, tenantId, id, user.userId, dto);
  }
}
