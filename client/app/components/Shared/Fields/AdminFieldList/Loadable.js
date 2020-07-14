/**
 *
 * Asynchronously loads the component for Admin Fields
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Shared/Fields/AdminFieldList/index'));
