/**
 *
 * Asynchronously loads the FieldInputList component
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/User/UserFieldInputForm/index'));
