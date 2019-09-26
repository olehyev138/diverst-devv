/**
 *
 * Asynchronously loads the component for base CustomGraph
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Graphs/Base/CustomGraph'));
