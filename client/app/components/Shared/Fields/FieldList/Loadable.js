/**
 *
 * Asynchronously loads the component for Fields
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Shared/Fields/FieldList/index'));
