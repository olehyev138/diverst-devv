/*
 *
 * Group actions
 *
 */

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
  CARRY_BUDGET_BEGIN,
  CARRY_BUDGET_SUCCESS,
  CARRY_BUDGET_ERROR,
  RESET_BUDGET_BEGIN,
  RESET_BUDGET_SUCCESS,
  RESET_BUDGET_ERROR,
  GROUP_LIST_UNMOUNT,
  GROUP_FORM_UNMOUNT,
} from './constants';

export function getGroupsBegin(payload) {
  return {
    type: GET_GROUPS_BEGIN,
    payload,
  };
}

export function getGroupsSuccess(payload) {
  return {
    type: GET_GROUPS_SUCCESS,
    payload,
  };
}

export function getGroupsError(error) {
  return {
    type: GET_GROUPS_ERROR,
    error,
  };
}

export function getAnnualBudgetsBegin(payload) {
  return {
    type: GET_ANNUAL_BUDGETS_BEGIN,
    payload,
  };
}

export function getAnnualBudgetsSuccess(payload) {
  return {
    type: GET_ANNUAL_BUDGETS_SUCCESS,
    payload,
  };
}

export function getAnnualBudgetsError(error) {
  return {
    type: GET_ANNUAL_BUDGETS_ERROR,
    error,
  };
}

export function getGroupBegin(payload) {
  return {
    type: GET_GROUP_BEGIN,
    payload,
  };
}

export function getGroupSuccess(payload) {
  return {
    type: GET_GROUP_SUCCESS,
    payload,
  };
}

export function getGroupError(error) {
  return {
    type: GET_GROUP_ERROR,
    error,
  };
}

export function createGroupBegin(payload) {
  return {
    type: CREATE_GROUP_BEGIN,
    payload,
  };
}

export function createGroupSuccess(payload) {
  return {
    type: CREATE_GROUP_SUCCESS,
    payload,
  };
}

export function createGroupError(error) {
  return {
    type: CREATE_GROUP_ERROR,
    error,
  };
}

export function updateGroupBegin(payload) {
  return {
    type: UPDATE_GROUP_BEGIN,
    payload,
  };
}

export function updateGroupSuccess(payload) {
  return {
    type: UPDATE_GROUP_SUCCESS,
    payload,
  };
}

export function updateGroupError(error) {
  return {
    type: UPDATE_GROUP_ERROR,
    error,
  };
}

export function updateGroupSettingsBegin(payload) {
  return {
    type: UPDATE_GROUP_SETTINGS_BEGIN,
    payload,
  };
}

export function updateGroupSettingsSuccess(payload) {
  return {
    type: UPDATE_GROUP_SETTINGS_SUCCESS,
    payload,
  };
}

export function updateGroupSettingsError(error) {
  return {
    type: UPDATE_GROUP_SETTINGS_ERROR,
    error,
  };
}

export function deleteGroupBegin(payload) {
  return {
    type: DELETE_GROUP_BEGIN,
    payload,
  };
}

export function deleteGroupSuccess(payload) {
  return {
    type: DELETE_GROUP_SUCCESS,
    payload,
  };
}

export function deleteGroupError(error) {
  return {
    type: DELETE_GROUP_ERROR,
    error,
  };
}

export function carryBudgetBegin(payload) {
  return {
    type: CARRY_BUDGET_BEGIN,
    payload,
  };
}

export function carryBudgetSuccess(payload) {
  return {
    type: CARRY_BUDGET_SUCCESS,
    payload,
  };
}

export function carryBudgetError(error) {
  return {
    type: CARRY_BUDGET_ERROR,
    error,
  };
}

export function resetBudgetBegin(payload) {
  return {
    type: RESET_BUDGET_BEGIN,
    payload,
  };
}

export function resetBudgetSuccess(payload) {
  return {
    type: RESET_BUDGET_SUCCESS,
    payload,
  };
}

export function resetBudgetError(error) {
  return {
    type: RESET_BUDGET_ERROR,
    error,
  };
}

export function groupListUnmount(payload) {
  return {
    type: GROUP_LIST_UNMOUNT,
    payload,
  };
}

export function groupFormUnmount(payload) {
  return {
    type: GROUP_FORM_UNMOUNT,
    payload,
  };
}