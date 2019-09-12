/**
 *
 * Asynchronously loads the component for CustomGraphPage
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphPage/index'));
