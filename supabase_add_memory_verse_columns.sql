-- Add memory verse columns to sunday_school_chapters table
-- Run this in the Supabase SQL Editor if you already created the table
-- from supabase_sunday_school_migration.sql

ALTER TABLE sunday_school_chapters
  ADD COLUMN IF NOT EXISTS memory_verse_ref TEXT,
  ADD COLUMN IF NOT EXISTS memory_verse_text TEXT;
