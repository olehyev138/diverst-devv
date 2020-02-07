/**
 *
 * Asynchronously loads the component for BrandingTheme
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('./index'));
