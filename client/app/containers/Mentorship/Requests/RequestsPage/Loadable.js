/**
 *
 * Asynchronously loads the component for RequestsPage
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/Mentorship/Requests/RequestsPage/index'));
