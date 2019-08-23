/**
 *
 * Asynchronously loads the component for SegmentList
 *
 */

import loadable from 'utils/loadable';

export default loadable(() => import('components/Segment/SegmentList/index'));
