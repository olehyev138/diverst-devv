/*
 *
 * Groups reducer
 *
 */
import produce from 'immer';
import { GET_GROUPS_BEGIN, GET_GROUPS_SUCCESS, GET_GROUPS_ERROR } from './constants';

export const initialState = {
  groups: null,
  groupTotal: null,
};

/* eslint-disable default-case, no-param-reassign */
function groupsReducer(state = initialState, action) {
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_GROUPS_SUCCESS:
        draft.groups = action.payload.items.groups;
        draft.groupTotal = action.payload.total;
        break;
    }
  });
}

export default groupsReducer;
