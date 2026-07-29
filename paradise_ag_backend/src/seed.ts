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
        email: isAdmin
          ? 'admin@paradiseag.local'
          : `admin@${church.slug}.local`,
        password: 'ChangeMe123!',
        role: isAdmin ? 'super_system_admin' : 'church_admin',
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
