import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  ForbiddenException,
} from '@nestjs/common';
import { AuthService, AuthResponse } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { CurrentUser } from './current-user.decorator';
import { AuthenticatedUser } from './jwt.strategy';
import { Public } from './public.decorator';
import { Roles } from './roles.decorator';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  @Public()
  @HttpCode(HttpStatus.OK)
  async login(@Body() dto: LoginDto): Promise<AuthResponse> {
    return this.authService.login(dto);
  }

  @Post('register')
  @Roles('super_system_admin')
  async register(@Body() dto: RegisterDto) {
    const user = await this.authService.register(dto);
    return {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      tenantId: user.tenantId,
    };
  }

  @Post('onboard-user')
  @Roles('super_system_admin', 'local_church_admin')
  async onboardUser(
    @CurrentUser() caller: AuthenticatedUser,
    @Body() dto: RegisterDto,
  ) {
    const user = await this.authService.onboardUser(caller, dto);
    return {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      tenantId: user.tenantId,
    };
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  async refresh(@CurrentUser() user: AuthenticatedUser): Promise<AuthResponse> {
    return this.authService.refreshToken(user.userId);
  }

  @Get('users/:tenantId')
  @Roles('super_system_admin', 'local_church_admin')
  async getUsersByTenant(
    @CurrentUser() caller: AuthenticatedUser,
    @Param('tenantId', ParseUUIDPipe) tenantId: string,
  ) {
    if (caller.role !== 'super_system_admin' && caller.tenantId !== tenantId) {
      throw new ForbiddenException('You can only view users in your own church');
    }
    return this.authService.getUsersByTenant(tenantId);
  }

  @Patch('users/:id')
  @Roles('super_system_admin', 'local_church_admin')
  async updateUser(
    @CurrentUser() caller: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateUserDto,
  ) {
    const user = await this.authService.updateUser(caller, id, dto);
    return {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      tenantId: user.tenantId,
    };
  }
}
