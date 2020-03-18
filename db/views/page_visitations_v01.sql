SELECT
    a.*,
    b.page_name
FROM
    page_visitation_data a
        JOIN page_names b ON a.page_url = b.page_url