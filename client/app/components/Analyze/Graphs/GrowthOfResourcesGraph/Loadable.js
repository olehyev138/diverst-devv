/**
 *
 * Asynchronously loads the component for GrowthOfResourcesGraph
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Graphs/GrowthOfResourcesGraph'));
