SELECT
    `budgets`.*,
    COALESCE(`spent`, 0) as spent,
    COALESCE(`reserved`, 0) as reserved,
    COALESCE(`requested_amount`, 0) as requested_amount,
    COALESCE(COALESCE(`requested_amount`, 0) - `reserved`, 0) as available,
    COALESCE(COALESCE(`requested_amount`, 0) - `spent`, 0) as unspent,
    IF(`is_approved` = TRUE, `requested_amount`, 0) as approved_amount
FROM `budgets`
    LEFT JOIN `budgets_sums` ON `budgets`.`id` = `budgets_sums`.`budget_id`;