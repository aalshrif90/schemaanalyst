-- SQL to create the initial tables for the MediaWiki database.
-- This is read and executed by the install script; you should
-- not have to run it by itself unless doing a manual install.

-- This is a shared schema file used for both MySQL and SQLite installs.

--
-- General notes:
--
-- If possible, create tables as InnoDB to benefit from the
-- superior resiliency against crashes and ability to read
-- during writes (and write during reads!)
--
-- Only the 'searchindex' table requires MyISAM due to the
-- requirement for fulltext index support, which is missing
-- from InnoDB.
--
--
-- The MySQL table backend for MediaWiki currently uses
-- 14-character BINARY or VARBINARY fields to store timestamps.
-- The format is YYYYMMDDHHMMSS, which is derived from the
-- text format of MySQL's TIMESTAMP fields.
--
-- Historically TIMESTAMP fields were used, but abandoned
-- in early 2002 after a lot of trouble with the fields
-- auto-updating.
--
-- The Postgres backend uses TIMESTAMPTZ fields for timestamps,
-- and we will migrate the MySQL definitions at some point as
-- well.
--
--
-- The  comments in this and other files are
-- replaced with the defined table prefix by the installer
-- and updater scripts. If you are installing or running
-- updates manually, you will need to manually insert the
-- table prefix if any when running these scripts.
--


