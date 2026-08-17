/**
 * Backfill memory verse data for existing Sunday School chapters.
 * Reads each chapter's content, extracts the memory verse, and updates
 * the memory_verse_ref + memory_verse_text columns.
 *
 * Run AFTER executing supabase_add_memory_verse_columns.sql in Supabase.
 *
 * Usage: node backfill_memory_verses.js
 */
const SUPABASE_URL = 'https://dbmbkevspcozcnhcsyii.supabase.co';
const ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRibWJrZXZzcGNvemNuaGNzeWlpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM3ODczNTUsImV4cCI6MjA5OTM2MzM1NX0.7W2hZ0QIBYdpZ4tYh_wl7M3SpP9NzD7QWO90QHk5FDo';
const BOOK_ID = 'd6ce2fa4-83ac-4b8d-a5fd-2fb7501cc1e1';

const BIBLE_BOOKS = [
  'Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy', 'Joshua', 'Judges',
  'Ruth', '1 Samuel', '2 Samuel', '1 Kings', '2 Kings', '1 Chronicles',
  '2 Chronicles', 'Ezra', 'Nehemiah', 'Esther', 'Job', 'Psalm', 'Psalms',
  'Proverbs', 'Ecclesiastes', 'Song of Solomon', 'Song of Songs', 'Isaiah',
  'Jeremiah', 'Lamentations', 'Ezekiel', 'Daniel', 'Hosea', 'Joel', 'Amos',
  'Obadiah', 'Jonah', 'Micah', 'Nahum', 'Habakkuk', 'Zephaniah', 'Haggai',
  'Zechariah', 'Malachi', 'Matthew', 'Mark', 'Luke', 'John', 'Acts',
  'Romans', '1 Corinthians', '2 Corinthians', 'Galatians', 'Ephesians',
  'Philippians', 'Colossians', '1 Thessalonians', '2 Thessalonians',
  '1 Timothy', '2 Timothy', 'Titus', 'Philemon', 'Hebrews', 'James',
  '1 Peter', '2 Peter', '1 John', '2 John', '3 John', 'Jude', 'Revelation'
];
const REF_PATTERN = '(?:' + BIBLE_BOOKS.map(b => b.replace(/\s+/g, '\\s*')).join('|') + ')';
const VERSE_REF_REGEX = new RegExp('^(' + REF_PATTERN + ')\\s+(\\d+)(?::(\\d+)(?:[-–](\\d+))?)?\\.?$', 'i');

function extractMemoryVerse(lessonText) {
  const mvRegex = /Memory\s*Verse\s*\n([\s\S]*?)(?=\n(?:Lesson\s|LESSON\s|I\.\s|Lesson\s*Text|Lesson\s*Objectives|--\s*\d|Central\s))/i;
  const m = mvRegex.exec(lessonText);
  if (!m) return null;
  const section = m[1].trim();
  const lines = section.split('\n').map(l => l.trim()).filter(l => l.length > 0);
  if (lines.length === 0) return null;
  let reference = '';
  let verseText = '';
  for (let i = lines.length - 1; i >= 0; i--) {
    const cleaned = lines[i].replace(/\s+/g, ' ').trim().replace(/[.…]+$/, '');
    if (VERSE_REF_REGEX.test(cleaned)) {
      reference = cleaned;
      verseText = lines.slice(0, i).join(' ').replace(/\s+/g, ' ').trim();
      break;
    }
  }
  if (!reference) {
    for (let i = 0; i < lines.length; i++) {
      const cleaned = lines[i].replace(/\s+/g, ' ').trim().replace(/[.…]+$/, '');
      if (VERSE_REF_REGEX.test(cleaned)) {
        reference = cleaned;
        verseText = lines.filter((_, j) => j !== i).join(' ').replace(/\s+/g, ' ').trim();
        break;
      }
    }
  }
  if (!reference) verseText = section.replace(/\s+/g, ' ').trim();
  return { reference, text: verseText };
}

async function main() {
  console.log('=== Backfilling Memory Verses ===\n');

  // 1. Fetch all chapters for the book
  const resp = await fetch(
    `${SUPABASE_URL}/rest/v1/sunday_school_chapters?book_id=eq.${BOOK_ID}&select=id,chapter_number,title,content&order=chapter_number.asc`,
    { headers: { apikey: ANON_KEY, Authorization: `Bearer ${ANON_KEY}` } }
  );
  if (!resp.ok) {
    const text = await resp.text();
    console.error(`Failed to fetch chapters (${resp.status}): ${text}`);
    process.exit(1);
  }
  const chapters = await resp.json();
  console.log(`Found ${chapters.length} chapters\n`);

  let updated = 0;
  let skipped = 0;

  for (const chapter of chapters) {
    const mv = extractMemoryVerse(chapter.content || '');
    if (!mv || (!mv.reference && !mv.text)) {
      console.log(`  Ch.${chapter.chapterNumber}: no memory verse found — skipping`);
      skipped++;
      continue;
    }

    // Update the chapter
    const patchResp = await fetch(
      `${SUPABASE_URL}/rest/v1/sunday_school_chapters?id=eq.${chapter.id}`,
      {
        method: 'PATCH',
        headers: {
          apikey: ANON_KEY,
          Authorization: `Bearer ${ANON_KEY}`,
          'Content-Type': 'application/json',
          Prefer: 'return=minimal',
        },
        body: JSON.stringify({
          memory_verse_ref: mv.reference,
          memory_verse_text: mv.text,
        }),
      }
    );

    if (patchResp.ok) {
      console.log(`  Ch.${chapter.chapterNumber}: ✓ "${mv.reference}" — "${mv.text.substring(0, 50)}..."`);
      updated++;
    } else {
      const text = await patchResp.text();
      console.log(`  Ch.${chapter.chapterNumber}: FAILED (${patchResp.status}): ${text}`);
      skipped++;
    }
  }

  console.log(`\n========================================`);
  console.log(`Updated: ${updated}  |  Skipped: ${skipped}`);
  console.log(`========================================`);
}

main().catch(err => { console.error('Fatal:', err); process.exit(1); });
