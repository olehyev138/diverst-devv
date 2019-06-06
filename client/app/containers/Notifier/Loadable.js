/**
 *
 * Asynchronously loads the component for Notifier
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('./index'));
