/**
 *
 * Asynchronously loads the component for Mentor Requests
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Mentorship/MentorRequestList/index'));
