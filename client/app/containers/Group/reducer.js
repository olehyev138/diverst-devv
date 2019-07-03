/*
 *
 * Group reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_GROUPS_SUCCESS, GET_GROUP_SUCCESS,
  GET_GROUPS_ERROR, GROUP_LIST_UNMOUNT, GROUP_FORM_UNMOUNT
} from 'containers/Group/constants';

export const initialState = {
  groupList: {},
  groupTotal: null,
};

/* eslint-disable default-case, no-param-reassign */
function groupsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_GROUPS_SUCCESS:
        draft.groupList = formatGroups(action.payload.items);
        draft.groupTotal = action.payload.total;
        break;
      case GET_GROUP_SUCCESS:
        draft.groupList[`${action.payload.group.id}`] = action.payload.group;
        break;
      case GROUP_LIST_UNMOUNT:
        return initialState;
      case GROUP_FORM_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

function formatGroups(groups) {
  /* eslint-disable no-return-assign */
  return groups.reduce((map, group) => {
    map[group.id] = group;
    return map;
  }, {});
}

export default groupsReducer;
