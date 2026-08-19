-- ─────────────────────────────────────────────────────────────────────────────
-- Paradise AG — Populate bible_study_resources with free Bible/Christian resources
-- ─────────────────────────────────────────────────────────────────────────────
-- Inserts a comprehensive collection of Bible study resources with links to
-- free Bible study tools, commentaries, concordances, dictionaries, and
-- Christian study materials from around the world.
-- ─────────────────────────────────────────────────────────────────────────────

-- Use the ParadiseAg tenant ID
DO $$
DECLARE
    tid TEXT := 'a2cdda2c-37f4-4436-b215-916e5cec2952';
    now_ts TIMESTAMPTZ := NOW();
BEGIN
    -- Clear existing (if any)
    DELETE FROM bible_study_resources WHERE tenant_id = tid;

    -- ── 1. Bible Study Tools & Platforms ──────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-001', tid, 'Bible Gateway — Free Online Bible in 100+ Translations',
    'Bible Gateway is a free online Bible tool offering 100+ translations in 60+ languages. Read, search, compare, and study the Bible with audio, reading plans, and devotionals.',
    'Bible Gateway (https://www.biblegateway.com) is the most popular free online Bible platform. Features include:

• 100+ Bible translations in 60+ languages (NIV, KJV, ESV, NLT, NASB, NKJV, AMP, MSG, and more)
• Audio Bibles in multiple translations
• Reading plans (through-the-Bible-in-a-year, chronological, topical)
• Advanced search: find any verse, keyword, or phrase across all translations
• Side-by-side passage comparison (up to 5 translations at once)
• Free daily devotionals from well-known authors
• Bible Gateway Plus: study commentaries, dictionaries, and encyclopedias

How to use: Go to https://www.biblegateway.com, type a verse or keyword in the search bar, select your preferred translation, and start reading. Create a free account to save highlights, notes, and reading plans.

Recommended for: All members — from new believers to seasoned Bible students.',
    '["Which Bible translation do you find easiest to understand, and why?", "Try reading John 3:16 in three different translations — what differences do you notice?", "Set up a free Bible Gateway account and start a reading plan this week."]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-002', tid, 'Blue Letter Bible — Free Study Tools & Commentaries',
    'Blue Letter Bible provides free access to Bible study tools including commentaries, concordances, lexicons, interlinear Bibles, and word studies in the original Greek and Hebrew.',
    'Blue Letter Bible (https://www.blueletterbible.org) is a free, in-depth Bible study platform. Features include:

• Interlinear Bible (Hebrew/Greek with English)
• Strong''s Concordance integration — click any word to see its original meaning
• Multiple free commentaries (Chuck Smith, David Guzik, Matthew Henry, John Gill, etc.)
• Bible lexicons (Thayer''s, BDB, Gesenius)
• Word studies with original language analysis
• Audio/video teaching from trusted pastors
• Bible reading plans and daily devotionals
• Maps, timelines, and charts
• Mobile apps for iOS and Android

How to use: Go to https://www.blueletterbible.org, search for a verse, then click the "Tools" button next to any verse to access commentaries, lexicons, and word studies.

Recommended for: Pastors, teachers, and serious Bible students who want to dig into the original languages.',
    '["Look up the Greek word for "love" in John 3:16 (agape) — what does it mean?", "Read David Guzik''s commentary on a passage you are studying this week.", "How does understanding the original Hebrew/Greek word change your understanding of a verse?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-003', tid, 'Bible Hub — Multi-Translation Search & Study',
    'Bible Hub offers free online Bible search, parallel translations, interlinear Hebrew/Greek, commentaries, concordances, sermons, and topical studies.',
    'Bible Hub (https://biblehub.com) is a comprehensive free Bible study resource. Features include:

• Parallel Bible — view up to 20 translations side by side
• Interlinear Bible (Hebrew OT, Greek NT with literal English)
• Strong''s Concordance with Hebrew and Greek lexicons
• Free commentaries: Matthew Henry, John Gill, Adam Clarke, Albert Barnes, Pulpit Commentary, Ellicott''s, Cambridge, B.W. Johnson
• Topical Bible (Nave''s, Torrey''s, Thompson Chain)
• Bible atlas and maps
• Sermon illustrations and outlines
• Daily verse and devotional
• Multi-language Bibles (Spanish, French, German, Portuguese, Chinese, Arabic, and more)

How to use: Go to https://biblehub.com, enter a verse reference, and explore the tabs: Parallel, Interlinear, Greek, Hebrew, Commentaries, Topical, Atlas, and more.

