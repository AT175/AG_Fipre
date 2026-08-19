-- ─────────────────────────────────────────────────────────────────────────────
-- Paradise AG — Supabase RLS Migration (Part 6): Catch-all anon policies
-- ─────────────────────────────────────────────────────────────────────────────
-- Ensures EVERY table in the public schema has an anon_all_* RLS policy.
-- Previous migrations (parts 1-5) covered specific tables but missed some
-- (e.g. sunday_school_books, sunday_school_chapters, organizations, regions,
-- districts, areas, notifications, etc.).
--
-- This script dynamically creates anon_all_* policies for ALL tables that
-- don't already have one, fixing all remaining 401 Unauthorized errors.
-- ─────────────────────────────────────────────────────────────────────────────

DO $$
DECLARE
    r RECORD;
    policy_name TEXT;
BEGIN
    FOR r IN
        SELECT t.table_name
        FROM information_schema.tables t
        WHERE t.table_schema = 'public'
          AND t.table_type = 'BASE TABLE'
          AND NOT EXISTS (
              SELECT 1 FROM pg_policies p
              WHERE p.schemaname = 'public'
                AND p.tablename = t.table_name
                AND 'anon' = ANY(p.roles)
                AND p.cmd = 'ALL'
          )
    LOOP
        -- Enable RLS on the table
        EXECUTE format('ALTER TABLE IF EXISTS %I ENABLE ROW LEVEL SECURITY', r.table_name);

        -- Drop any existing anon_all_* policy (in case of partial creation)
        policy_name := 'anon_all_' || r.table_name;
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I', policy_name, r.table_name);

        -- Create the anon_all_* policy
        EXECUTE format(
            'CREATE POLICY %I ON %I FOR ALL TO anon, authenticated USING (true) WITH CHECK (true)',
            policy_name, r.table_name
        );

        RAISE NOTICE 'Created anon policy on table: %', r.table_name;
    END LOOP;
END $$;

-- ── Verify: list all tables and whether they have an anon policy ────────────
SELECT
    t.table_name,
    CASE
        WHEN EXISTS (
            SELECT 1 FROM pg_policies p
            WHERE p.schemaname = 'public'
              AND p.tablename = t.table_name
              AND 'anon' = ANY(p.roles)
              AND p.cmd = 'ALL'
        ) THEN 'YES'
        ELSE 'NO'
    END AS has_anon_policy
FROM information_schema.tables t
WHERE t.table_schema = 'public'
  AND t.table_type = 'BASE TABLE'
ORDER BY t.table_name;
