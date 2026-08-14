import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { AuthService } from './auth/auth.service';
import { TenantsService } from './tenants/tenants.service';

/**
 * Seed script for first-time setup.
 * Usage: npx ts-node src/seed.ts
 *
 * Super admin credentials are read from environment variables:
 *   SEED_SUPER_ADMIN_EMAIL
 *   SEED_SUPER_ADMIN_PASSWORD
 * Church admin credentials are read from:
 *   SEED_CHURCH_ADMIN_PASSWORD
 * If not provided, secure random defaults are generated and printed once.
 */
function requireEnv(name: string, fallback?: string): string {
  const value = process.env[name] ?? fallback;
  if (!value) {
    throw new Error(
      `Missing required environment variable: ${name}. Set it before running the seed script.`,
    );
  }
  return value;
}

function randomPassword(): string {
  return `Ag${Math.random().toString(36).slice(-8)}!${Math.floor(
    Math.random() * 100,
  )}`;
}

async function bootstrap() {
  const app = await NestFactory.createApplicationContext(AppModule);
  const tenantsService = app.get(TenantsService);
  const authService = app.get(AuthService);

  const superAdminEmail = requireEnv(
    'SEED_SUPER_ADMIN_EMAIL',
    'superadmin@paradiseag.org.gh',
  );
  const superAdminPassword =
    process.env.SEED_SUPER_ADMIN_PASSWORD ?? randomPassword();
  const churchAdminPassword =
    process.env.SEED_CHURCH_ADMIN_PASSWORD ?? randomPassword();

  if (!process.env.SEED_SUPER_ADMIN_PASSWORD) {
    console.warn(
      `SEED_SUPER_ADMIN_PASSWORD not set. Generated password: ${superAdminPassword}\nSave this now — it will not be shown again.`,
    );
  }
  if (!process.env.SEED_CHURCH_ADMIN_PASSWORD) {
    console.warn(
      `SEED_CHURCH_ADMIN_PASSWORD not set. Generated password: ${churchAdminPassword}\nSave this now — it will not be shown again.`,
    );
  }

  const churches = [
    {
      name: 'Paradise AG Headquarters',
      slug: 'paradise-ag-hq',
      subscriptionTier: 'premium',
      address: 'Accra, Ghana',
      phone: '+233 30 000 0000',
      email: 'hq@paradiseag.org.gh',
      primaryColor: '#2E7D32',
      secondaryColor: '#FFD600',
      motto: 'Reflecting Christ, Transforming Lives',
    },
    {
      name: 'Grace Assembly Kumasi',
      slug: 'grace-assembly-kumasi',
      subscriptionTier: 'standard',
      address: 'Kumasi, Ashanti Region',
      phone: '+233 32 000 0001',
      email: 'grace@assembliesofgod.org.gh',
      primaryColor: '#1565C0',
      secondaryColor: '#FFD600',
      motto: 'Grace and Truth in Christ',
    },
    {
      name: 'Calvary Assembly Tamale',
      slug: 'calvary-assembly-tamale',
      subscriptionTier: 'basic',
      address: 'Tamale, Northern Region',
      phone: '+233 37 000 0002',
      email: 'calvary@assembliesofgod.org.gh',
      primaryColor: '#6A1B9A',
      secondaryColor: '#FFD600',
      motto: 'The Cross, Our Foundation',
    },
  ];

  for (const church of churches) {
    try {
      const tenant = await tenantsService.create(church as any);

      const isAdmin = church.slug === 'paradise-ag-hq';
      const admin = await authService.register({
        name: isAdmin ? 'System Administrator' : `Admin ${church.name}`,
        email: isAdmin ? superAdminEmail : `admin@${church.slug}.local`,
        password: isAdmin ? superAdminPassword : churchAdminPassword,
        role: isAdmin ? 'super_system_admin' : 'local_church_admin',
        tenantId: tenant.id,
      });

      console.log(`Created tenant: ${tenant.name} (${tenant.slug})`);
      console.log(`Created ${admin.role}: ${admin.email}`);
    } catch (err: any) {
      if (err?.message?.includes('already')) {
        console.log(`Skipped (exists): ${church.name}`);
      } else {
        console.error(`Error creating ${church.name}:`, err.message);
      }
    }
  }

  await app.close();
}

bootstrap().catch((err) => {
  console.error(err);
  process.exit(1);
});
