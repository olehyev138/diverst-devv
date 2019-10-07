/*
 *
 * Segment reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_SEGMENTS_SUCCESS, GET_SEGMENT_SUCCESS,
  GET_SEGMENT_MEMBERS_BEGIN, GET_SEGMENT_MEMBERS_SUCCESS,
  GET_SEGMENT_MEMBERS_ERROR, GET_SEGMENTS_BEGIN,
  SEGMENT_UNMOUNT, GET_SEGMENTS_ERROR, GET_SEGMENT_ERROR
} from 'containers/Segment/constants';

export const initialState = {
  isLoading: true,
  segmentList: {},
  segmentTotal: null,
  currentSegment: null,
  segmentMemberList: [],
  segmentMemberTotal: null,
  isFetchingSegmentMembers: true,
  isSegmentBuilding: false
};

/* eslint-disable default-case, no-param-reassign */
function segmentsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_SEGMENTS_BEGIN:
        draft.isLoading = true;
        break;
      case GET_SEGMENTS_SUCCESS:
        draft.segmentList = formatSegments(action.payload.items);
        draft.segmentTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_SEGMENTS_ERROR:
        draft.isLoading = false;
        break;
      case GET_SEGMENT_SUCCESS:
        draft.currentSegment = action.payload.segment;
        draft.isLoading = false;
        break;
      case GET_SEGMENT_ERROR:
        draft.isLoading = false;
        break;
      case GET_SEGMENT_MEMBERS_BEGIN:
        draft.isFetchingSegmentMembers = true;
        break;
      case GET_SEGMENT_MEMBERS_SUCCESS:
        draft.segmentMemberList = formatSegmentMembers(action.payload.items);
        draft.segmentMemberTotal = action.payload.total;
        draft.isFetchingSegmentMembers = false;
        break;
      case GET_SEGMENT_MEMBERS_ERROR:
        draft.isFetchingSegmentMembers = false;
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

function formatSegmentMembers(members) {
  /* eslint-disable no-return-assign */

  /* Extract user out of each member
   *   { group_id: <>, user: { ... }  } -> { first_name: <>, ... }
   */
  return members.reduce((map, member) => {
    map.push(member.user);
    return map;
  }, []);
}


export default segmentsReducer;
