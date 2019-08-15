/**
 *
 * Asynchronously loads the component for Outcomes List
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Group/Outcome/OutcomesList/index'));
