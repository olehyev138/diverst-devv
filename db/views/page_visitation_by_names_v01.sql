(
  SELECT
	a.user_id,
    b.page_name,
    NULL AS page_url,
    SUM(visits_day) as visits_day,
    SUM(visits_week) as visits_week,
    SUM(visits_month) as visits_month,
    SUM(visits_year) as visits_year,
    SUM(visits_all) as visits_all
  FROM
    page_visitation_data a
    JOIN duplicate_page_names b ON a.page_url = b.page_url
  GROUP BY
    a.user_id, b.page_name
)
UNION ALL
(
  SELECT
    a.user_id,
	b.page_name,
    a.page_url,
    SUM(visits_day) as visits_day,
    SUM(visits_week) as visits_week,
    SUM(visits_month) as visits_month,
    SUM(visits_year) as visits_year,
    SUM(visits_all) as visits_all
  FROM
    page_visitation_data a
    JOIN unique_page_names b ON a.page_url = b.page_url
  GROUP BY
    a.user_id, b.page_url,
    b.page_name
)