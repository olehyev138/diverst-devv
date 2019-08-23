/**
 *
 * Asynchronously loads the component for base BarGraph
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Graphs/Base/BarGraph'));
