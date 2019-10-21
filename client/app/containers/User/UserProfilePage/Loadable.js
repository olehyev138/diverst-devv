/**
 *
 * Asynchronously loads the component for UserEditPage
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/User/UserProfilePage/index'));