Recommended for: Cross-referencing multiple translations and accessing classic commentaries for free.',
    '["Compare Romans 8:28 across 5 different translations — which wording speaks to you most?", "Read Matthew Henry''s commentary on a familiar passage — what new insight do you gain?", "Use the Topical Bible to find all verses about "faith" — how many can you find?"]',
    now_ts, now_ts);

    -- ── 2. Free Commentaries & Study Bibles ───────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-004', tid, 'Matthew Henry''s Commentary on the Whole Bible (Free)',
    'Matthew Henry''s Complete Commentary on the Bible — one of the most widely read and respected Bible commentaries, available free online.',
    'Matthew Henry''s Commentary (1706-1710) is one of the most beloved and enduring Bible commentaries in church history. It provides verse-by-verse exposition with practical application, spiritual insight, and devotional warmth.

Free online access:
• https://www.biblegateway.com/resources/matthew-henry-complete/ — full commentary on Bible Gateway
• https://www.blueletterbible.org/Comm/mhc/ — on Blue Letter Bible
• https://biblehub.com/commentaries/mhc/ — on Bible Hub
• https://ccel.org/ccel/henry/mhc1.html — on Christian Classics Ethereal Library

Features:
• Verse-by-verse commentary on the entire Bible
• Practical and devotional application
• Accessible language (written for ordinary readers, not just scholars)
• Protestant evangelical perspective
• Originally published in 6 volumes (1706-1710)

Recommended for: Personal study, sermon preparation, small group discussions, and devotional reading.',
    '["Read Henry''s commentary on Genesis 1 — what does he emphasize about creation?", "How does Henry apply the story of David and Goliath to the Christian life?", "What makes Henry''s commentary different from modern scholarly commentaries?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-005', tid, 'David Guzik''s Enduring Word Commentary (Free)',
    'David Guzik''s verse-by-verse commentary on the whole Bible — modern, accessible, and freely available online. Practical, pastoral, and easy to understand.',
    'David Guzik''s Enduring Word Commentary is a modern, free, verse-by-verse commentary on the entire Bible. It is widely used by pastors, small group leaders, and individual believers.

Free online access:
• https://enduringword.com/ — official site with full commentary
• https://www.blueletterbible.org/Comm/guzik/ — on Blue Letter Bible

Features:
• Verse-by-verse commentary on every book of the Bible
• Modern, clear, and practical language
• Pastoral perspective with application for daily life
• Background and context for each passage
• Cross-references to related verses
• Available in multiple languages (Spanish, Arabic, Chinese, Russian, and more)
• Free mobile app (Enduring Word)

Recommended for: Small group leaders, pastors, and anyone wanting a clear, practical explanation of any Bible passage.',
    '["Read Guzik''s commentary on a passage you are studying this week.", "How does Guzik''s modern perspective compare to Matthew Henry''s?", "What practical application does Guzik draw from the passage?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-006', tid, 'John Gill''s Exposition of the Bible (Free)',
    'John Gill''s verse-by-verse exposition of the entire Bible — a Reformed Baptist classic with deep Hebrew and Greek insights. Available free online.',
    'John Gill''s Exposition of the Old and New Testaments (1746-1766) is one of the most thorough verse-by-verse commentaries ever written, with extensive Hebrew and Greek analysis.

Free online access:
• https://www.blueletterbible.org/Comm/gill/ — on Blue Letter Bible
• https://biblehub.com/commentaries/gill/ — on Bible Hub
• https://ccel.org/ccel/gill/exposition.html — on CCEL

Features:
• Verse-by-verse exposition of the entire Bible
• Extensive original language (Hebrew/Greek) analysis
• Reformed Baptist theological perspective
• Detailed word studies and etymological notes
• Historical and cultural context
• Defense of conservative, Calvinist theology

Recommended for: Pastors, theology students, and those wanting deep original-language insight.',
    '["Compare Gill''s commentary with Guzik''s on the same passage — what differences do you notice?", "What Hebrew or Greek insight does Gill provide that you hadn''t considered before?", "How does Gill''s Reformed perspective shape his interpretation?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-007', tid, 'Albert Barnes'' Notes on the Bible (Free)',
    'Albert Barnes'' verse-by-verse commentary — clear, practical, and widely used. Available free online on multiple platforms.',
    'Albert Barnes'' Notes on the Old and New Testaments (1832-1870) is a classic commentary known for its clarity, practical application, and accessibility.

Free online access:
• https://biblehub.com/commentaries/barnes/ — on Bible Hub
• https://www.blueletterbible.org/Comm/barnes/ — on Blue Letter Bible
• https://ccel.org/ccel/barnes/notes.html — on CCEL

Features:
• Verse-by-verse commentary on the entire Bible
• Clear, practical, and easy to understand
• Presbyterian perspective
• Historical and geographical notes
• Cross-references and word studies
• Suitable for both pastors and laypeople

Recommended for: Sunday School teachers, small group leaders, and personal study.',
    '["Read Barnes'' notes on the Sermon on the Mount (Matthew 5-7) — what stands out?", "How does Barnes explain a difficult verse you''ve been wrestling with?", "What practical application does Barnes draw from the passage?"]',
    now_ts, now_ts);

    -- ── 3. Original Language Tools ─────────────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-008', tid, 'StepBible — Free Greek & Hebrew Word Study Tool',
    'STEP (Scripture Tools for Every Person) provides free access to the original Greek and Hebrew Bible with word studies, lexicons, and interlinear text.',
    'STEP Bible (https://www.stepbible.org) is a free tool created by Tyndale House Cambridge for studying the Bible in its original languages. It is designed for people with no knowledge of Greek or Hebrew.

