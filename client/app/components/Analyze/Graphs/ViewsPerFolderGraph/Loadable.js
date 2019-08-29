/**
 *
 * Asynchronously loads the component for ViewsPerFolderGraph
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Analyze/Graphs/ViewsPerFolderGraph'));
