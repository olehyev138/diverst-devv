/*
 *
 * Group categories actions
 *
 */

import {
  GET_GROUP_CATEGORIES_BEGIN, GET_GROUP_CATEGORIES_SUCCESS, GET_GROUP_CATEGORIES_ERROR,
  CREATE_GROUP_CATEGORIES_BEGIN, CREATE_GROUP_CATEGORIES_SUCCESS, CREATE_GROUP_CATEGORIES_ERROR,
  UPDATE_GROUP_CATEGORIES_BEGIN, UPDATE_GROUP_CATEGORIES_SUCCESS, UPDATE_GROUP_CATEGORIES_ERROR,
  ADD_GROUP_CATEGORIES_BEGIN, ADD_GROUP_CATEGORIES_SUCCESS, ADD_GROUP_CATEGORIES_ERROR,
  DELETE_GROUP_CATEGORIES_BEGIN, DELETE_GROUP_CATEGORIES_SUCCESS, DELETE_GROUP_CATEGORIES_ERROR,
  UPDATE_GROUP_CATEGORY_TYPE_BEGIN, UPDATE_GROUP_CATEGORY_TYPE_SUCCESS, UPDATE_GROUP_CATEGORY_TYPE_ERROR,
} from 'containers/Group/GroupCategories/constants';
import {CATEGORIES_UNMOUNT} from "./constants";

/* Group categories listing */

export function getGroupCategoriesBegin(payload) {
  return {
    type: GET_GROUP_CATEGORIES_BEGIN,
    payload
  };
}

export function getGroupCategoriesSuccess(payload) {
  return {
    type: GET_GROUP_CATEGORIES_SUCCESS,
    payload
  };
}

export function getGroupCategoriesError(error) {
  return {
    type: GET_GROUP_CATEGORIES_ERROR,
    error,
  };
}

export function createGroupCategoriesBegin(payload) {
  return {
    type: CREATE_GROUP_CATEGORIES_BEGIN,
    payload
  };
}

export function createGroupCategoriesSuccess(payload) {
  return {
    type: CREATE_GROUP_CATEGORIES_SUCCESS,
    payload
  };
}

export function createGroupCategoriesError(error) {
  return {
    type: CREATE_GROUP_CATEGORIES_ERROR,
    error,
  };
}
export function updateGroupCategoriesBegin(payload) {
  return {
    type: UPDATE_GROUP_CATEGORIES_BEGIN,
    payload
  };
}

export function updateGroupCategoriesSuccess(payload) {
  return {
    type: UPDATE_GROUP_CATEGORIES_SUCCESS,
    payload
  };
}

export function updateGroupCategoriesError(error) {
  return {
    type: UPDATE_GROUP_CATEGORIES_ERROR,
    error,
  };
}

export function addGroupCategoriesBegin(payload) {
  return {
    type: ADD_GROUP_CATEGORIES_BEGIN,
    payload
  };
}

export function addGroupCategoriesSuccess(payload) {
  return {
    type: ADD_GROUP_CATEGORIES_SUCCESS,
    payload
  };
}

export function addGroupCategoriesError(error) {
  return {
    type: ADD_GROUP_CATEGORIES_ERROR,
    error,
  };
}

export function deleteGroupCategoriesBegin(payload) {
  return {
    type: DELETE_GROUP_CATEGORIES_BEGIN,
    payload
  };
}

export function deleteGroupCategoriesSuccess(payload) {
  return {
    type: DELETE_GROUP_CATEGORIES_SUCCESS,
    payload
  };
}

export function deleteGroupCategoriesError(error) {
  return {
    type: DELETE_GROUP_CATEGORIES_ERROR,
    error,
  };
}

export function updateGroupCategoryTypeBegin(payload) {
  return {
    type: UPDATE_GROUP_CATEGORY_TYPE_BEGIN,
    payload
  };
}

export function updateGroupCategoryTypeSuccess(payload) {
  return {
    type: UPDATE_GROUP_CATEGORY_TYPE_SUCCESS,
    payload
  };
}

export function updateGroupCategoryTypeError(error) {
  return {
    type: UPDATE_GROUP_CATEGORY_TYPE_ERROR,
    error,
  };
}

export function categoriesUnmount() {
  return {
    type: CATEGORIES_UNMOUNT,
  };
}
