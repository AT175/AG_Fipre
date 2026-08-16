-- ─────────────────────────────────────────────────────────────────────────────
-- Paradise AG — Supabase RLS Migration
-- Run this in the Supabase Dashboard → SQL Editor → New query → Paste → Run
--
-- This fixes the sync between the Flutter app and Supabase by:
-- 1. Adding RLS policies that allow the anon key (the app uses the anon key,
--    not Supabase Auth, so "authenticated" policies block all sync operations)
-- 2. Adding tenant_id columns to tables that need church scoping but don't
--    have one yet
-- ─────────────────────────────────────────────────────────────────────────────

-- ── 1. Drop existing "authenticated" policies and replace with "anon" policies ──
-- The Flutter app authenticates against the NestJS backend (not Supabase Auth),
-- so it only has the anon key. We need anon-accessible policies for sync to work.

-- Users table
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "authenticated_all_users" ON users;
DROP POLICY IF EXISTS "anon_all_users" ON users;
CREATE POLICY "anon_all_users" ON users FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- Tenants table
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "authenticated_all_tenants" ON tenants;
DROP POLICY IF EXISTS "anon_all_tenants" ON tenants;
CREATE POLICY "anon_all_tenants" ON tenants FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- Members table
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "authenticated_all_members" ON members;
DROP POLICY IF EXISTS "anon_all_members" ON members;
CREATE POLICY "anon_all_members" ON members FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- Branches table (if it exists)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'branches') THEN
    ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
    DROP POLICY IF EXISTS "authenticated_all_branches" ON branches;
    DROP POLICY IF EXISTS "anon_all_branches" ON branches;
    CREATE POLICY "anon_all_branches" ON branches FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
  END IF;
EXCEPTION WHEN OTHERS THEN NULL; END $$;

-- Departments table (if it exists)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'departments') THEN
    ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
    DROP POLICY IF EXISTS "authenticated_all_departments" ON departments;
    DROP POLICY IF EXISTS "anon_all_departments" ON departments;
    CREATE POLICY "anon_all_departments" ON departments FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
  END IF;
EXCEPTION WHEN OTHERS THEN NULL; END $$;

-- Sermons table (if it exists)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'sermons') THEN
    ALTER TABLE sermons ENABLE ROW LEVEL SECURITY;
    DROP POLICY IF EXISTS "authenticated_all_sermons" ON sermons;
    DROP POLICY IF EXISTS "anon_all_sermons" ON sermons;
    CREATE POLICY "anon_all_sermons" ON sermons FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
  END IF;
EXCEPTION WHEN OTHERS THEN NULL; END $$;

-- Events table (if it exists)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'events') THEN
    ALTER TABLE events ENABLE ROW LEVEL SECURITY;
    DROP POLICY IF EXISTS "authenticated_all_events" ON events;
    DROP POLICY IF EXISTS "anon_all_events" ON events;
    CREATE POLICY "anon_all_events" ON events FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
  END IF;
EXCEPTION WHEN OTHERS THEN NULL; END $$;

-- ── 2. Create missing tables for app sync ──────────────────────────────────────
-- These tables are needed by the Flutter app but may not exist yet (the NestJS
-- backend only creates tables for its own entities via TypeORM).

-- Community tables
CREATE TABLE IF NOT EXISTS community_posts (
  id TEXT PRIMARY KEY,
  tenant_id TEXT,
  author_id TEXT NOT NULL,
  author_name TEXT NOT NULL,
  author_role TEXT,
  text_content TEXT,
  media_url TEXT,
  media_type TEXT DEFAULT 'text',
  likes_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE community_posts ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_community_posts" ON community_posts;
CREATE POLICY "anon_all_community_posts" ON community_posts FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
CREATE INDEX IF NOT EXISTS idx_community_posts_tenant ON community_posts(tenant_id);

CREATE TABLE IF NOT EXISTS community_comments (
  id TEXT PRIMARY KEY,
  tenant_id TEXT,
  post_id TEXT NOT NULL,
  author_id TEXT NOT NULL,
  author_name TEXT NOT NULL,
  author_role TEXT,
  text_content TEXT NOT NULL,
  parent_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE community_comments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_community_comments" ON community_comments;
CREATE POLICY "anon_all_community_comments" ON community_comments FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
CREATE INDEX IF NOT EXISTS idx_community_comments_post ON community_comments(post_id);

CREATE TABLE IF NOT EXISTS community_conversations (
  id TEXT PRIMARY KEY,
  tenant_id TEXT,
  participant1_id TEXT NOT NULL,
  participant2_id TEXT NOT NULL,
  last_message TEXT,
  last_message_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE community_conversations ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_community_conversations" ON community_conversations;
CREATE POLICY "anon_all_community_conversations" ON community_conversations FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
CREATE INDEX IF NOT EXISTS idx_community_convos_tenant ON community_conversations(tenant_id);

CREATE TABLE IF NOT EXISTS community_messages (
  id TEXT PRIMARY KEY,
  tenant_id TEXT,
  conversation_id TEXT NOT NULL,
  sender_id TEXT NOT NULL,
  sender_name TEXT,
  text_content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE community_messages ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_community_messages" ON community_messages;
CREATE POLICY "anon_all_community_messages" ON community_messages FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
CREATE INDEX IF NOT EXISTS idx_community_messages_convo ON community_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_community_messages_tenant ON community_messages(tenant_id);

-- Library tables
CREATE TABLE IF NOT EXISTS library_books (
  id TEXT PRIMARY KEY,
  tenant_id TEXT,
  title TEXT NOT NULL,
  author TEXT,
  description TEXT,
  cover_url TEXT,
  download_url TEXT,
  category TEXT,
  book_type TEXT DEFAULT 'book',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE library_books ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_library_books" ON library_books;
CREATE POLICY "anon_all_library_books" ON library_books FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS devotion_guides (
  id TEXT PRIMARY KEY,
  tenant_id TEXT,
  title TEXT NOT NULL,
  scripture TEXT,
  content TEXT,
  prayer_points TEXT,
  day_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE devotion_guides ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_devotion_guides" ON devotion_guides;
CREATE POLICY "anon_all_devotion_guides" ON devotion_guides FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS bible_study_resources (
  id TEXT PRIMARY KEY,
  tenant_id TEXT,
  title TEXT NOT NULL,
  description TEXT,
  content TEXT,
  questions TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE bible_study_resources ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_bible_study_resources" ON bible_study_resources;
CREATE POLICY "anon_all_bible_study_resources" ON bible_study_resources FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- ── 3. Add tenant_id to tables that need church scoping ───────────────────────
-- The NestJS backend's TypeORM may not have added tenant_id to all tables.
-- These ALTER statements are safe to run multiple times (IF NOT EXISTS pattern).

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'members' AND column_name = 'tenant_id') THEN
    ALTER TABLE members ADD COLUMN tenant_id TEXT;
  END IF;
EXCEPTION WHEN OTHERS THEN NULL; END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'sermons' AND column_name = 'tenant_id') THEN
    ALTER TABLE sermons ADD COLUMN tenant_id TEXT;
  END IF;
EXCEPTION WHEN OTHERS THEN NULL; END $$;

-- ── 4. Verify ─────────────────────────────────────────────────────────────────
-- After running, you should see the policies in Supabase Dashboard →
-- Authentication → Policies → users table → should show "anon_all_users"
-- allowing all operations for anon role.

SELECT 'Migration complete! RLS policies updated for anon access.' as result;