--
-- The user table contains basic account information,
-- authentication keys, etc.
--
-- Some multi-wiki sites may share a single central user table
-- between separate wikis using the $wgSharedDB setting.
--
-- Note that when a external authentication plugin is used,
-- user table entries still need to be created to store
-- preferences and to key tracking information in the other
-- tables.
--
CREATE TABLE user (
  user_id int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,

  -- Usernames must be unique, must not be in the form of
  -- an IP address. _Shouldn't_ allow slashes or case
  -- conflicts. Spaces are allowed, and are _not_ converted
  -- to underscores like titles. See the User::newFromName() for
  -- the specific tests that usernames have to pass.
  user_name varchar(255) binary NOT NULL default '',

  -- Optional 'real name' to be displayed in credit listings
  user_real_name varchar(255) binary NOT NULL default '',

  -- Password hashes, see User::crypt() and User::comparePasswords()
  -- in User.php for the algorithm
  user_password int NOT NULL,

  -- When using 'mail me a new password', a random
  -- password is generated and the hash stored here.
  -- The previous password is left in place until
  -- someone actually logs in with the new password,
  -- at which point the hash is moved to user_password
  -- and the old password is invalidated.
  user_newpassword int NOT NULL,

  -- Timestamp of the last time when a new password was
  -- sent, for throttling and expiring purposes
  -- Emailed passwords will expire $wgNewPasswordExpiry
  -- (a week) after being set. If user_newpass_time is NULL
  -- (eg. created by mail) it doesn't expire.
  user_newpass_time int,

  -- Note: email should be restricted, not public info.
  -- Same with passwords.
  user_email text NOT NULL,

  -- If the browser sends an If-Modified-Since header, a 304 response is
  -- suppressed if the value in this field for the current user is later than
  -- the value in the IMS header. That is, this field is an invalidation timestamp
  -- for the browser cache of logged-in users. Among other things, it is used
  -- to prevent pages generated for a previously logged in user from being
  -- displayed after a session expiry followed by a fresh login.
  user_touched int NOT NULL default '',

  -- A pseudorandomly generated value that is stored in
  -- a cookie when the "remember password" feature is
  -- used (previously, a hash of the password was used, but
  -- this was vulnerable to cookie-stealing attacks)
  user_token int NOT NULL default '',

  -- Initially NULL; when a user's e-mail address has been
  -- validated by returning with a mailed token, this is
  -- set to the current timestamp.
  user_email_authenticated int,

  -- Randomly generated token created when the e-mail address
  -- is set and a confirmation test mail sent.
  user_email_token int,

  -- Expiration date for the user_email_token
  user_email_token_expires int,

  -- Timestamp of account registration.
  -- Accounts predating this schema addition may contain NULL.
  user_registration int,

  -- Count of edits and edit-like actions.
  --
  -- *NOT* intended to be an accurate copy of COUNT(*) WHERE rev_user=user_id
  -- May contain NULL for old accounts if batch-update scripts haven't been
  -- run, as well as listing deleted edits and other myriad ways it could be
  -- out of sync.
  --
  -- Meant primarily for heuristic checks to give an impression of whether
  -- the account has been used much.
  --
  user_editcount int
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/user_name ON user (user_name);
CREATE INDEX /*i*/user_email_token ON user (user_email_token);
CREATE INDEX /*i*/user_email ON user (user_email(50));


--
-- User permissions have been broken out to a separate table;
-- this allows sites with a shared user table to have different
-- permissions assigned to a user in each project.
--
-- This table replaces the old user_rights field which used a
-- comma-separated int.
--
CREATE TABLE user_groups (
  -- Key to user_id
  ug_user int unsigned NOT NULL default 0,

  -- Group names are short symbolic string keys.
  -- The set of group names is open-ended, though in practice
  -- only some predefined ones are likely to be used.
  --
  -- At runtime $wgGroupPermissions will associate group keys
  -- with particular permissions. A user will have the combined
  -- permissions of any group they're explicitly in, plus
  -- the implicit '*' and 'user' groups.
  ug_group int NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/ug_user_group ON user_groups (ug_user,ug_group);
CREATE INDEX /*i*/ug_group ON user_groups (ug_group);

-- Stores the groups the user has once belonged to.
-- The user may still belong to these groups (check user_groups).
-- Users are not autopromoted to groups from which they were removed.
CREATE TABLE user_former_groups (
  -- Key to user_id
  ufg_user int unsigned NOT NULL default 0,
  ufg_group int NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/ufg_user_group ON user_former_groups (ufg_user,ufg_group);

--
-- Stores notifications of user talk page changes, for the display
-- of the "you have new messages" box
--
CREATE TABLE user_newtalk (
  -- Key to user.user_id
  user_id int NOT NULL default 0,
  -- If the user is an anonymous user their IP address is stored here
  -- since the user_id of 0 is ambiguous
  user_ip int NOT NULL default '',
  -- The highest timestamp of revisions of the talk page viewed
  -- by this user
  user_last_timestamp int NULL default NULL
) /*$wgDBTableOptions*/;

-- Indexes renamed for SQLite in 1.14
CREATE INDEX /*i*/un_user_id ON user_newtalk (user_id);
CREATE INDEX /*i*/un_user_ip ON user_newtalk (user_ip);


--
-- User preferences and perhaps other fun stuff. :)
-- Replaces the old user.user_options int, with a couple nice properties:
--
-- 1) We only store non-default settings, so changes to the defauls
--    are now reflected for everybody, not just new accounts.
-- 2) We can more easily do bulk lookups, statistics, or modifications of
--    saved options since it's a sane table structure.
--
CREATE TABLE user_properties (
  -- Foreign key to user.user_id
  up_user int NOT NULL,

  -- Name of the option being saved. This is indexed for bulk lookup.
  up_property int NOT NULL,

  -- Property value as a string.
  up_value int
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/user_properties_user_property ON user_properties (up_user,up_property);
CREATE INDEX /*i*/user_properties_property ON user_properties (up_property);

--
-- Core of the wiki: each page has an entry here which identifies
-- it by title and contains some essential metadata.
--
CREATE TABLE page (
  -- Unique identifier number. The page_id will be preserved across
  -- edits and rename operations, but not deletions and recreations.
  page_id int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,

  -- A page name is broken into a namespace and a title.
  -- The namespace keys are UI-language-independent constants,
  -- defined in includes/Defines.php
  page_namespace int NOT NULL,

  -- The rest of the title, as text.
  -- Spaces are transformed into underscores in title storage.
  page_title varchar(255) binary NOT NULL,

  -- Comma-separated set of permission keys indicating who
  -- can move or edit the page.
  page_restrictions int NOT NULL,

  -- Number of times this page has been viewed.
  page_counter int unsigned NOT NULL default 0,

  -- 1 indicates the article is a redirect.
  page_is_redirect tinyint unsigned NOT NULL default 0,

  -- 1 indicates this is a new entry, with only one edit.
  -- Not all pages with one edit are new pages.
  page_is_new tinyint unsigned NOT NULL default 0,

  -- Random value between 0 and 1, used for Special:Randompage
  page_random real unsigned NOT NULL,

  -- This timestamp is updated whenever the page changes in
  -- a way requiring it to be re-rendered, invalidating caches.
  -- Aside from editing this includes permission changes,
  -- creation or deletion of linked pages, and alteration
  -- of contained templates.
  page_touched int NOT NULL default '',

  -- Handy key to revision.rev_id of the current revision.
  -- This may be 0 during page creation, but that shouldn't
  -- happen outside of a transaction... hopefully.
  page_latest int unsigned NOT NULL,

  -- Uncompressed length in bytes of the page's current source text.
  page_len int unsigned NOT NULL,

  -- content model, see CONTENT_MODEL_XXX constants
  page_content_model int DEFAULT NULL
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/name_title ON page (page_namespace,page_title);
CREATE INDEX /*i*/page_random ON page (page_random);
CREATE INDEX /*i*/page_len ON page (page_len);
CREATE INDEX /*i*/page_redirect_namespace_len ON page (page_is_redirect, page_namespace, page_len);

--
-- Every edit of a page creates also a revision row.
-- This stores metadata about the revision, and a reference
-- to the text storage backend.
--
CREATE TABLE revision (
  -- Unique ID to identify each revision
  rev_id int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,

  -- Key to page_id. This should _never_ be invalid.
  rev_page int unsigned NOT NULL,

  -- Key to text.old_id, where the actual bulk text is stored.
  -- It's possible for multiple revisions to use the same text,
  -- for instance revisions where only metadata is altered
  -- or a rollback to a previous version.
  rev_text_id int unsigned NOT NULL,

  -- Text comment summarizing the change.
  -- This text is shown in the history and other changes lists,
  -- rendered in a subset of wiki markup by Linker::formatComment()
  rev_comment int NOT NULL,

  -- Key to user.user_id of the user who made this edit.
  -- Stores 0 for anonymous edits and for some mass imports.
  rev_user int unsigned NOT NULL default 0,

  -- Text username or IP address of the editor.
  rev_user_text varchar(255) binary NOT NULL default '',

  -- Timestamp of when revision was created
  rev_timestamp int NOT NULL default '',

  -- Records whether the user marked the 'minor edit' checkbox.
  -- Many automated edits are marked as minor.
  rev_minor_edit tinyint unsigned NOT NULL default 0,

  -- Restrictions on who can access this revision
  rev_deleted tinyint unsigned NOT NULL default 0,

  -- Length of this revision in bytes
  rev_len int unsigned,

  -- Key to revision.rev_id
  -- This field is used to add support for a tree structure (The Adjacency List Model)
  rev_parent_id int unsigned default NULL,

  -- SHA-1 text content hash in base-36
  rev_sha1 int NOT NULL default '',

  -- content model, see CONTENT_MODEL_XXX constants
  rev_content_model int DEFAULT NULL,

  -- content format, see CONTENT_FORMAT_XXX constants
  rev_content_format int DEFAULT NULL

) /*$wgDBTableOptions*/ MAX_ROWS=10000000 AVG_ROW_LENGTH=1024;
-- In case tables are created as MyISAM, use row hints for MySQL <5.0 to avoid 4GB limit

CREATE UNIQUE INDEX /*i*/rev_page_id ON revision (rev_page, rev_id);
CREATE INDEX /*i*/rev_timestamp ON revision (rev_timestamp);
CREATE INDEX /*i*/page_timestamp ON revision (rev_page,rev_timestamp);
CREATE INDEX /*i*/user_timestamp ON revision (rev_user,rev_timestamp);
CREATE INDEX /*i*/usertext_timestamp ON revision (rev_user_text,rev_timestamp);
CREATE INDEX /*i*/page_user_timestamp ON revision (rev_page,rev_user,rev_timestamp);

--
-- Holds text of individual page revisions.
--
-- Field names are a holdover from the 'old' revisions table in
-- MediaWiki 1.4 and earlier: an upgrade will transform that
-- table into the 'text' table to minimize unnecessary churning
-- and downtime. If upgrading, the other fields will be left unused.
--
CREATE TABLE text (
  -- Unique text storage key number.
  -- Note that the 'oldid' parameter used in URLs does *not*
  -- refer to this number anymore, but to rev_id.
  --
  -- revision.rev_text_id is a key to this column
  old_id int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,

  -- Depending on the contents of the old_flags field, the text
  -- may be convenient plain text, or it may be funkily encoded.
  old_text int NOT NULL,

  -- Comma-separated list of flags:
  -- gzip: text is compressed with PHP's gzdeflate() function.
  -- utf8: text was stored as UTF-8.
  --       If $wgLegacyEncoding option is on, rows *without* this flag
  --       will be converted to UTF-8 transparently at load time.
  -- object: text field contained a serialized PHP object.
  --         The object either contains multiple versions compressed
  --         together to achieve a better compression ratio, or it refers
  --         to another row where the text can be found.
  old_flags int NOT NULL
) /*$wgDBTableOptions*/ MAX_ROWS=10000000 AVG_ROW_LENGTH=10240;
-- In case tables are created as MyISAM, use row hints for MySQL <5.0 to avoid 4GB limit


--
-- Holding area for deleted articles, which may be viewed
-- or restored by admins through the Special:Undelete interface.
-- The fields generally correspond to the page, revision, and text
-- fields, with several caveats.
--
CREATE TABLE archive (
  ar_namespace int NOT NULL default 0,
  ar_title varchar(255) binary NOT NULL default '',

  -- Newly deleted pages will not store text in this table,
  -- but will reference the separately existing text rows.
  -- This field is retained for backwards compatibility,
  -- so old archived pages will remain accessible after
  -- upgrading from 1.4 to 1.5.
  -- Text may be gzipped or otherwise funky.
  ar_text int NOT NULL,

  -- Basic revision stuff...
  ar_comment int NOT NULL,
  ar_user int unsigned NOT NULL default 0,
  ar_user_text varchar(255) binary NOT NULL,
  ar_timestamp int NOT NULL default '',
  ar_minor_edit tinyint NOT NULL default 0,

  -- See ar_text note.
  ar_flags int NOT NULL,

  -- When revisions are deleted, their unique rev_id is stored
  -- here so it can be retained after undeletion. This is necessary
  -- to retain permalinks to given revisions after accidental delete
  -- cycles or messy operations like history merges.
  --
  -- Old entries from 1.4 will be NULL here, and a new rev_id will
  -- be created on undeletion for those revisions.
  ar_rev_id int unsigned,

  -- For newly deleted revisions, this is the text.old_id key to the
  -- actual stored text. To avoid breaking the block-compression scheme
  -- and otherwise making storage changes harder, the actual text is
  -- *not* deleted from the text table, merely hidden by removal of the
  -- page and revision entries.
  --
  -- Old entries deleted under 1.2-1.4 will have NULL here, and their
  -- ar_text and ar_flags fields will be used to create a new text
  -- row upon undeletion.
  ar_text_id int unsigned,

  -- rev_deleted for archives
  ar_deleted tinyint unsigned NOT NULL default 0,

  -- Length of this revision in bytes
  ar_len int unsigned,

  -- Reference to page_id. Useful for sysadmin fixing of large pages
  -- merged together in the archives, or for cleanly restoring a page
  -- at its original ID number if possible.
  --
  -- Will be NULL for pages deleted prior to 1.11.
  ar_page_id int unsigned,

  -- Original previous revision
  ar_parent_id int unsigned default NULL,

  -- SHA-1 text content hash in base-36
  ar_sha1 int NOT NULL default '',

  -- content model, see CONTENT_MODEL_XXX constants
  ar_content_model int DEFAULT NULL,

  -- content format, see CONTENT_FORMAT_XXX constants
  ar_content_format int DEFAULT NULL

) /*$wgDBTableOptions*/;

CREATE INDEX /*i*/name_title_timestamp ON archive (ar_namespace,ar_title,ar_timestamp);
CREATE INDEX /*i*/ar_usertext_timestamp ON archive (ar_user_text,ar_timestamp);
CREATE INDEX /*i*/ar_revid ON archive (ar_rev_id);


--
-- Track page-to-page hyperlinks within the wiki.
--
CREATE TABLE pagelinks (
  -- Key to the page_id of the page containing the link.
  pl_from int unsigned NOT NULL default 0,

  -- Key to page_namespace/page_title of the target page.
  -- The target page may or may not exist, and due to renames
  -- and deletions may refer to different page records as time
  -- goes by.
  pl_namespace int NOT NULL default 0,
  pl_title varchar(255) binary NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/pl_from ON pagelinks (pl_from,pl_namespace,pl_title);
CREATE UNIQUE INDEX /*i*/pl_namespace ON pagelinks (pl_namespace,pl_title,pl_from);


--
-- Track template inclusions.
--
CREATE TABLE templatelinks (
  -- Key to the page_id of the page containing the link.
  tl_from int unsigned NOT NULL default 0,

  -- Key to page_namespace/page_title of the target page.
  -- The target page may or may not exist, and due to renames
  -- and deletions may refer to different page records as time
  -- goes by.
  tl_namespace int NOT NULL default 0,
  tl_title varchar(255) binary NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/tl_from ON templatelinks (tl_from,tl_namespace,tl_title);
CREATE UNIQUE INDEX /*i*/tl_namespace ON templatelinks (tl_namespace,tl_title,tl_from);


--
-- Track links to images *used inline*
-- We don't distinguish live from broken links here, so
-- they do not need to be changed on upload/removal.
--
CREATE TABLE imagelinks (
  -- Key to page_id of the page containing the image / media link.
  il_from int unsigned NOT NULL default 0,

  -- Filename of target image.
  -- This is also the page_title of the file's description page;
  -- all such pages are in namespace 6 (NS_FILE).
  il_to varchar(255) binary NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/il_from ON imagelinks (il_from,il_to);
CREATE UNIQUE INDEX /*i*/il_to ON imagelinks (il_to,il_from);


--
-- Track category inclusions *used inline*
-- This tracks a single level of category membership
--
CREATE TABLE categorylinks (
  -- Key to page_id of the page defined as a category member.
  cl_from int unsigned NOT NULL default 0,

  -- Name of the category.
  -- This is also the page_title of the category's description page;
  -- all such pages are in namespace 14 (NS_CATEGORY).
  cl_to varchar(255) binary NOT NULL default '',

  -- A binary string obtained by applying a sortkey generation algorithm
  -- (Collation::getSortKey()) to page_title, or cl_sortkey_prefix . "\n"
  -- . page_title if cl_sortkey_prefix is nonempty.
  cl_sortkey int NOT NULL default '',

  -- A prefix for the raw sortkey manually specified by the user, either via
  -- [[Category:Foo|prefix]] or {{defaultsort:prefix}}.  If nonempty, it's
  -- concatenated with a line break followed by the page title before the sortkey
  -- conversion algorithm is run.  We store this so that we can update
  -- collations without reparsing all pages.
  -- Note: If you change the length of this field, you also need to change
  -- code in LinksUpdate.php. See bug 25254.
  cl_sortkey_prefix varchar(255) binary NOT NULL default '',

  -- This isn't really used at present. Provided for an optional
  -- sorting method by approximate addition time.
  cl_timestamp timestamp NOT NULL,

  -- Stores $wgCategoryCollation at the time cl_sortkey was generated.  This
  -- can be used to install new collation versions, tracking which rows are not
  -- yet updated.  '' means no collation, this is a legacy row that needs to be
  -- updated by updateCollation.php.  In the future, it might be possible to
  -- specify different collations per category.
  cl_collation int NOT NULL default '',

  -- Stores whether cl_from is a category, file, or other page, so we can
  -- paginate the three categories separately.  This never has to be updated
  -- after the page is created, since none of these page types can be moved to
  -- any other.
  cl_type int NOT NULL default 'page'
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/cl_from ON categorylinks (cl_from,cl_to);

-- We always sort within a given category, and within a given type.  FIXME:
-- Formerly this index didn't cover cl_type (since that didn't exist), so old
-- callers won't be using an index: fix this?
CREATE INDEX /*i*/cl_sortkey ON categorylinks (cl_to,cl_type,cl_sortkey,cl_from);

-- Used by the API (and some extensions)
CREATE INDEX /*i*/cl_timestamp ON categorylinks (cl_to,cl_timestamp);

-- FIXME: Not used, delete this
CREATE INDEX /*i*/cl_collation ON categorylinks (cl_collation);

--
-- Track all existing categories.  Something is a category if 1) it has an en-
-- try somewhere in categorylinks, or 2) it once did.  Categories might not
-- have corresponding pages, so they need to be tracked separately.
--
CREATE TABLE category (
  -- Primary key
  cat_id int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,

  -- Name of the category, in the same form as page_title (with underscores).
  -- If there is a category page corresponding to this category, by definition,
  -- it has this name (in the Category namespace).
  cat_title varchar(255) binary NOT NULL,

  -- The numbers of member pages (including categories and media), subcatego-
  -- ries, and Image: namespace members, respectively.  These are   to
  -- make underflow more obvious.  We make the first number include the second
  -- two for better sorting: subtracting for display is easy, adding for order-
  -- ing is not.
  cat_pages int   NOT NULL default 0,
  cat_subcats int   NOT NULL default 0,
  cat_files int   NOT NULL default 0
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/cat_title ON category (cat_title);

-- For Special:Mostlinkedcategories
CREATE INDEX /*i*/cat_pages ON category (cat_pages);


--
-- Track links to external URLs
--
CREATE TABLE externallinks (
  -- page_id of the referring page
  el_from int unsigned NOT NULL default 0,

  -- The URL
  el_to int NOT NULL,

  -- In the case of HTTP URLs, this is the URL with any username or password
  -- removed, and with the labels in the hostname reversed and converted to
  -- lower case. An extra dot is added to allow for matching of either
  -- example.com or *.example.com in a single scan.
  -- Example:
  --      http://user:password@sub.example.com/page.html
  --   becomes
  --      http://com.example.sub./page.html
  -- which allows for fast searching for all pages under example.com with the
  -- clause:
  --      WHERE el_index LIKE 'http://com.example.%'
  el_index int NOT NULL
) /*$wgDBTableOptions*/;

CREATE INDEX /*i*/el_from ON externallinks (el_from, el_to(40));
CREATE INDEX /*i*/el_to ON externallinks (el_to(60), el_from);
CREATE INDEX /*i*/el_index ON externallinks (el_index(60));

--
-- Track interlanguage links
--
CREATE TABLE langlinks (
  -- page_id of the referring page
  ll_from int unsigned NOT NULL default 0,

  -- Language code of the target
  ll_lang int NOT NULL default '',

  -- Title of the target, including namespace
  ll_title varchar(255) binary NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/ll_from ON langlinks (ll_from, ll_lang);
CREATE INDEX /*i*/ll_lang ON langlinks (ll_lang, ll_title);


--
-- Track inline interwiki links
--
CREATE TABLE iwlinks (
  -- page_id of the referring page
  iwl_from int unsigned NOT NULL default 0,

  -- Interwiki prefix code of the target
  iwl_prefix int NOT NULL default '',

  -- Title of the target, including namespace
  iwl_title varchar(255) binary NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/iwl_from ON iwlinks (iwl_from, iwl_prefix, iwl_title);
CREATE INDEX /*i*/iwl_prefix_title_from ON iwlinks (iwl_prefix, iwl_title, iwl_from);
CREATE INDEX /*i*/iwl_prefix_from_title ON iwlinks (iwl_prefix, iwl_from, iwl_title);


--
-- Contains a single row with some aggregate info
-- on the state of the site.
--
CREATE TABLE site_stats (
  -- The single row should contain 1 here.
  ss_row_id int unsigned NOT NULL,

  -- Total number of page views, if hit counters are enabled.
  ss_total_views int unsigned default 0,

  -- Total number of edits performed.
  ss_total_edits int unsigned default 0,

  -- An approximate count of pages matching the following criteria:
  -- * in namespace 0
  -- * not a redirect
  -- * contains the text '[['
  -- See Article::isCountable() in includes/Article.php
  ss_good_articles int unsigned default 0,

  -- Total pages, theoretically equal to SELECT COUNT(*) FROM page; except faster
  ss_total_pages int default '-1',

  -- Number of users, theoretically equal to SELECT COUNT(*) FROM user;
  ss_users int default '-1',

  -- Number of users that still edit
  ss_active_users int default '-1',

  -- Number of images, equivalent to SELECT COUNT(*) FROM image
  ss_images int default 0
) /*$wgDBTableOptions*/;

-- Pointless index to assuage developer superstitions
CREATE UNIQUE INDEX /*i*/ss_row_id ON site_stats (ss_row_id);


--
-- Stores an ID for every time any article is visited;
-- depending on $wgHitcounterUpdateFreq, it is
-- periodically cleared and the page_counter column
-- in the page table updated for all the articles
-- that have been visited.)
--
CREATE TABLE hitcounter (
  hc_id int unsigned NOT NULL
) ENGINE=HEAP MAX_ROWS=25000;


--
-- The internet is full of jerks, alas. Sometimes it's handy
-- to block a vandal or troll account.
--
CREATE TABLE ipblocks (
  -- Primary key, introduced for privacy.
  ipb_id int NOT NULL PRIMARY KEY AUTO_INCREMENT,

  -- Blocked IP address in dotted-quad form or user name.
  ipb_address int NOT NULL,

  -- Blocked user ID or 0 for IP blocks.
  ipb_user int unsigned NOT NULL default 0,

  -- User ID who made the block.
  ipb_by int unsigned NOT NULL default 0,

  -- User name of blocker
  ipb_by_text varchar(255) binary NOT NULL default '',

  -- Text comment made by blocker.
  ipb_reason int NOT NULL,

  -- Creation (or refresh) date in standard YMDHMS form.
  -- IP blocks expire automatically.
  ipb_timestamp int NOT NULL default '',

  -- Indicates that the IP address was banned because a banned
  -- user accessed a page through it. If this is 1, ipb_address
  -- will be hidden, and the block identified by block ID number.
  ipb_auto int NOT NULL default 0,

  -- If set to 1, block applies only to logged-out users
  ipb_anon_only int NOT NULL default 0,

  -- Block prevents account creation from matching IP addresses
  ipb_create_account int NOT NULL default 1,

  -- Block triggers autoblocks
  ipb_enable_autoblock int NOT NULL default '1',

  -- Time at which the block will expire.
  -- May be "infinity"
  ipb_expiry int NOT NULL default '',

  -- Start and end of an address range, in hexadecimal
  -- Size chosen to allow IPv6
  ipb_range_start int NOT NULL,
  ipb_range_end int NOT NULL,

  -- Flag for entries hidden from users and Sysops
  ipb_deleted int NOT NULL default 0,

  -- Block prevents user from accessing Special:Emailuser
  ipb_block_email int NOT NULL default 0,

  -- Block allows user to edit their own talk page
  ipb_allow_usertalk int NOT NULL default 0,

  -- ID of the block that caused this block to exist
  -- Autoblocks set this to the original block
  -- so that the original block being deleted also
  -- deletes the autoblocks
  ipb_parent_block_id int default NULL

) /*$wgDBTableOptions*/;

-- Unique index to support "user already blocked" messages
-- Any new options which prevent collisions should be included
CREATE UNIQUE INDEX /*i*/ipb_address ON ipblocks (ipb_address(255), ipb_user, ipb_auto, ipb_anon_only);

CREATE INDEX /*i*/ipb_user ON ipblocks (ipb_user);
CREATE INDEX /*i*/ipb_range ON ipblocks (ipb_range_start(8), ipb_range_end(8));
CREATE INDEX /*i*/ipb_timestamp ON ipblocks (ipb_timestamp);
CREATE INDEX /*i*/ipb_expiry ON ipblocks (ipb_expiry);
CREATE INDEX /*i*/ipb_parent_block_id ON ipblocks (ipb_parent_block_id);


--
-- Uploaded images and other files.
--
CREATE TABLE image (
  -- Filename.
  -- This is also the title of the associated description page,
  -- which will be in namespace 6 (NS_FILE).
  img_name varchar(255) binary NOT NULL default '' PRIMARY KEY,

  -- File size in bytes.
  img_size int unsigned NOT NULL default 0,

  -- For images, size in pixels.
  img_width int NOT NULL default 0,
  img_height int NOT NULL default 0,

  -- Extracted Exif metadata stored as a serialized PHP array.
  img_metadata int NOT NULL,

  -- For images, bits per pixel if known.
  img_bits int NOT NULL default 0,

  -- Media type as defined by the MEDIATYPE_xxx constants
  img_media_type int default NULL,

  -- major part of a MIME media type as defined by IANA
  -- see http://www.iana.org/assignments/media-types/
  img_major_mime int NOT NULL default "unknown",

  -- minor part of a MIME media type as defined by IANA
  -- the minor parts are not required to adher to any standard
  -- but should be consistent throughout the database
  -- see http://www.iana.org/assignments/media-types/
  img_minor_mime int NOT NULL default "unknown",

  -- Description field as entered by the uploader.
  -- This is displayed in image upload history and logs.
  img_description int NOT NULL,

  -- user_id and user_name of uploader.
  img_user int unsigned NOT NULL default 0,
  img_user_text varchar(255) binary NOT NULL,

  -- Time of the upload.
  img_timestamp int NOT NULL default '',

  -- SHA-1 content hash in base-36
  img_sha1 int NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE INDEX /*i*/img_usertext_timestamp ON image (img_user_text,img_timestamp);
-- Used by Special:ListFiles for sort-by-size
CREATE INDEX /*i*/img_size ON image (img_size);
-- Used by Special:Newimages and Special:ListFiles
CREATE INDEX /*i*/img_timestamp ON image (img_timestamp);
-- Used in API and duplicate search
CREATE INDEX /*i*/img_sha1 ON image (img_sha1(10));
-- Used to get media of one type
CREATE INDEX /*i*/img_media_mime ON image (img_media_type,img_major_mime,img_minor_mime);


--
-- Previous revisions of uploaded files.
-- Awkwardly, image rows have to be moved into
-- this table at re-upload time.
--
CREATE TABLE oldimage (
  -- Base filename: key to image.img_name
  oi_name varchar(255) binary NOT NULL default '',

  -- Filename of the archived file.
  -- This is generally a timestamp and '!' prepended to the base name.
  oi_archive_name varchar(255) binary NOT NULL default '',

  -- Other fields as in image...
  oi_size int unsigned NOT NULL default 0,
  oi_width int NOT NULL default 0,
  oi_height int NOT NULL default 0,
  oi_bits int NOT NULL default 0,
  oi_description int NOT NULL,
  oi_user int unsigned NOT NULL default 0,
  oi_user_text varchar(255) binary NOT NULL,
  oi_timestamp int NOT NULL default '',

  oi_metadata int NOT NULL,
  oi_media_type int default NULL,
  oi_major_mime int NOT NULL default "unknown",
  oi_minor_mime int NOT NULL default "unknown",
  oi_deleted tinyint unsigned NOT NULL default 0,
  oi_sha1 int NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE INDEX /*i*/oi_usertext_timestamp ON oldimage (oi_user_text,oi_timestamp);
CREATE INDEX /*i*/oi_name_timestamp ON oldimage (oi_name,oi_timestamp);
-- oi_archive_name truncated to 14 to avoid key length overflow
CREATE INDEX /*i*/oi_name_archive_name ON oldimage (oi_name,oi_archive_name(14));
CREATE INDEX /*i*/oi_sha1 ON oldimage (oi_sha1(10));


--
-- Record of deleted file data
--
CREATE TABLE filearchive (
  -- Unique row id
  fa_id int NOT NULL PRIMARY KEY AUTO_INCREMENT,

  -- Original base filename; key to image.img_name, page.page_title, etc
  fa_name varchar(255) binary NOT NULL default '',

  -- Filename of archived file, if an old revision
  fa_archive_name varchar(255) binary default '',

  -- Which storage bin (directory tree or object store) the file data
  -- is stored in. Should be 'deleted' for files that have been deleted;
  -- any other bin is not yet in use.
  fa_storage_group int,

  -- SHA-1 of the file contents plus extension, used as a key for storage.
  -- eg 8f8a562add37052a1848ff7771a2c515db94baa9.jpg
  --
  -- If NULL, the file was missing at deletion time or has been purged
  -- from the archival storage.
  fa_storage_key int default '',

  -- Deletion information, if this file is deleted.
  fa_deleted_user int,
  fa_deleted_timestamp int default '',
  fa_deleted_reason text,

  -- Duped fields from image
  fa_size int unsigned default 0,
  fa_width int default 0,
  fa_height int default 0,
  fa_metadata int,
  fa_bits int default 0,
  fa_media_type int default NULL,
  fa_major_mime int default "unknown",
  fa_minor_mime int default "unknown",
  fa_description int,
  fa_user int unsigned default 0,
  fa_user_text varchar(255) binary,
  fa_timestamp int default '',

  -- Visibility of deleted revisions, bitfield
  fa_deleted tinyint unsigned NOT NULL default 0,

  -- sha1 hash of file content
  fa_sha1 int NOT NULL default ''
) /*$wgDBTableOptions*/;

-- pick out by image name
CREATE INDEX /*i*/fa_name ON filearchive (fa_name, fa_timestamp);
-- pick out dupe files
CREATE INDEX /*i*/fa_storage_group ON filearchive (fa_storage_group, fa_storage_key);
-- sort by deletion time
CREATE INDEX /*i*/fa_deleted_timestamp ON filearchive (fa_deleted_timestamp);
-- sort by uploader
CREATE INDEX /*i*/fa_user_timestamp ON filearchive (fa_user_text,fa_timestamp);
-- find file by sha1, 10 bytes will be enough for hashes to be indexed
CREATE INDEX /*i*/fa_sha1 ON filearchive (fa_sha1(10));


--
-- Store information about newly uploaded files before they're
-- moved into the actual filestore
--
CREATE TABLE uploadstash (
  us_id int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,

  -- the user who uploaded the file.
  us_user int unsigned NOT NULL,

  -- file key. this is how applications actually search for the file.
  -- this might go away, or become the primary key.
  us_key varchar(255) NOT NULL,

  -- the original path
  us_orig_path varchar(255) NOT NULL,

  -- the temporary path at which the file is actually stored
  us_path varchar(255) NOT NULL,

  -- which type of upload the file came from (sometimes)
  us_source_type varchar(50),

  -- the date/time on which the file was added
  us_timestamp int NOT NULL,

  us_status varchar(50) NOT NULL,

  -- chunk counter starts at 0, current offset is stored in us_size
  us_chunk_inx int unsigned NULL,

  -- Serialized file properties from File::getPropsFromPath
  us_props int,

  -- file size in bytes
  us_size int unsigned NOT NULL,
  -- this hash comes from File::sha1Base36(), and is 31 characters
  us_sha1 varchar(31) NOT NULL,
  us_mime varchar(255),
  -- Media type as defined by the MEDIATYPE_xxx constants, should duplicate definition in the image table
  us_media_type int default NULL,
  -- image-specific properties
  us_image_width int unsigned,
  us_image_height int unsigned,
  us_image_bits smallint unsigned

) /*$wgDBTableOptions*/;

-- sometimes there's a delete for all of a user's stuff.
CREATE INDEX /*i*/us_user ON uploadstash (us_user);
-- pick out files by key, enforce key uniqueness
CREATE UNIQUE INDEX /*i*/us_key ON uploadstash (us_key);
-- the abandoned upload cleanup script needs this
CREATE INDEX /*i*/us_timestamp ON uploadstash (us_timestamp);


--
-- Primarily a summary table for Special:Recentchanges,
-- this table contains some additional info on edits from
-- the last few days, see Article::editUpdates()
--
CREATE TABLE recentchanges (
  rc_id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  rc_timestamp int NOT NULL default '',

  -- This is no longer used
  rc_cur_time int NOT NULL default '',

  -- As in revision
  rc_user int unsigned NOT NULL default 0,
  rc_user_text varchar(255) binary NOT NULL,

  -- When pages are renamed, their RC entries do _not_ change.
  rc_namespace int NOT NULL default 0,
  rc_title varchar(255) binary NOT NULL default '',

  -- as in revision...
  rc_comment varchar(255) binary NOT NULL default '',
  rc_minor tinyint unsigned NOT NULL default 0,

  -- Edits by user accounts with the 'bot' rights key are
  -- marked with a 1 here, and will be hidden from the
  -- default view.
  rc_bot tinyint unsigned NOT NULL default 0,

  -- Set if this change corresponds to a page creation
  rc_new tinyint unsigned NOT NULL default 0,

  -- Key to page_id (was cur_id prior to 1.5).
  -- This will keep links working after moves while
  -- retaining the at-the-time name in the changes list.
  rc_cur_id int unsigned NOT NULL default 0,

  -- rev_id of the given revision
  rc_this_oldid int unsigned NOT NULL default 0,

  -- rev_id of the prior revision, for generating diff links.
  rc_last_oldid int unsigned NOT NULL default 0,

  -- The type of change entry (RC_EDIT,RC_NEW,RC_LOG,RC_EXTERNAL)
  rc_type tinyint unsigned NOT NULL default 0,

  -- If the Recent Changes Patrol option is enabled,
  -- users may mark edits as having been reviewed to
  -- remove a warning flag on the RC list.
  -- A value of 1 indicates the page has been reviewed.
  rc_patrolled tinyint unsigned NOT NULL default 0,

  -- Recorded IP address the edit was made from, if the
  -- $wgPutIPinRC option is enabled.
  rc_ip int NOT NULL default '',

  -- Text length in characters before
  -- and after the edit
  rc_old_len int,
  rc_new_len int,

  -- Visibility of recent changes items, bitfield
  rc_deleted tinyint unsigned NOT NULL default 0,

  -- Value corresonding to log_id, specific log entries
  rc_logid int unsigned NOT NULL default 0,
  -- Store log type info here, or null
  rc_log_type int NULL default NULL,
  -- Store log action or null
  rc_log_action int NULL default NULL,
  -- Log params
  rc_params int NULL
) /*$wgDBTableOptions*/;

CREATE INDEX /*i*/rc_timestamp ON recentchanges (rc_timestamp);
CREATE INDEX /*i*/rc_namespace_title ON recentchanges (rc_namespace, rc_title);
CREATE INDEX /*i*/rc_cur_id ON recentchanges (rc_cur_id);
CREATE INDEX /*i*/new_name_timestamp ON recentchanges (rc_new,rc_namespace,rc_timestamp);
CREATE INDEX /*i*/rc_ip ON recentchanges (rc_ip);
CREATE INDEX /*i*/rc_ns_usertext ON recentchanges (rc_namespace, rc_user_text);
CREATE INDEX /*i*/rc_user_text ON recentchanges (rc_user_text, rc_timestamp);


CREATE TABLE watchlist (
  -- Key to user.user_id
  wl_user int unsigned NOT NULL,

  -- Key to page_namespace/page_title
  -- Note that users may watch pages which do not exist yet,
  -- or existed in the past but have been deleted.
  wl_namespace int NOT NULL default 0,
  wl_title varchar(255) binary NOT NULL default '',

  -- Timestamp when user was last sent a notification e-mail;
  -- cleared when the user visits the page.
  wl_notificationtimestamp int

) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/wl_user ON watchlist (wl_user, wl_namespace, wl_title);
CREATE INDEX /*i*/namespace_title ON watchlist (wl_namespace, wl_title);


--
-- When using the default MySQL search backend, page titles
-- and text are munged to strip markup, do Unicode case folding,
-- and prepare the result for MySQL's fulltext index.
--
-- This table must be MyISAM; InnoDB does not support the needed
-- fulltext index.
--
CREATE TABLE searchindex (
  -- Key to page_id
  si_page int unsigned NOT NULL,

  -- Munged version of title
  si_title varchar(255) NOT NULL default '',

  -- Munged version of body text
  si_text int NOT NULL
) ENGINE=MyISAM;

CREATE UNIQUE INDEX /*i*/si_page ON searchindex (si_page);
-- CREATE FULLTEXT INDEX /*i*/si_title ON searchindex (si_title);
-- CREATE FULLTEXT INDEX /*i*/si_text ON searchindex (si_text);


--
-- Recognized interwiki link prefixes
--
CREATE TABLE interwiki (
  -- The interwiki prefix, (e.g. "Meatball", or the language prefix "de")
  iw_prefix varchar(32) NOT NULL,

  -- The URL of the wiki, with "$1" as a placeholder for an article name.
  -- Any spaces in the name will be transformed to underscores before
  -- insertion.
  iw_url int NOT NULL,

  -- The URL of the file api.php
  iw_api int NOT NULL,

  -- The name of the database (for a connection to be established with wfGetLB( 'wikiid' ))
  iw_wikiid varchar(64) NOT NULL,

  -- A intean value indicating whether the wiki is in this project
  -- (used, for example, to detect redirect loops)
  iw_local int NOT NULL,

  -- intean value indicating whether interwiki transclusions are allowed.
  iw_trans tinyint NOT NULL default 0
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/iw_prefix ON interwiki (iw_prefix);


--
-- Used for caching expensive grouped queries
--
CREATE TABLE querycache (
  -- A key name, generally the base name of of the special page.
  qc_type int NOT NULL,

  -- Some sort of stored value. Sizes, counts...
  qc_value int unsigned NOT NULL default 0,

  -- Target namespace+title
  qc_namespace int NOT NULL default 0,
  qc_title varchar(255) binary NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE INDEX /*i*/qc_type ON querycache (qc_type,qc_value);


--
-- For a few generic cache operations if not using Memcached
--
CREATE TABLE objectcache (
  keyname int NOT NULL default '' PRIMARY KEY,
  value int,
  exptime datetime
) /*$wgDBTableOptions*/;
CREATE INDEX /*i*/exptime ON objectcache (exptime);


--
-- Cache of interwiki transclusion
--
CREATE TABLE transcache (
  tc_url int NOT NULL,
  tc_contents text,
  tc_time int NOT NULL
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/tc_url_idx ON transcache (tc_url);


CREATE TABLE logging (
  -- Log ID, for referring to this specific log entry, probably for deletion and such.
  log_id int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,

  -- Symbolic keys for the general log type and the action type
  -- within the log. The output format will be controlled by the
  -- action field, but only the type controls categorization.
  log_type int NOT NULL default '',
  log_action int NOT NULL default '',

  -- Timestamp. Duh.
  log_timestamp int NOT NULL default '19700101000000',

  -- The user who performed this action; key to user_id
  log_user int unsigned NOT NULL default 0,

  -- Name of the user who performed this action
  log_user_text varchar(255) binary NOT NULL default '',

  -- Key to the page affected. Where a user is the target,
  -- this will point to the user page.
  log_namespace int NOT NULL default 0,
  log_title varchar(255) binary NOT NULL default '',
  log_page int unsigned NULL,

  -- Freeform text. Interpreted as edit history comments.
  log_comment varchar(255) NOT NULL default '',

  -- miscellaneous parameters:
  -- LF separated list (old system) or serialized PHP array (new system)
  log_params int NOT NULL,

  -- rev_deleted for logs
  log_deleted tinyint unsigned NOT NULL default 0
) /*$wgDBTableOptions*/;

CREATE INDEX /*i*/type_time ON logging (log_type, log_timestamp);
CREATE INDEX /*i*/user_time ON logging (log_user, log_timestamp);
CREATE INDEX /*i*/page_time ON logging (log_namespace, log_title, log_timestamp);
CREATE INDEX /*i*/times ON logging (log_timestamp);
CREATE INDEX /*i*/log_user_type_time ON logging (log_user, log_type, log_timestamp);
CREATE INDEX /*i*/log_page_id_time ON logging (log_page,log_timestamp);
CREATE INDEX /*i*/type_action ON logging (log_type, log_action, log_timestamp);


CREATE TABLE log_search (
  -- The type of ID (rev ID, log ID, rev timestamp, username)
  ls_field int NOT NULL,
  -- The value of the ID
  ls_value varchar(255) NOT NULL,
  -- Key to log_id
  ls_log_id int unsigned NOT NULL default 0
) /*$wgDBTableOptions*/;
CREATE UNIQUE INDEX /*i*/ls_field_val ON log_search (ls_field,ls_value,ls_log_id);
CREATE INDEX /*i*/ls_log_id ON log_search (ls_log_id);


-- Jobs performed by parallel apache threads or a command-line daemon
CREATE TABLE job (
  job_id int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,

  -- Command name
  -- Limited to 60 to prevent key length overflow
  job_cmd int NOT NULL default '',

  -- Namespace and title to act on
  -- Should be 0 and '' if the command does not operate on a title
  job_namespace int NOT NULL,
  job_title varchar(255) binary NOT NULL,

  -- Timestamp of when the job was inserted
  -- NULL for jobs added before addition of the timestamp
  job_timestamp int NULL default NULL,

  -- Any other parameters to the command
  -- Stored as a PHP serialized array, or an empty string if there are no parameters
  job_params int NOT NULL,

  -- Random, non-unique, number used for job acquisition (for lock concurrency)
  job_random integer unsigned NOT NULL default 0,

  -- The number of times this job has been locked
  job_attempts integer unsigned NOT NULL default 0,

  -- Field that conveys process locks on rows via process UUIDs
  job_token int NOT NULL default '',

  -- Timestamp when the job was locked
  job_token_timestamp int NULL default NULL,

  -- Base 36 SHA1 of the job parameters relevant to detecting duplicates
  job_sha1 int NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE INDEX /*i*/job_sha1 ON job (job_sha1);
CREATE INDEX /*i*/job_cmd_token ON job (job_cmd,job_token,job_random);
CREATE INDEX /*i*/job_cmd_token_id ON job (job_cmd,job_token,job_id);
CREATE INDEX /*i*/job_cmd ON job (job_cmd, job_namespace, job_title, job_params(128));
CREATE INDEX /*i*/job_timestamp ON job (job_timestamp);


-- Details of updates to cached special pages
CREATE TABLE querycache_info (
  -- Special page name
  -- Corresponds to a qc_type value
  qci_type int NOT NULL default '',

  -- Timestamp of last update
  qci_timestamp int NOT NULL default '19700101000000'
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/qci_type ON querycache_info (qci_type);


-- For each redirect, this table contains exactly one row defining its target
CREATE TABLE redirect (
  -- Key to the page_id of the redirect page
  rd_from int unsigned NOT NULL default 0 PRIMARY KEY,

  -- Key to page_namespace/page_title of the target page.
  -- The target page may or may not exist, and due to renames
  -- and deletions may refer to different page records as time
  -- goes by.
  rd_namespace int NOT NULL default 0,
  rd_title varchar(255) binary NOT NULL default '',
  rd_interwiki varchar(32) default NULL,
  rd_fragment varchar(255) binary default NULL
) /*$wgDBTableOptions*/;

CREATE INDEX /*i*/rd_ns_title ON redirect (rd_namespace,rd_title,rd_from);


-- Used for caching expensive grouped queries that need two links (for example double-redirects)
CREATE TABLE querycachetwo (
  -- A key name, generally the base name of of the special page.
  qcc_type int NOT NULL,

  -- Some sort of stored value. Sizes, counts...
  qcc_value int unsigned NOT NULL default 0,

  -- Target namespace+title
  qcc_namespace int NOT NULL default 0,
  qcc_title varchar(255) binary NOT NULL default '',

  -- Target namespace+title2
  qcc_namespacetwo int NOT NULL default 0,
  qcc_titletwo varchar(255) binary NOT NULL default ''
) /*$wgDBTableOptions*/;

CREATE INDEX /*i*/qcc_type ON querycachetwo (qcc_type,qcc_value);
CREATE INDEX /*i*/qcc_title ON querycachetwo (qcc_type,qcc_namespace,qcc_title);
CREATE INDEX /*i*/qcc_titletwo ON querycachetwo (qcc_type,qcc_namespacetwo,qcc_titletwo);


-- Used for storing page restrictions (i.e. protection levels)
CREATE TABLE page_restrictions (
  -- Page to apply restrictions to (Foreign Key to page).
  pr_page int NOT NULL,
  -- The protection type (edit, move, etc)
  pr_type int NOT NULL,
  -- The protection level (Sysop, autoconfirmed, etc)
  pr_level int NOT NULL,
  -- Whether or not to cascade the protection down to pages transcluded.
  pr_cascade tinyint NOT NULL,
  -- Field for future support of per-user restriction.
  pr_user int NULL,
  -- Field for time-limited protection.
  pr_expiry int NULL,
  -- Field for an ID for this restrictions row (sort-key for Special:ProtectedPages)
  pr_id int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/pr_pagetype ON page_restrictions (pr_page,pr_type);
CREATE INDEX /*i*/pr_typelevel ON page_restrictions (pr_type,pr_level);
CREATE INDEX /*i*/pr_level ON page_restrictions (pr_level);
CREATE INDEX /*i*/pr_cascade ON page_restrictions (pr_cascade);


-- Protected titles - nonexistent pages that have been protected
CREATE TABLE protected_titles (
  pt_namespace int NOT NULL,
  pt_title varchar(255) binary NOT NULL,
  pt_user int unsigned NOT NULL,
  pt_reason int,
  pt_timestamp int NOT NULL,
  pt_expiry int NOT NULL default '',
  pt_create_perm int NOT NULL
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/pt_namespace_title ON protected_titles (pt_namespace,pt_title);
CREATE INDEX /*i*/pt_timestamp ON protected_titles (pt_timestamp);


-- Name/value pairs indexed by page_id
CREATE TABLE page_props (
  pp_page int NOT NULL,
  pp_propname int NOT NULL,
  pp_value int NOT NULL
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/pp_page_propname ON page_props (pp_page,pp_propname);
CREATE UNIQUE INDEX /*i*/pp_propname_page ON page_props (pp_propname,pp_page);


-- A table to log updates, one text key row per update.
CREATE TABLE updatelog (
  ul_key varchar(255) NOT NULL PRIMARY KEY,
  ul_value int
) /*$wgDBTableOptions*/;


-- A table to track tags for revisions, logs and recent changes.
CREATE TABLE change_tag (
  -- RCID for the change
  ct_rc_id int NULL,
  -- LOGID for the change
  ct_log_id int NULL,
  -- REVID for the change
  ct_rev_id int NULL,
  -- Tag applied
  ct_tag varchar(255) NOT NULL,
  -- Parameters for the tag, presently unused
  ct_params int NULL
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/change_tag_rc_tag ON change_tag (ct_rc_id,ct_tag);
CREATE UNIQUE INDEX /*i*/change_tag_log_tag ON change_tag (ct_log_id,ct_tag);
CREATE UNIQUE INDEX /*i*/change_tag_rev_tag ON change_tag (ct_rev_id,ct_tag);
-- Covering index, so we can pull all the info only out of the index.
CREATE INDEX /*i*/change_tag_tag_id ON change_tag (ct_tag,ct_rc_id,ct_rev_id,ct_log_id);


-- Rollup table to pull a LIST of tags simply without ugly GROUP_CONCAT
-- that only works on MySQL 4.1+
CREATE TABLE tag_summary (
  -- RCID for the change
  ts_rc_id int NULL,
  -- LOGID for the change
  ts_log_id int NULL,
  -- REVID for the change
  ts_rev_id int NULL,
  -- Comma-separated list of tags
  ts_tags int NOT NULL
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/tag_summary_rc_id ON tag_summary (ts_rc_id);
CREATE UNIQUE INDEX /*i*/tag_summary_log_id ON tag_summary (ts_log_id);
CREATE UNIQUE INDEX /*i*/tag_summary_rev_id ON tag_summary (ts_rev_id);


CREATE TABLE valid_tag (
  vt_tag varchar(255) NOT NULL PRIMARY KEY
) /*$wgDBTableOptions*/;

-- Table for storing localisation data
CREATE TABLE l10n_cache (
  -- Language code
  lc_lang int NOT NULL,
  -- Cache key
  lc_key varchar(255) NOT NULL,
  -- Value
  lc_value int NOT NULL
) /*$wgDBTableOptions*/;
CREATE INDEX /*i*/lc_lang_key ON l10n_cache (lc_lang, lc_key);

-- Table for caching JSON message ints for the resource loader
CREATE TABLE msg_resource (
  -- Resource name
  mr_resource int NOT NULL,
  -- Language code
  mr_lang int NOT NULL,
  -- JSON int
  mr_int int NOT NULL,
  -- Timestamp of last update
  mr_timestamp int NOT NULL
) /*$wgDBTableOptions*/;
CREATE UNIQUE INDEX /*i*/mr_resource_lang ON msg_resource (mr_resource, mr_lang);

-- Table for administering which message is contained in which resource
CREATE TABLE msg_resource_links (
  mrl_resource int NOT NULL,
  -- Message key
  mrl_message int NOT NULL
) /*$wgDBTableOptions*/;
CREATE UNIQUE INDEX /*i*/mrl_message_resource ON msg_resource_links (mrl_message, mrl_resource);

-- Table caching which local files a module depends on that aren't
-- registered directly, used for fast retrieval of file dependency.
-- Currently only used for tracking images that CSS depends on
CREATE TABLE module_deps (
  -- Module name
  md_module int NOT NULL,
  -- Skin name
  md_skin int NOT NULL,
  -- JSON int with file dependencies
  md_deps int NOT NULL
) /*$wgDBTableOptions*/;
CREATE UNIQUE INDEX /*i*/md_module_skin ON module_deps (md_module, md_skin);

-- Holds all the sites known to the wiki.
CREATE TABLE sites (
-- Numeric id of the site
  site_id                    INT UNSIGNED        NOT NULL PRIMARY KEY AUTO_INCREMENT,

  -- Global identifier for the site, ie 'enwiktionary'
  site_global_key            int       NOT NULL,

  -- Type of the site, ie 'mediawiki'
  site_type                  int       NOT NULL,

  -- Group of the site, ie 'wikipedia'
  site_group                 int       NOT NULL,

  -- Source of the site data, ie 'local', 'wikidata', 'my-magical-repo'
  site_source                int       NOT NULL,

  -- Language code of the sites primary language.
  site_language              int       NOT NULL,

  -- Protocol of the site, ie 'http://', 'irc://', '//'
  -- This field is an index for lookups and is build from type specific data in site_data.
  site_protocol              int       NOT NULL,

  -- Domain of the site in reverse order, ie 'org.mediawiki.www.'
  -- This field is an index for lookups and is build from type specific data in site_data.
  site_domain                VARCHAR(255)        NOT NULL,

  -- Type dependent site data.
  site_data                  int                NOT NULL,

  -- If site.tld/path/key:pageTitle should forward users to  the page on
  -- the actual site, where "key" is the local identifier.
  site_forward              int                NOT NULL,

  -- Type dependent site config.
  -- For instance if template transclusion should be allowed if it's a MediaWiki.
  site_config               int                NOT NULL
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/sites_global_key ON sites (site_global_key);
CREATE INDEX /*i*/sites_type ON sites (site_type);
CREATE INDEX /*i*/sites_group ON sites (site_group);
CREATE INDEX /*i*/sites_source ON sites (site_source);
CREATE INDEX /*i*/sites_language ON sites (site_language);
CREATE INDEX /*i*/sites_protocol ON sites (site_protocol);
CREATE INDEX /*i*/sites_domain ON sites (site_domain);
CREATE INDEX /*i*/sites_forward ON sites (site_forward);

-- Links local site identifiers to their corresponding site.
CREATE TABLE site_identifiers (
  -- Key on site.site_id
  si_site                    INT UNSIGNED        NOT NULL,

  -- local key type, ie 'interwiki' or 'langlink'
  si_type                    int       NOT NULL,

  -- local key value, ie 'en' or 'wiktionary'
  si_key                     int       NOT NULL
) /*$wgDBTableOptions*/;

CREATE UNIQUE INDEX /*i*/site_ids_type ON site_identifiers (si_type, si_key);
CREATE INDEX /*i*/site_ids_site ON site_identifiers (si_site);
CREATE INDEX /*i*/site_ids_key ON site_identifiers (si_key);

-- vim: sw=2 sts=2 et

