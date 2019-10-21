/*
 *
 * Group reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_GROUPS_ERROR, GET_GROUPS_SUCCESS,
  GET_GROUP_ERROR, GET_GROUP_SUCCESS,
  GROUP_LIST_UNMOUNT, GROUP_FORM_UNMOUNT,
  GET_GROUPS_BEGIN,
} from 'containers/Group/constants';

export const initialState = {
  isLoading: true,
  groupList: {},
  groupTotal: null,
  currentGroup: null,
};

/* eslint-disable default-case, no-param-reassign */
function groupsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_GROUP_ERROR:
        draft.isLoading = false;
        break;
      case GET_GROUP_SUCCESS:
        draft.currentGroup = action.payload.group;
        draft.isLoading = false;
        break;
      case GET_GROUPS_BEGIN:
        draft.isLoading = true;
        break;
      case GET_GROUPS_SUCCESS:
        draft.groupList = formatGroups(action.payload.items);
        draft.groupTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_GROUPS_ERROR:
        draft.isLoading = false;
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

  /* Format groups to hash by id:
   *   { <id>: { name: group_01, ... } }
   */
  return groups.reduce((map, group) => {
    map[group.id] = group;
    return map;
  }, {});
}

export default groupsReducer;
