/**
 *
 * Asynchronously loads the component for UserCreatePage
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/User/UserCreatePage/index'));
