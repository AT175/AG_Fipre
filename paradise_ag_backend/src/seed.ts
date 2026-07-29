import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { AuthService } from './auth/auth.service';
import { TenantsService } from './tenants/tenants.service';

/**
 * Seed script for first-time setup.
 * Usage: npx ts-node src/seed.ts
 */
async function bootstrap() {
  const app = await NestFactory.createApplicationContext(AppModule);
  const tenantsService = app.get(TenantsService);
  const authService = app.get(AuthService);

  const tenant = await tenantsService.create({
    name: 'Paradise AG Headquarters',
    slug: 'paradise-ag-hq',
    subscriptionTier: 'premium',
  });

  const admin = await authService.register({
    name: 'System Administrator',
    email: 'admin@paradiseag.local',
    password: 'ChangeMe123!',
    role: 'super_system_admin',
    tenantId: tenant.id,
  });

  console.log('Created tenant:', tenant.id, tenant.slug);
  console.log('Created super admin:', admin.email);

  await app.close();
}

bootstrap().catch((err) => {
  console.error(err);
  process.exit(1);
});
