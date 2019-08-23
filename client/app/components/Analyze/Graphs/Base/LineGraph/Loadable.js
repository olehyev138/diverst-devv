/**
 *
 * Asynchronously loads the component for base LineGraph
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Graphs/Base/LineGraph'));
