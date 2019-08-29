/**
 *
 * Asynchronously loads the component for GrowthOfUsersGraph
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Graphs/GrowthOfUsersGraph'));
