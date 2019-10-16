/**
 *
 * Asynchronously loads the component for UserProfilePage
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/Mentorship/MentorshipProfilePage/index'));
