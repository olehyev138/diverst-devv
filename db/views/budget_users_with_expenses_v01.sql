SELECT
    `budget_users`.*,
    COALESCE(`spent`, 0) as spent,
    CASE `finished_expenses` WHEN TRUE THEN COALESCE(`spent`, 0) ELSE COALESCE(`estimated`, 0) END as reserved,
    CASE `finished_expenses` WHEN TRUE THEN COALESCE(`spent`, 0) ELSE 0 END as final_expense
FROM `budget_users`
    LEFT JOIN `budget_users_sums`
    ON `budget_users`.`id` = `budget_users_sums`.`budget_user_id`;