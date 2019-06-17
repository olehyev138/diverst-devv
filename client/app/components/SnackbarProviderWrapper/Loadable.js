/**
 *
 * Asynchronously loads the component for SnackbarProviderWrapper
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('./index'));
