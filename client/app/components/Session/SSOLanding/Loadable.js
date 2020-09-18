/**
 *
 * Asynchronously loads the component for SSOLanding
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Session/SSOLanding/index'));
