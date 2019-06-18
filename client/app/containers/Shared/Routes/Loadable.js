/**
 *
 * Asynchronously loads the component for LoginPage
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/Shared/Routes/index'));
