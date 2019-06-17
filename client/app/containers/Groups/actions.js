/*
 *
 * Groups actions
 *
 */

import { GET_GROUPS_BEGIN, GET_GROUPS_SUCCESS, GET_GROUPS_ERROR } from 'containers/Groups/constants';

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
