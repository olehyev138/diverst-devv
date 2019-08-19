SELECT
	page_names.*
FROM page_names
WHERE page_names.page_name IN (
	SELECT page_name
	FROM
		page_names 
	GROUP BY
		page_names.page_name 
	HAVING
		COUNT(*) > 1 
)