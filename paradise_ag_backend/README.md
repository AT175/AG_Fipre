# Paradise AG Backend

NestJS backend for the Paradise AG white-label church management app.

## Setup

1. Copy `.env.example` to `.env` and fill in your PostgreSQL credentials.
2. Install dependencies:
   ```bash
   npm install
   ```
3. Run database migrations:
   ```bash
   npm run migration:run
   ```
4. Start the development server:
   ```bash
   npm run start:dev
   ```

The API will be available at `http://localhost:3000/api`.

## Architecture

- **Auth**: JWT-based authentication with role-based access control.
- **Tenants**: Each church is a tenant; data is isolated by `tenant_id`.
- **Members**: Example domain module showing tenant-scoped CRUD.
