/**
 *
 * Asynchronously loads the component for LoginForm
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Session/LoginForm/index'));
