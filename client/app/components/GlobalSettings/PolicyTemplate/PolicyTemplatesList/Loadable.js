/**
 *
 * Asynchronously loads the component for Events List
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/GlobalSettings/PolicyTemplate/PolicyTemplatesList/index'));
