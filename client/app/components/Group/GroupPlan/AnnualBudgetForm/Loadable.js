/**
 *
 * Asynchronously loads the component for Users
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Group/GroupPlan/AnnualBudgetForm'));
