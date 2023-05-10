SELECT
	-- Return submitted representation for consistency.
	focus.ri AS "visit-resource",

	-- Measurements
	COALESCE(COUNT(*), 0) AS "visit-count",
	DATETIME(MIN(visit_time)/1000000.0 - 11644473600, 'unixepoch') AS "visit-first",
	DATETIME(MAX(visit_time)/1000000.0 - 11644473600, 'unixepoch') AS "visit-last"
FROM "xvq" AS focus
	LEFT JOIN "urls" AS u
		-- Join on expression normalizing https to http.
		ON (LOWER(focus.ri) =
			LOWER(
				(CASE
					WHEN instr(u.url, 'https:') = 1 THEN
						'http' || substr(u.url, 6)
					ELSE
						u.url
				END)
			)
		)
	LEFT JOIN "visits" AS v
		ON (u.id = v.url)
GROUP BY v.url
ORDER BY visit_time ASC
