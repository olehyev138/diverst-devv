/**
 *
 * Asynchronously loads the component for ThemeProvider
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('./index'));