Features:
• Interlinear Bible (Greek NT, Hebrew OT with English)
• Click any word to see its meaning, grammar, and usage
• Strong''s numbers integrated
• Multiple lexicons (LSJ, BDAG, BDB, Gesenius)
• Word frequency and usage statistics
• Grammatical analysis of every word
• Search by Greek/Hebrew word or English translation
• Free — no account required
• Available in many languages
• Mobile-friendly

How to use: Go to https://www.stepbible.org, type a verse reference, and click on any word (Greek or Hebrew) to see its full analysis, meaning, and everywhere it is used in the Bible.

Recommended for: Anyone wanting to understand the original meaning of Bible words without needing to know Greek or Hebrew.',
    '["Look up the Greek word "pisteuo" (believe) in John 3:16 — what does it mean?", "Find all the places where the Hebrew word "chesed" (lovingkindness) appears in the Psalms.", "How does the original Greek change your understanding of a familiar verse?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-009', tid, 'NET Bible — Free Study Bible with Translator Notes',
    'The NET Bible (New English Translation) is a completely free online study Bible with 60,932 translator notes explaining translation decisions, textual variants, and interpretive choices.',
    'The NET Bible (https://netbible.org) is a free, modern English translation with extensive study notes. It is unique because every translation decision is documented in the notes.

Free online access:
• https://netbible.org — official NET Bible site
• https://lumina.bible.org — NET Bible with advanced study tools
• Free NET Bible app for iOS and Android

Features:
• Completely free translation (can be downloaded and shared freely)
• 60,932 translator notes explaining every significant translation decision
• Text-critical notes on manuscript variants
• Study notes on interpretation and application
• Maps, charts, and diagrams
• Greek and Hebrew text alongside the translation
• Audio Bible (NET)
• Free for ministry use (can be printed, distributed, quoted without permission)

Recommended for: Anyone wanting to understand why translators chose specific English words, and for those who want a reliable, free, modern translation.',
    '["Read the translator notes on Genesis 1:1 — what translation challenges does the NET address?", "Compare the NET with the NIV on a familiar passage — what differences do you find?", "What does a "textual variant" note tell you about the reliability of the Bible?"]',
    now_ts, now_ts);

    -- ── 4. Topical & Thematic Studies ──────────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-010', tid, 'Nave''s Topical Bible — Free Online (2,000+ Topics)',
    'Nave''s Topical Bible is a free online reference listing Bible verses by topic — over 2,000 topics with 100,000+ scripture references.',
    'Nave''s Topical Bible (https://biblehub.com/topical/naves/) is one of the most comprehensive topical Bible references available. It organizes Bible verses by topic, making it easy to find what the Bible says about any subject.

Free online access:
• https://biblehub.com/topical/naves/ — on Bible Hub
• https://www.biblegateway.com/quicksearch/?quicksearch= — Bible Gateway search
• https://www.openbible.info/topics/ — Open Bible topical search

Features:
• 2,000+ topics organized alphabetically
• 100,000+ scripture references
• Cross-references between related topics
• Search by topic name (e.g., "faith", "prayer", "salvation")
• Sub-topics for deeper study (e.g., "Faith — definition of", "Faith — examples of")
• Free and accessible online

How to use: Go to https://biblehub.com/topical/naves/, type a topic (like "prayer" or "forgiveness"), and get a list of every Bible verse on that topic.

Recommended for: Topical studies, sermon preparation, counseling, and personal study on specific themes.',
    '["Look up "prayer" in Nave''s Topical Bible — how many verses are listed?", "Choose a topic you want to study (e.g., "forgiveness") and read 5 verses on it.", "How does studying a topic topically differ from studying a book verse-by-verse?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-011', tid, 'Open Bible — Free Topical Bible & Sermon Prep',
    'Open Bible provides free topical Bible search, sermon illustrations, sermon outlines, and Bible study tools for pastors and small group leaders.',
    'Open Bible (https://www.openbible.info) is a free resource for topical Bible study, sermon preparation, and finding Bible verses on any topic.

