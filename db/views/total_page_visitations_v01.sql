SELECT
  page_visitation_data.page AS page,
  SUM(page_visitation_data.times_visited) AS times_visited
FROM page_visitation_data
GROUP BY page_visitation_data.page
