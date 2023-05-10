## X-Agent-Links: TSV

Extraction and conversion tools for sessions, bookmarks, and HTML anchors.
Not really intended to be useful to others.

Link storage structure:

	1. Link
	2. Time Context (Date Added or First Visit or Nothing)
	3. Icon (Often a data URI)
	4. Title (An emoji laden mess)

Aggregate visitation structure:

	1. Link
	2. Visit Count
	3. Earliest Visit Time
	4. Latest Visit Time

Released under CC-0 or Public Domain.

### Purpose

- Tab exports for controlling oversized user agent sessions.
- Session backup exports for recovering past tabs.
- Link extraction from other XML/HTML link stores. (netscape bookmark exports)

### Usage

```shell
# Copy or move session json, bookmarks, HTML files inside one directory.
xal process path/to/export/collection/ filters-file >links.tsv

# Copies sqlite database into temporary directory before joining with `links.tsv`.
xal track -Amozilla-firefox -Agoogle-chrome <links.tsv >visits.tsv
```
