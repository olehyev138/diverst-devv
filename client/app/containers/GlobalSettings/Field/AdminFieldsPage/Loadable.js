/**
 *
 * Asynchronously loads the component for Field
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/GlobalSettings/Field/AdminFieldsPage/index'));
