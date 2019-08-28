/**
 *
 * Asynchronously loads the component for ResourcesDashboard
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Dashboards/GroupDashboard/ResourcesDashboard/index'));
