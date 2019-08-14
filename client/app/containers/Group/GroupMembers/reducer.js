/*
 *
 * Members reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_MEMBERS_BEGIN, GET_MEMBERS_ERROR,
  GET_MEMBERS_SUCCESS, GROUP_MEMBERS_UNMOUNT
} from 'containers/Group/GroupMembers/constants';

export const initialState = {
  memberList: [],
  memberTotal: null,
  isFetchingMembers: true
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function membersReducer(state = initialState, action) {
  return produce(state, (draft) => {
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
    map.push(member.user);
    return map;
  }, []);
}

export default membersReducer;
