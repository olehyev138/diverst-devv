/**
 *
 * Asynchronously loads the component for SSOSettingsPage
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/GlobalSettings/SSOSettingsPage/index'));
