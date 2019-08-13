/**
 *
 * Asynchronously loads the component for Outcomes
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Group/Outcome/Outcomes/index'));
