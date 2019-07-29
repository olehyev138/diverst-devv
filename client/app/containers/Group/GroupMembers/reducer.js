/*
 *
 * Members reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_MEMBERS_SUCCESS, GROUP_MEMBERS_UNMOUNT
} from 'containers/Group/GroupMembers/constants';

export const initialState = {
  memberList: {},
  memberTotal: null,
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function membersReducer(state = initialState, action) {
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_MEMBERS_SUCCESS:
        draft.memberList = formatMembers(action.payload.items);
        draft.memberTotal = action.payload.total;
        break;
      case GROUP_MEMBERS_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

function formatMembers(members) {
  /* eslint-disable no-return-assign */

  /* Format users to hash by id:
   *   { <id>: { name: user_01, ... } }
   */
  return members.reduce((map, member) => {
    map[member.user_id] = member.user;
    return map;
  }, {});
}

export default membersReducer;
