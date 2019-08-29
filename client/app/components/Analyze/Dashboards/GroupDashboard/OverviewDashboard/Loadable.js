/**
 *
 * Asynchronously loads the component for OverviewDashboard
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Dashboards/GroupDashboard/OverviewDashboard/index'));
