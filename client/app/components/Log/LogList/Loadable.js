/**
 *
 * Asynchronously loads the component for LogList
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Log/LogList/index'));
