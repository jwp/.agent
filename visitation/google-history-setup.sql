CREATE TEMP TABLE "xvq" (ri LONGVARCHAR);
DROP INDEX IF EXISTS "xal-lower-url";
CREATE INDEX "xal-lower-url" ON "urls" (
	-- LOWER the normalized url form. https -> http
	LOWER(
		(CASE
			WHEN instr(url, 'https:') = 1 THEN
				'http' || substr(url, 6)
			ELSE
				url
		END)
	)
);
