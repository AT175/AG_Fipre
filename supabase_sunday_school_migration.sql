-- ── Sunday School tables ─────────────────────────────────────────────────
-- Run this in the Supabase SQL Editor (Dashboard → SQL → New query)

-- Sunday School books (with start/end dates for chapter→Sunday mapping)
CREATE TABLE IF NOT EXISTS sunday_school_books (
  id TEXT PRIMARY KEY,
  tenant_id TEXT,
  title TEXT NOT NULL,
  author TEXT,
  description TEXT,
  download_url TEXT,
  cover_color TEXT,
  added_by_id TEXT,
  added_by_name TEXT,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_chapters INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE sunday_school_books ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_sunday_school_books" ON sunday_school_books;
CREATE POLICY "anon_all_sunday_school_books" ON sunday_school_books
  FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- Sunday School chapters (each mapped to a specific Sunday)
CREATE TABLE IF NOT EXISTS sunday_school_chapters (
  id TEXT PRIMARY KEY,
  tenant_id TEXT,
  book_id TEXT NOT NULL,
  chapter_number INTEGER NOT NULL,
  title TEXT,
  content TEXT,
  sunday_date DATE NOT NULL,
  discussion_post_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE sunday_school_chapters ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_sunday_school_chapters" ON sunday_school_chapters;
CREATE POLICY "anon_all_sunday_school_chapters" ON sunday_school_chapters
  FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE INDEX IF NOT EXISTS idx_ss_chapters_book ON sunday_school_chapters(book_id);
CREATE INDEX IF NOT EXISTS idx_ss_chapters_tenant ON sunday_school_chapters(tenant_id);
CREATE INDEX IF NOT EXISTS idx_ss_books_tenant ON sunday_school_books(tenant_id);
