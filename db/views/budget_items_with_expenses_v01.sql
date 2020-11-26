SELECT
    `budget_items`.*,
    COALESCE(`spent`, 0) as spent,
    COALESCE(`reserved`, 0) as reserved,
    COALESCE(`user_estimates`, 0) as user_estimates,
    COALESCE(`finalized_expenditures`, 0) as finalized_expenditures,
    COALESCE(`estimated_amount` - `spent`, 0) as unspent,
    IF((`budget_id` IS NULL OR `is_done` OR NOT `budgets`.`is_approved`) = TRUE, 0,
       COALESCE(`estimated_amount` - `reserved`, 0)) as available
FROM `budget_items`
    JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id`
    LEFT JOIN `budget_items_sums` ON `budget_items`.`id` = `budget_items_sums`.`budget_item_id`;