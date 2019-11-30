/**
 *
 * Asynchronously loads the component for Sessions List
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Mentorship/SessionsList/index'));