Features:
• Topical Bible search (https://www.openbible.info/topics/) — find verses on any topic
• Sermon illustrations (https://www.openbible.info/illustrations/) — real-life stories for sermons
• Sermon outlines (https://www.openbible.info/sermons/) — free sermon outlines by topic
• Bible trivia and quizzes
• Daily Bible verse
• "What does the Bible say about..." guides
• Free — no account required

How to use: Go to https://www.openbible.info/topics/, type any topic (e.g., "anxiety", "marriage", "giving"), and get a curated list of relevant Bible verses with brief commentary.

Recommended for: Pastors preparing sermons, small group leaders choosing topics, and anyone wanting to know what the Bible says about a specific subject.',
    '["Search for "anxiety" on Open Bible — what verses does it recommend?", "Find a sermon illustration on Open Bible that you could use in your next message.", "What topic would you like to study, and what verses does Open Bible suggest?"]',
    now_ts, now_ts);

    -- ── 5. Free Bible Study Courses ────────────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-012', tid, 'BibleProject — Free Animated Bible Videos & Study Guides',
    'BibleProject provides free animated videos explaining every book of the Bible, key themes, and biblical concepts. Includes study notes, podcasts, and a free classroom curriculum.',
    'BibleProject (https://bibleproject.com) is a free, nonprofit media studio that creates animated videos to help people understand the Bible. It is one of the most popular Bible study resources in the world.

Free resources:
• https://bibleproject.com/classroom/ — free Bible study courses with video lessons and study notes
• https://bibleproject.com/explore/ — explore topics, themes, and book overviews
• https://bibleproject.com/podcasts/ — free podcasts on biblical theology
• Free BibleProject app for iOS and Android

Features:
• Animated videos for every book of the Bible (5-8 min each)
• Thematic videos (e.g., "The Messiah", "Heaven & Earth", "The Covenants")
• Word study videos (e.g., "chesed", "shalom", "yirah")
• BibleProject Classroom — free structured courses with quizzes
• Study notes and downloadable resources
• Available in multiple languages
• Completely free (donor-supported nonprofit)

How to use: Go to https://bibleproject.com/explore/topic/ or https://bibleproject.com/explore/book-of/ to find videos on any book or theme. Use the Classroom for structured study.

Recommended for: Visual learners, new believers, small groups, and anyone wanting a big-picture overview of the Bible.',
    '["Watch the BibleProject video on the book of John — what is the main theme?", "Explore the "Messiah" theme video — how does it connect the Old and New Testaments?", "Take a BibleProject Classroom course on a book you want to study."]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-013', tid, 'Free Bible College Courses Online (Multiple Sources)',
    'Access free Bible college-level courses from trusted seminaries and Bible colleges — including lectures, syllabi, and study materials at no cost.',
    'Several reputable seminaries and Bible colleges offer free online courses with full lecture videos, notes, and study materials:

1. Biblical Training (https://www.biblicaltraining.org)
   • Free courses from seminary professors
   • Topics: Old Testament, New Testament, Theology, Church History, Apologetics
   • Three levels: Foundations, Leadership, Institute
   • Free account required

2. Dallas Theological Seminary (https://courses.dts.edu)
   • Free online courses from DTS faculty
   • Topics: Bible study methods, Old/New Testament survey, theology
   • Video lectures + study guides
   • Free account required

3. Covenant Theological Seminary (https://mbs.covenantseminary.edu)
   • Free "Mobile Ed" courses
   • Biblical studies, theology, practical ministry
   • Audio + video lectures

4. Reformed Theological Seminary (https://subsplash.com/rts)
   • Free RTS Global courses
   • Lectures from RTS faculty
   • Theology, biblical studies, church history

5. Third Millennium Ministries (https://thirdmill.org)
   • Free seminary-level courses in multiple languages
   • Video-based curriculum
   • Available in English, Spanish, Arabic, Chinese, Russian, and more

How to use: Choose a platform, create a free account, and start with a "Foundations" or "Survey" course. Most courses include video lectures, reading assignments, and quizzes.

Recommended for: Church leaders, serious Bible students, and anyone wanting seminary-level education for free.',
    '["Sign up for a free course on Biblical Training and start the first lesson.", "What is the difference between a "survey" course and a "theology" course?", "How can you use free online courses to grow in your understanding of God''s Word?"]',
    now_ts, now_ts);

    -- ── 6. Cross-Reference & Study Tools ───────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-014', tid, 'Bible Cross-References — Treasury of Scripture Knowledge (Free)',
    'The Treasury of Scripture Knowledge (TSK) is the largest free collection of Bible cross-references — over 500,000 references linking related verses across the entire Bible.',
    'The Treasury of Scripture Knowledge (TSK) is a classic cross-reference tool that helps you interpret Scripture with Scripture. It contains over 500,000 cross-references, linking verses that share themes, words, or concepts.

Free online access:
• https://www.blueletterbible.org/ — click "Concordances" then "Treasury of Scripture Knowledge" on any verse
• https://biblehub.com/tsk/ — on Bible Hub
• https://www.openbible.info/labs/cross-references/ — Open Bible cross-references

Features:
• 500,000+ cross-references across the entire Bible
• Links verses by theme, word, concept, and prophecy fulfillment
• Helps you interpret Scripture with Scripture
• Available free on multiple platforms
• Useful for topical study and sermon preparation
• Originally compiled in the 1830s, still widely used today

How to use: Look up any verse (e.g., John 3:16) on Blue Letter Bible or Bible Hub, and find the "Treasury of Scripture Knowledge" section. It will list related verses that expand on the same theme or concept.

Recommended for: Deep Bible study, sermon preparation, and understanding how the Bible interprets itself.',
    '["Look up the TSK cross-references for Genesis 1:1 — what verses are linked?", "Find the cross-references for a prophecy in Isaiah and its fulfillment in the New Testament.", "How does using cross-references help you interpret a difficult verse?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-015', tid, 'Logos Bible Study — Free Basic Edition',
    'Logos Bible Software offers a free basic edition with Bible study tools, search, reading plans, and access to a small library of free resources.',
    'Logos Bible Software (https://www.logos.com) is one of the most powerful Bible study platforms available. While the full version is paid, Logos offers a free "Basic" edition with useful tools.

Free features (Logos Basic):
• Free Bible translations (ESV, KJV, NKJV, NASB 1995, LEB)
• Search across multiple translations
• Bible reading plans
• Basic note-taking and highlighting
• Passage Guide and Exegetical Guide (limited)
• Free resources: Lexham Bible Dictionary, Lexham English Bible, Faithlife Study Bible
• Mobile app for iOS and Android

How to get it: Go to https://www.logos.com/basic, create a free account, and download the Logos app for your platform (Windows, Mac, iOS, Android).

Limitations: The free edition has a limited library. Advanced commentaries, lexicons, and study tools require paid packages. However, the free tools are still very useful for personal study.

Recommended for: Those who want a powerful desktop/mobile Bible study app and are willing to upgrade later if needed.',
    '["Download Logos Basic and set up a reading plan.", "Use the Lexham Bible Dictionary (free in Logos) to look up a topic.", "How does Logos compare to the free online tools like Bible Gateway and Blue Letter Bible?"]',
    now_ts, now_ts);

    -- ── 7. Devotional & Practical Study ────────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-016', tid, 'YouVersion Bible App — Free Bibles, Reading Plans & Devotionals',
    'YouVersion (Bible.com) offers a free Bible app with 2,000+ translations, 4,000+ reading plans, audio Bibles, and devotionals in 1,300+ languages.',
    'YouVersion (https://www.bible.com) is the world''s most popular Bible app, with over 500 million downloads. It is completely free and offers an enormous library of Bible study resources.

Free features:
• 2,000+ Bible translations in 1,300+ languages
• 4,000+ reading plans (topical, through-the-Bible, thematic, devotional)
• Audio Bibles in multiple translations and languages
• Free devotionals from well-known authors and ministries
• Verse of the day with images (shareable)
• Highlighting, bookmarking, and note-taking
• Friends and community features (share plans, compare notes)
• Prayer feature (track and share prayer requests)
• Live events (follow along with sermons in real-time)
• Free apps for iOS, Android, Web, Amazon, and more

How to use: Download the "Bible" app or go to https://www.bible.com. Create a free account, choose a translation, and start a reading plan. Search for plans by topic (e.g., "anxiety", "marriage", "leadership").

Recommended for: Everyone — the most accessible Bible app for daily reading and devotional study.',
    '["Download the YouVersion Bible app and start a reading plan this week.", "Search for a reading plan on a topic relevant to your life right now.", "Share a verse with a friend using the app''s share feature."]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-017', tid, 'Olive Tree Bible App — Free Basic Edition',
    'Olive Tree offers a free Bible study app with multiple translations, reading plans, and study tools. Upgradeable with paid resources.',
    'Olive Tree Bible App (https://www.olivetree.com) is a powerful Bible study app available for iOS, Android, Mac, and Windows. The basic edition is free.

Free features:
• Free Bible translations (ESV, KJV, NKJV, NASB, NLT)
• Reading plans
• Search and cross-references
• Note-taking and highlighting
• Split-screen reading (compare translations)
• Resource guide (links to relevant notes/commentaries)
• Free resources: Easton''s Bible Dictionary, Treasury of Scripture Knowledge

How to get it: Go to https://www.olivetree.com, create a free account, and download the app for your platform.

Recommended for: Those who want an offline-capable Bible study app with a clean, user-friendly interface.',
    '["Download Olive Tree and try the split-screen feature to compare two translations.", "Use the Resource Guide to explore cross-references on a passage you''re studying.", "How does Olive Tree compare to YouVersion for your study needs?"]',
    now_ts, now_ts);

    -- ── 8. Academic & Scholarly Resources ──────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-018', tid, 'CCEL — Christian Classics Ethereal Library (Free)',
    'The Christian Classics Ethereal Library (CCEL) is a free online library of thousands of classic Christian books, commentaries, theology texts, and historical writings.',
    'The Christian Classics Ethereal Library (https://ccel.org) is one of the largest free collections of classic Christian literature. It includes thousands of public-domain and freely-licensed books.

Free resources:
• Classic commentaries (Matthew Henry, John Gill, Adam Clarke, Albert Barnes, Jamieson-Fausset-Brown)
• Church fathers (Augustine, Athanasius, Chrysostom, Jerome, Justin Martyr)
• Reformation works (Calvin''s Institutes, Luther''s writings, Knox)
• Puritan writings (Bunyan, Owen, Baxter, Brooks, Watson)
• Hymnals and worship resources
• Theology textbooks and systematic theologies
• Devotional classics (Kempis, Lawrence, Bounds, Murray)
• All available free online or as downloadable PDFs

How to use: Go to https://ccel.org, browse by author, topic, or era. Read online or download PDF/EPUB files for offline reading.

Recommended for: Pastors, theology students, and anyone wanting to read classic Christian literature for free.',
    '["Browse CCEL and find a book by Augustine — what is it about?", "Download a Puritan classic (e.g., Bunyan''s Pilgrim''s Progress) and read the first chapter.", "How do the church fathers'' writings deepen your understanding of Scripture?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-019', tid, 'Monergism — Free Reformed Theology & Bible Study Resources',
    'Monergism.com is a free online library of Reformed theology, Bible studies, articles, sermons, and classic Christian books from a Reformed perspective.',
    'Monergism (https://www.monergism.com) is a free online library of Reformed Christian resources. It provides thousands of free articles, books, sermons, and Bible study materials.

Free resources:
• Reformed theology articles and essays
• Classic Reformed books (free PDF downloads)
• Sermon library (Spurgeon, Lloyd-Jones, Piper, Keller, and more)
• Bible study guides and outlines
• Topical studies from a Reformed perspective
• Historical theology resources
• Apologetics resources
• Daily devotional readings

How to use: Go to https://www.monergism.com, browse by topic, author, or Scripture reference. Read articles online or download free PDF books.

Recommended for: Those interested in Reformed theology, apologetics, and deep biblical study.',
    '["Browse Monergism''s topic list — which topic interests you most?", "Read a Spurgeon sermon from Monergism''s sermon library.", "How does the Reformed perspective on a topic differ from what you''ve heard before?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-020', tid, 'GotQuestions.org — Free Bible Q&A (7,000+ Answers)',
    'GotQuestions.org is a free online ministry answering 7,000+ Bible and theology questions with clear, Scripture-based answers.',
    'GotQuestions.org (https://www.gotquestions.org) is one of the most popular Christian Q&A sites, with over 7,000 answered questions on every Bible and theology topic imaginable.

Free features:
• 7,000+ answered questions on Bible, theology, Christian living
• Search by topic, keyword, or Scripture reference
• Clear, concise answers (typically 500-1500 words)
• Every answer includes Scripture references
• Available in multiple languages
• Free "Got Questions" app for iOS and Android
• Daily devotional articles
• Podcast and video content

How to use: Go to https://www.gotquestions.org and search for any question (e.g., "What is salvation?", "What does the Bible say about anxiety?", "Who is Jesus?"). Read the answer with its Scripture references.

Recommended for: New believers, seekers, small group leaders, and anyone with questions about the Bible or Christian faith.',
    '["Search GotQuestions for a question you''ve always wondered about.", "How does GotQuestions answer "What is the gospel?" — do you agree?", "Use GotQuestions to prepare an answer for a friend who asks about your faith."]',
    now_ts, now_ts);

    -- ── 9. Prayer & Devotional Resources ───────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-021', tid, 'Lectio 365 — Free Daily Devotional & Prayer App',
    'Lectio 365 is a free daily devotional app from 24-7 Prayer International, helping you pray the Bible every day with guided reflections.',
    'Lectio 365 (https://www.24-7prayer.com/dailydevotional) is a free daily devotional app from the 24-7 Prayer movement. It guides you through a daily rhythm of prayer and Bible meditation.

Free features:
• Daily devotional (PRAISE, PAUSE, LISTEN, PRAY pattern)
• Based on the ancient practice of Lectio Divina (sacred reading)
• Audio version (listen to the devotion being read)
• Scripture meditation and reflection
• Prayer prompts and guided prayer
• Free app for iOS and Android
• Available in multiple languages
• Written by Pete Greig and the 24-7 Prayer team

How to use: Download the "Lectio 365" app or visit https://www.24-7prayer.com/dailydevotional. Each day, spend 5-10 minutes reading/listening to the devotion, meditating on the Scripture, and praying.

Recommended for: Anyone wanting a structured daily prayer and devotional rhythm.',
    '["Download Lectio 365 and try today''s devotion.", "How does Lectio Divina (sacred reading) differ from regular Bible reading?", "What Scripture is the focus of today''s devotion, and how does it speak to you?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-022', tid, 'Sacred Space — Free Daily Prayer Guide (Jesuit)',
    'Sacred Space is a free daily online prayer guide from the Irish Jesuits, guiding you through a 10-minute daily prayer session based on Scripture.',
    'Sacred Space (https://www.sacredspace.ie) is a free daily prayer website and app from the Irish Jesuits. It provides a guided 10-minute prayer session each day.

Free features:
• Daily guided prayer session (10 minutes)
• Based on Scripture and Ignatian spirituality
• Step-by-step prayer guidance
• Reflection questions
• Available in multiple languages
• Free app for iOS and Android
• Archived prayers for past days
• Prayer for special seasons (Advent, Lent, Easter)

How to use: Go to https://www.sacredspace.ie or download the app. Each day, follow the guided prayer steps: presence, freedom, consciousness, the Word, conversation, conclusion.

Recommended for: Those wanting a guided, contemplative daily prayer practice.',
    '["Visit Sacred Space and try today''s guided prayer.", "How does guided prayer differ from your usual prayer routine?", "What Scripture is the focus of today''s prayer, and what did you hear God say?"]',
    now_ts, now_ts);

    -- ── 10. Children & Youth Bible Study ───────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-023', tid, 'Free Children''s Bible Resources — Multiple Platforms',
    'A collection of free Bible study resources for children, including illustrated Bibles, videos, activities, and lesson plans.',
    'Free Bible study resources for children:

1. BibleProject for Kids (https://bibleproject.com/classroom/kids/)
   • Animated Bible videos designed for children
   • Free curriculum and activity sheets
   • Age-appropriate explanations

2. Superbook (https://superbook.cbn.com)
   • Free animated Bible episodes for kids
   • Games, activities, and Bible lessons
   • Free app for iOS and Android

3. FreeBibleImages (https://www.freebibleimages.org)
   • Free illustrated Bible story images
   • Downloadable PowerPoint presentations
   • Lesson plans for Sunday School
   • Available in multiple languages

4. DLTK''s Bible Activities (https://www.dltk-bible.com)
   • Free printable Bible crafts, coloring pages, and worksheets
   • Lesson plans for preschool and elementary
   • Songs, games, and activities

5. Ministry-to-Children (https://ministry-to-children.com)
   • Free Sunday School lesson plans
   • Printable Bible worksheets
   • Children''s church curriculum
   • Object lessons and skits

How to use: Choose a resource based on your children''s ages. Use the videos, activities, and lesson plans for Sunday School, family devotions, or children''s church.

Recommended for: Sunday School teachers, parents, and children''s ministry leaders.',
    '["Download a free Bible story PowerPoint from FreeBibleImages for your next Sunday School class.", "Watch a Superbook episode with your children — what did they learn?", "Find a printable craft from DLTK''s Bible Activities that matches this week''s lesson."]',
    now_ts, now_ts);

    -- ── 11. Bible Atlas & Geography ─────────────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-024', tid, 'Bible Atlas — Free Online Bible Maps & Geography',
    'Free online Bible atlases with interactive maps, historical geography, and location-based Bible study tools.',
    'Free Bible atlas and map resources:

1. Bible Hub Atlas (https://biblehub.com/maps/)
   • Free interactive Bible maps
   • Maps for every major Bible event
   • Old and New Testament geography
   • Paul''s missionary journeys

2. OpenBible.info Geo (https://www.openbible.info/geo/)
   • Interactive Google Maps overlay of Bible locations
   • Click any location to see related Bible verses
   • Satellite view of ancient sites
   • Free and easy to use

3. BibleMapper (https://www.biblemapper.com)
   • Free Bible map software
   • Create custom Bible maps
   • Download and print maps
   • Historical geography layers

4. ESV Bible Atlas (https://www.esv.org/atlas/)
   • Free online ESV Bible Atlas
   • High-quality maps
   • Historical and geographical context

How to use: Use these maps alongside your Bible reading to understand the geographical context of events. For example, trace Paul''s missionary journeys on a map while reading Acts.

Recommended for: Sunday School teachers, Bible study leaders, and anyone wanting to understand the geographical context of Scripture.',
    '["Find a map of Paul''s first missionary journey — which cities did he visit?", "Look up the location of Jerusalem on OpenBible.info Geo — what verses are linked to it?", "How does understanding the geography of a Bible event change your understanding of the story?"]',
    now_ts, now_ts);

    -- ── 12. Audio & Video Bible Resources ──────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-025', tid, 'Free Audio Bibles — Listen to the Bible Online',
    'A guide to free audio Bible resources — listen to the Bible in multiple translations and languages, online or offline.',
    'Free audio Bible resources:

1. Bible Gateway Audio (https://www.biblegateway.com/audio/)
   • Free audio Bibles in multiple translations (NIV, KJV, ESV, NLT, MSG, and more)
   • Multiple narrators (including dramatized versions)
   • Stream online or use the app
   • Free — no account required

2. YouVersion Bible App (https://www.bible.com)
   • Free audio Bibles in many translations
   • Offline listening (download audio)
   • Variable speed playback
   • Sleep timer

3. Faith Comes By Hearing (https://www.faithcomesbyhearing.com)
   • Free Audio Bible in 1,500+ languages
   • Dramatized Audio Bible (multiple voices, sound effects)
   • Free Bible.is app for iOS and Android
   • Available in many languages worldwide

4. ESV Audio Bible (https://www.esv.org/audio/)
   • Free ESV Audio Bible
   • Multiple narrators
   • Daily podcast (read through the Bible in a year)

5. Dwell (https://dwellapp.io)
   • Free basic plan with ESV audio
   • Multiple voices and reading styles
   • Sleep timer, playlists, and reading plans
   • Premium plans available

How to use: Choose a platform, select your preferred translation, and start listening. Audio Bibles are great for commuting, exercising, or listening before bed.

Recommended for: Auditory learners, busy people, those with visual impairments, and anyone who wants to absorb Scripture while doing other activities.',
    '["Listen to the Gospel of John on Bible Gateway Audio — what stands out when you hear it?", "Try a dramatized audio Bible — how does it differ from a single-narrator version?", "Set a goal to listen to one chapter of the Bible each day this week."]',
    now_ts, now_ts);

    -- ── 13. The Original 4 In-Depth Studies ────────────────────────────────────

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-026', tid, 'The Foundations of Salvation',
    'A foundational study on what it means to be saved by grace through faith in Jesus Christ.',
    'Salvation is the free gift of God, received by grace through faith, not by works, so that no one may boast (Ephesians 2:8-9). Before Christ, we were dead in our sins, but God, being rich in mercy, made us alive together with Christ. This study explores what it means to move from spiritual death to new life in Christ, the assurance of salvation, and how grace transforms the way we live.

Key truths:
1. Salvation is by grace, not by works (Eph 2:8-9).
2. Confessing Jesus as Lord and believing in His resurrection brings salvation (Rom 10:9).
3. We are God''s workmanship, created for good works (Eph 2:10).',
    '["What does it mean that salvation is "not a result of works"?", "How does understanding grace change the way you relate to God?", "What "good works" is God calling you to walk in as a result of your salvation?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-027', tid, 'The Fruit of the Spirit',
    'An in-depth look at the nine expressions of the Spirit-filled life described by Paul in Galatians.',
    'Paul contrasts the "works of the flesh" with the "fruit of the Spirit" — love, joy, peace, patience, kindness, goodness, faithfulness, gentleness, and self-control. Unlike the works of the flesh, the fruit of the Spirit is singular, showing that these qualities grow together as one integrated character, produced by the Holy Spirit as we walk in step with Him (Gal 5:25).

This study examines each fruit individually, and how walking by the Spirit — not by the flesh — produces lasting transformation of character.',
    '["Which fruit of the Spirit do you see growing most in your life right now?", "Which fruit is the most challenging for you to walk in, and why?", "What practical steps can you take this week to "walk by the Spirit" (Gal 5:16)?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-028', tid, 'The Book of Romans: An Overview',
    'Paul''s letter to the Romans lays out the gospel systematically — sin, righteousness, grace, and the transformed Christian life.',
    'Romans is often considered Paul''s masterwork of theology. Chapters 1-3 establish humanity''s universal need for salvation. Chapters 3-5 explain justification by faith. Chapters 6-8 describe sanctification — the process of being set apart and transformed by the Holy Spirit. Chapters 9-11 address God''s faithfulness to Israel, and chapters 12-16 apply these truths to practical Christian living.

This study walks through the major themes of the first eight chapters as a foundation for understanding the rest of the letter.',
    '["According to Romans 3:23, why does every person need the gospel?", "How does Romans 8:1 describe the standing of those who are "in Christ Jesus"?", "What does it mean to be led by the Spirit (Romans 8:14)?"]',
    now_ts, now_ts);

    INSERT INTO bible_study_resources (id, tenant_id, title, description, content, questions, created_at, updated_at) VALUES
    ('bs-029', tid, 'David: A Man After God''s Own Heart',
    'Examining the life of David — his faith, failures, and repentance — as a model of a heart fully devoted to God.',
    'David was anointed king while still a shepherd boy, defeated Goliath through faith in God rather than military might, and later fell into serious sin with Bathsheba. What sets David apart is not perfection, but a heart that consistently turned back to God in genuine repentance (Psalm 51). This study looks at both David''s victories and failures to understand what it truly means to have a heart after God.',
    '["What gave David the confidence to face Goliath (1 Samuel 17:45-47)?", "How did David respond when confronted with his sin (2 Samuel 12; Psalm 51)?", "What can we learn from David about genuine repentance versus mere regret?"]',
    now_ts, now_ts);

    RAISE NOTICE 'Inserted 29 Bible study resources into bible_study_resources table';
END $$;

-- ── Verify ──────────────────────────────────────────────────────────────────
SELECT 'Bible study resources inserted: ' || COUNT(*)::TEXT as result
FROM bible_study_resources
WHERE tenant_id = 'a2cdda2c-37f4-4436-b215-916e5cec2952';
