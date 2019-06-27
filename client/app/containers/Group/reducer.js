/*
 *
 * Group reducer
 *
 */

import produce from 'immer/dist/immer';
import { GET_GROUPS_SUCCESS, FETCH_GROUP_SUCCESS, GET_GROUPS_ERROR } from 'containers/Group/constants';

export const initialState = {
  groups: null,
  groupTotal: null,
};

/* eslint-disable default-case, no-param-reassign */
function groupsReducer(state = initialState, action) {
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_GROUPS_SUCCESS:
        draft.groups = formatGroups(action.payload.items.groups);
        draft.groupTotal = action.payload.total;
        break;
      case FETCH_GROUP_SUCCESS:
        console.log('hheey');
        /// console.log(action);
        break;
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
