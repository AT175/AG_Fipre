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
import { ConfigService } from '@nestjs/config';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly configService: ConfigService,
  ) {}

  @Post('setup-super-admin')
  @Public()
  @HttpCode(HttpStatus.OK)
  async setupSuperAdmin() {
    // Check if any super_system_admin already exists
    const existing = await this.authService.findSuperAdmin();
    if (existing) {
      return { message: 'Super admin already exists. Setup not allowed.', alreadySetup: true };
    }

    const email = this.configService.get<string>('SEED_SUPER_ADMIN_EMAIL', 'superadmin@paradiseag.org.gh');
    const password = this.configService.get<string>('SEED_SUPER_ADMIN_PASSWORD', 'Admin123!');

    const user = await this.authService.register({
      name: 'System Administrator',
      email,
      password,
      role: 'super_system_admin',
      tenantId: undefined,
    });

    return {
      message: 'Super admin created successfully',
      alreadySetup: false,
      user: { id: user.id, email: user.email, name: user.name, role: user.role, tenantId: user.tenantId },
    };
  }

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
