/**
 *
 * Asynchronously loads the component for UserDashboardPage
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/Analyze/Dashboards/UserDashboardPage/index'));
