SELECT
	-- Return submitted representation for consistency.
	focus.ri AS "visit-resource",

	-- Measurements
	COALESCE(visit_count, 0) AS "visit-count",
	DATETIME(MIN(visit_date)/1000000.0, 'unixepoch') AS "visit-first",
	DATETIME(MAX(visit_date)/1000000.0, 'unixepoch') AS "visit-last"
FROM "xvq" AS focus
	LEFT JOIN moz_places
		-- Join on expression normalizing https to http.
		ON (LOWER(focus.ri) =
			LOWER(
				(CASE
					WHEN instr(moz_places.url, 'https:') = 1 THEN
						'http' || substr(moz_places.url, 6)
					ELSE
						moz_places.url
				END)
			)
		)
	LEFT JOIN moz_historyvisits
		ON (moz_places.id = moz_historyvisits.place_id)
GROUP BY place_id
ORDER BY visit_date ASC
