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
} from './constants';

export const initialState = {
  groupList: {},
  groupTotal: null,
  currentGroup: null,
  isLoading: true,
  isFormLoading: true,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable default-case, no-param-reassign */
function groupsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
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
        draft.groupList = formatGroups(action.payload.items);
        draft.groupTotal = action.payload.total;
        draft.isLoading = false;
        break;

      case GET_ANNUAL_BUDGETS_SUCCESS:
        draft.groupList = formatGroups(flattenChildrenGroups(action.payload.items));
        draft.groupTotal = action.payload.total;
        draft.isLoading = false;
        break;

      case GET_GROUPS_ERROR:
      case GET_ANNUAL_BUDGETS_ERROR:
        draft.isLoading = false;
        break;

      case CREATE_GROUP_BEGIN:
      case UPDATE_GROUP_BEGIN:
      case UPDATE_GROUP_SETTINGS_BEGIN:
      case DELETE_GROUP_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_GROUP_SUCCESS:
      case UPDATE_GROUP_SUCCESS:
      case UPDATE_GROUP_SETTINGS_SUCCESS:
      case DELETE_GROUP_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_GROUP_ERROR:
      case UPDATE_GROUP_ERROR:
      case UPDATE_GROUP_SETTINGS_ERROR:
      case DELETE_GROUP_ERROR:
        draft.isCommitting = false;
        break;

      case GROUP_LIST_UNMOUNT:
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
