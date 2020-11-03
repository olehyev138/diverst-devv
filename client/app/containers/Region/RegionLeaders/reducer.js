/*
 *
 * RegionLeaders reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_REGION_LEADERS_BEGIN, GET_REGION_LEADERS_ERROR,
  GET_REGION_LEADERS_SUCCESS, GET_REGION_LEADER_BEGIN, GET_REGION_LEADER_SUCCESS,
  GET_REGION_LEADER_ERROR, REGION_LEADERS_UNMOUNT,
  CREATE_REGION_LEADER_BEGIN, CREATE_REGION_LEADER_SUCCESS, CREATE_REGION_LEADER_ERROR,
} from './constants';

export const initialState = {
  isCommitting: false,
  isFormLoading: true,
  regionLeaderList: [],
  regionLeaderTotal: null,
  isFetchingRegionLeaders: true,
  currentRegionLeader: null,
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function regionLeadersReducer(state = initialState, action) {
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_REGION_LEADERS_BEGIN:
        draft.isFetchingRegionLeaders = true;
        break;
      case GET_REGION_LEADERS_SUCCESS:
        draft.regionLeaderList = action.payload.items;
        draft.regionLeaderTotal = action.payload.total;
        draft.isFetchingRegionLeaders = false;
        break;
      case GET_REGION_LEADERS_ERROR:
        draft.isFetchingRegionLeaders = false;
        break;
      case CREATE_REGION_LEADER_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_REGION_LEADER_SUCCESS:
      case CREATE_REGION_LEADER_ERROR:
        draft.isCommitting = false;
        break;
      case GET_REGION_LEADER_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_REGION_LEADER_SUCCESS:
        draft.currentRegionLeader = action.payload.region_leader;
        draft.isFormLoading = false;
        break;
      case GET_REGION_LEADER_ERROR:
        draft.isFormLoading = false;
        break;
      case REGION_LEADERS_UNMOUNT:
        return initialState;
    }
  });
}

export default regionLeadersReducer;
