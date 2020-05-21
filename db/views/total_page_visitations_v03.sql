SELECT
    a.page_url,
    b.page_name,
    c.enterprise_id,
    SUM(visits_day) as visits_day,
    SUM(visits_week) as visits_week,
    SUM(visits_month) as visits_month,
    SUM(visits_year) as visits_year,
    SUM(visits_all) as visits_all
FROM
    page_visitation_data a
        JOIN page_names b ON a.page_url = b.page_url
        JOIN users c ON c.id = a.user_id
GROUP BY
    a.page_url, b.page_name, c.enterprise_id