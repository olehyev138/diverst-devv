/**
 *
 * Asynchronously loads the component for MetricsDashboards List
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/MetricsDashboard/MetricsDashboardsList/index'));
