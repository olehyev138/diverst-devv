/*
 *
 * GroupLeaders reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_GROUP_LEADERS_BEGIN, GET_GROUP_LEADERS_ERROR,
  GET_GROUP_LEADERS_SUCCESS, GET_GROUP_LEADER_BEGIN, GET_GROUP_LEADER_SUCCESS,
  GET_GROUP_LEADER_ERROR, GROUP_LEADERS_UNMOUNT,
  CREATE_GROUP_LEADER_BEGIN, CREATE_GROUP_LEADER_SUCCESS, CREATE_GROUP_LEADER_ERROR,
} from './constants';

export const initialState = {
  isCommitting: false,
  isFormLoading: true,
  groupLeaderList: [],
  groupLeaderTotal: null,
  isFetchingGroupLeaders: true,
  currentGroupLeader: null,
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function groupLeadersReducer(state = initialState, action) {
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_GROUP_LEADERS_BEGIN:
        draft.isFetchingGroupLeaders = true;
        break;
      case GET_GROUP_LEADERS_SUCCESS:
        draft.groupLeaderList = action.payload.items;
        draft.groupLeaderTotal = action.payload.total;
        draft.isFetchingGroupLeaders = false;
        break;
      case GET_GROUP_LEADERS_ERROR:
        draft.isFetchingGroupLeaders = false;
        break;
      case CREATE_GROUP_LEADER_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_GROUP_LEADER_SUCCESS:
      case CREATE_GROUP_LEADER_ERROR:
        draft.isCommitting = false;
        break;
      case GET_GROUP_LEADER_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_GROUP_LEADER_SUCCESS:
        draft.currentGroupLeader = action.payload.group_leader;
        draft.isFormLoading = false;
        break;
      case GET_GROUP_LEADER_ERROR:
        draft.isFormLoading = false;
        break;
      case GROUP_LEADERS_UNMOUNT:
        return initialState;
    }
  });
}

export default groupLeadersReducer;
