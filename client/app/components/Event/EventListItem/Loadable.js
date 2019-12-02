/**
 *
 * Asynchronously loads the component for Event List Item
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Event/EventListItem/index'));
