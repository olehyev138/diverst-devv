/*
 *
 * Group reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_GROUPS_BEGIN,
  GET_GROUPS_SUCCESS,
  GET_GROUPS_ERROR,
  GET_ANNUAL_BUDGETS_BEGIN,
  GET_ANNUAL_BUDGETS_SUCCESS,
  GET_ANNUAL_BUDGETS_ERROR,
  GET_GROUP_BEGIN,
  GET_GROUP_SUCCESS,
  GET_GROUP_ERROR,
  CREATE_GROUP_BEGIN,
  CREATE_GROUP_SUCCESS,
  CREATE_GROUP_ERROR,
  UPDATE_GROUP_BEGIN,
  UPDATE_GROUP_SUCCESS,
  UPDATE_GROUP_ERROR,
  UPDATE_GROUP_SETTINGS_BEGIN,
  UPDATE_GROUP_SETTINGS_SUCCESS,
  UPDATE_GROUP_SETTINGS_ERROR,
  DELETE_GROUP_BEGIN,
  DELETE_GROUP_SUCCESS,
  DELETE_GROUP_ERROR,
  GROUP_LIST_UNMOUNT,
  GROUP_FORM_UNMOUNT,
  CARRY_BUDGET_BEGIN,
  RESET_BUDGET_BEGIN,
  CARRY_BUDGET_SUCCESS,
  RESET_BUDGET_SUCCESS,
  LEAVE_GROUP_ERROR,
  JOIN_GROUP_ERROR,
  JOIN_GROUP_SUCCESS,
  LEAVE_GROUP_SUCCESS,
  JOIN_GROUP_BEGIN,
  LEAVE_GROUP_BEGIN,
  GROUP_CATEGORIZE_UNMOUNT,
  GROUP_CATEGORIZE_BEGIN,
  GROUP_CATEGORIZE_SUCCESS,
  GROUP_CATEGORIZE_ERROR,
  UPDATE_GROUP_POSITION_BEGIN,
  UPDATE_GROUP_POSITION_SUCCESS,
  UPDATE_GROUP_POSITION_ERROR,
  JOIN_SUBGROUPS_SUCCESS,
  JOIN_SUBGROUPS_ERROR,
  JOIN_SUBGROUPS_BEGIN,

} from './constants';

export const initialState = {
  isLoading: true,
  isFormLoading: true,
  isCommitting: false,
  groupList: [],
  groupTotal: null,
  currentGroup: null,
  hasChanged: false,
};

/* eslint-disable default-case, no-param-reassign */
function groupsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_GROUP_BEGIN:
        draft.isFormLoading = true;
        break;

      case GET_GROUP_SUCCESS:
        draft.currentGroup = action.payload.group;
        draft.isFormLoading = false;
        break;

      case GET_GROUP_ERROR:
        draft.isFormLoading = false;
        break;

      case GET_GROUPS_BEGIN:
      case GET_ANNUAL_BUDGETS_BEGIN:
        draft.isLoading = true;
        break;

      case GET_GROUPS_SUCCESS:
        draft.groupList = action.payload.items;
        draft.groupTotal = action.payload.total;
        draft.isLoading = false;
        break;

      case GET_ANNUAL_BUDGETS_SUCCESS:
        draft.groupList = action.payload.items;
        draft.groupTotal = action.payload.total;
        draft.isLoading = false;
        break;

      case GET_GROUPS_ERROR:
      case GET_ANNUAL_BUDGETS_ERROR:
        draft.isLoading = false;
        break;

      case CREATE_GROUP_BEGIN:
      case UPDATE_GROUP_BEGIN:
      case UPDATE_GROUP_POSITION_BEGIN:
      case GROUP_CATEGORIZE_BEGIN:
      case UPDATE_GROUP_SETTINGS_BEGIN:
      case DELETE_GROUP_BEGIN:
      case CARRY_BUDGET_BEGIN:
      case RESET_BUDGET_BEGIN:
      case JOIN_GROUP_BEGIN:
      case LEAVE_GROUP_BEGIN:
      case JOIN_SUBGROUPS_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case UPDATE_GROUP_SETTINGS_SUCCESS:
        draft.currentGroup = action.payload.group;
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_GROUP_SUCCESS:
      case UPDATE_GROUP_SUCCESS:
      case DELETE_GROUP_SUCCESS:
      case CARRY_BUDGET_SUCCESS:
      case RESET_BUDGET_SUCCESS:
      case GROUP_CATEGORIZE_SUCCESS:
      case JOIN_SUBGROUPS_SUCCESS:
      case UPDATE_GROUP_POSITION_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_GROUP_ERROR:
      case UPDATE_GROUP_ERROR:
      case GROUP_CATEGORIZE_ERROR:
      case UPDATE_GROUP_SETTINGS_ERROR:
      case UPDATE_GROUP_POSITION_ERROR:
      case DELETE_GROUP_ERROR:
      case JOIN_SUBGROUPS_ERROR:
        draft.isCommitting = false;
        break;

      case GROUP_LIST_UNMOUNT:
      case GROUP_FORM_UNMOUNT:
      case GROUP_CATEGORIZE_UNMOUNT:
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

function flattenChildrenGroups(groups) {
  /* eslint-disable no-return-assign */

  /* Format groups to hash by id:
   *   { <id>: { name: group_01, ... } }
   */
  return groups.reduce((map, group) => {
    map.push(group);
    const con = map.concat(flattenChildrenGroups(group.children || []));
    delete group.children;
    return con;
  }, []);
}

export default groupsReducer;
