/**
 *
 * Asynchronously loads the component for GrowthOfUsersGraphPage
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/Analyze/Graphs/GrowthOfUsersGraphPage'));
