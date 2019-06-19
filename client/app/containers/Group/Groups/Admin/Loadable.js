/**
 *
 * Asynchronously loads the component for Groups
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/Group/Groups/index'));
