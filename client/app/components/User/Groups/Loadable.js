/**
 *
 * Asynchronously loads the component for Groups
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Admin/Manage/Groups/index'));
