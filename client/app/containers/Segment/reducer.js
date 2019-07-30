/*
 *
 * Segment reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_SEGMENTS_SUCCESS, GET_SEGMENT_SUCCESS,
  SEGMENT_UNMOUNT
} from 'containers/Segment/constants';

export const initialState = {
  segmentList: {},
  segmentTotal: null,
  currentSegment: null,
};

/* eslint-disable default-case, no-param-reassign */
function segmentsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_SEGMENTS_SUCCESS:
        draft.segmentList = formatSegments(action.payload.items);
        draft.segmentTotal = action.payload.total;
        break;
      case GET_SEGMENT_SUCCESS:
        draft.currentSegment = action.payload.segment;
        break;
      case SEGMENT_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

function formatSegments(segments) {
  /* eslint-disable no-return-assign */

  /* Format segments to hash by id:
   *   { <id>: { name: segment_01, ... } }
   */
  return segments.reduce((map, segment) => {
    map[segment.id] = segment;
    return map;
  }, {});
}

export default segmentsReducer;
