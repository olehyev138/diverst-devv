/**
 *
 * Asynchronously loads the component for User
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/User/UsersImportPage/index'));
