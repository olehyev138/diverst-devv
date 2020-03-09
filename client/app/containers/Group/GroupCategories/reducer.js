/*
 *
 * Group Categories reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_GROUP_CATEGORIES_BEGIN, GET_GROUP_CATEGORIES_SUCCESS, GET_GROUP_CATEGORIES_ERROR,
  CREATE_GROUP_CATEGORIES_BEGIN, CREATE_GROUP_CATEGORIES_SUCCESS, CREATE_GROUP_CATEGORIES_ERROR,
  UPDATE_GROUP_CATEGORIES_BEGIN, UPDATE_GROUP_CATEGORIES_SUCCESS, UPDATE_GROUP_CATEGORIES_ERROR,
  ADD_GROUP_CATEGORIES_BEGIN, ADD_GROUP_CATEGORIES_SUCCESS, ADD_GROUP_CATEGORIES_ERROR,
  DELETE_GROUP_CATEGORIES_BEGIN, DELETE_GROUP_CATEGORIES_SUCCESS, DELETE_GROUP_CATEGORIES_ERROR,
  UPDATE_GROUP_CATEGORY_TYPE_BEGIN, UPDATE_GROUP_CATEGORY_TYPE_SUCCESS, UPDATE_GROUP_CATEGORY_TYPE_ERROR,
} from 'containers/Group/GroupCategories/constants';

export const initialState = {
  isLoading: true,
  isFormLoading: true,
  isCommitting: false,
  groupCategoriesList: {},
  groupTotal: null,
  currentGroup: null,
};

/* eslint-disable default-case, no-param-reassign */
function groupCategoriesReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      /*
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
      */
      case GET_GROUP_CATEGORIES_BEGIN:
        draft.isLoading = true;
        break;
      case GET_GROUP_CATEGORIES_SUCCESS:
        draft.groupCategoriesList = formatGroupCategories(action.payload.items);
        draft.groupCategoriesTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_GROUP_CATEGORIES_ERROR:
        draft.isLoading = false;
        break;
      case CREATE_GROUP_CATEGORIES_BEGIN:
      case CREATE_GROUP_CATEGORIES_SUCCESS:
      case CREATE_GROUP_CATEGORIES_ERROR:
      /*
      case UPDATE_GROUP_BEGIN:
      case UPDATE_GROUP_SETTINGS_BEGIN:
        draft.isCommitting = true;
        break;
      case UPDATE_GROUP_SETTINGS_SUCCESS:
        draft.currentGroup = action.payload.group;
        draft.isCommitting = false;
        break;
      case UPDATE_GROUP_SUCCESS:
      case UPDATE_GROUP_ERROR:
      case UPDATE_GROUP_SETTINGS_ERROR:
        draft.isCommitting = false;
        break;
      case GROUP_LIST_UNMOUNT:
        return initialState;
      case GROUP_FORM_UNMOUNT:
        return initialState;
        */
    }
  });
}

/* Helpers */

function formatGroupCategories(categories) {
  /* eslint-disable no-return-assign */

  /* Format groups to hash by id:
   *   { <id>: { name: group_01, ... } }
   */
  return categories.reduce((map, category) => {
    map[category.id] = category;
    return map;
  }, {});
}

export default groupCategoriesReducer;
