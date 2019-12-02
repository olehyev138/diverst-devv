/**
 *
 * Asynchronously loads the component for Outcome Event List Item
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Event/OutcomeEventListItem/index'));
