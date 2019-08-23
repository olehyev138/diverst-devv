/**
 *
 * Asynchronously loads the component for SegmentPage
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('containers/Segment/SegmentPage/index'));
