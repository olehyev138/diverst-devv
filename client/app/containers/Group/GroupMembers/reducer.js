/*
 *
 * Members reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_MEMBERS_BEGIN, GET_MEMBERS_ERROR,
  GET_MEMBERS_SUCCESS, GROUP_MEMBERS_UNMOUNT,
  CREATE_MEMBERS_BEGIN, CREATE_MEMBERS_SUCCESS, CREATE_MEMBERS_ERROR,
  EXPORT_MEMBERS_BEGIN, EXPORT_MEMBERS_ERROR, EXPORT_MEMBERS_SUCCESS
} from 'containers/Group/GroupMembers/constants';

export const initialState = {
  isCommitting: false,
  memberList: [],
  memberTotal: null,
  isFetchingMembers: true
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function membersReducer(state = initialState, action) {
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_MEMBERS_BEGIN:
        draft.isFetchingMembers = true;
        break;
      case GET_MEMBERS_SUCCESS:
        draft.memberList = formatMembers(action.payload.items);
        draft.memberTotal = action.payload.total;
        draft.isFetchingMembers = false;
        break;
      case GET_MEMBERS_ERROR:
        draft.isFetchingMembers = false;
        break;
      case CREATE_MEMBERS_BEGIN:
      case EXPORT_MEMBERS_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_MEMBERS_SUCCESS:
      case CREATE_MEMBERS_ERROR:
      case EXPORT_MEMBERS_SUCCESS:
      case EXPORT_MEMBERS_ERROR:
        draft.isCommitting = false;
        break;
      case GROUP_MEMBERS_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

function formatMembers(members) {
  /* eslint-disable no-return-assign */

  /* Extract user out of each member
   *   { group_id: <>, user: { ... }  } -> { first_name: <>, ... }
   */
  return members.reduce((map, member) => {
    map.push({ user: member.user, status: member.status });
    return map;
  }, []);
}

export default membersReducer;
