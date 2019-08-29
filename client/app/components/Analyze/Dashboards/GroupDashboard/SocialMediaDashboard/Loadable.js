/**
 *
 * Asynchronously loads the component for SocialMediaDashboard
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Dashboards/GroupDashboard/SocialMediaDashboard/index'));
