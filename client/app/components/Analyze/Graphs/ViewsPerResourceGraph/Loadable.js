/**
 *
 * Asynchronously loads the component for ViewsPerResourceGraph
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Graphs/ViewsPerResourceGraph'));
