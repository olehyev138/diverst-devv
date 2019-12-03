/**
 *
 * Asynchronously loads the component for SSOsettings
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/GlobalSettings/SSOSettings/index'));
