/**
 *
 * Asynchronously loads the component for MetricsDashboard List
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Dashboards/MetricsDashboard/MetricsDashboardList/index'));
