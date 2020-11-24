SELECT
    `budget_users`.*,
    COALESCE(`spent`, 0)                                                           as spent,
    IF(`finished_expenses` = TRUE, COALESCE(`spent`, 0), COALESCE(`estimated`, 0)) as reserved,
    IF(`finished_expenses` = TRUE, COALESCE(`spent`, 0), 0)                        as final_expense
FROM `budget_users`
    LEFT JOIN `budget_users_sums`
    ON `budget_users`.`id` = `budget_users_sums`.`budget_user_id`;