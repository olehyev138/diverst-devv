/**
 *
 * Asynchronously loads the component for EventsDashboard
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Dashboards/GroupDashboard/EventsDashboard/index'));
