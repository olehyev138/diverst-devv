SELECT
    `annual_budgets`.*,
    COALESCE(`spent`, 0) as spent,
    COALESCE(`reserved`, 0) as reserved,
    COALESCE(`requested_amount`, 0) as requested_amount,
    COALESCE(`available`, 0) as available,
    COALESCE(`approved` - `spent`, 0) as unspent,
    COALESCE(COALESCE(`amount`, 0) - `spent`, 0) as leftover,
    COALESCE(COALESCE(`amount`, 0) - `approved`, 0) as free
FROM `annual_budgets`
    LEFT JOIN `annual_budgets_sums` ON `annual_budgets`.`id` = `annual_budgets_sums`.`annual_budget_id`;