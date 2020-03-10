/*
 *
 * Group Member actions
 *
 */

import {
  GET_MEMBERS_BEGIN, GET_MEMBERS_SUCCESS, GET_MEMBERS_ERROR,
  CREATE_MEMBERS_BEGIN, CREATE_MEMBERS_SUCCESS, CREATE_MEMBERS_ERROR,
  UPDATE_MEMBER_BEGIN, UPDATE_MEMBER_SUCCESS, UPDATE_MEMBER_ERROR,
  DELETE_MEMBER_BEGIN, DELETE_MEMBER_SUCCESS, DELETE_MEMBER_ERROR,
  EXPORT_MEMBERS_BEGIN, EXPORT_MEMBERS_ERROR, EXPORT_MEMBERS_SUCCESS,
  GROUP_MEMBERS_UNMOUNT
} from 'containers/Group/GroupMembers/constants';

/* Member listing */

export function getMembersBegin(payload) {
  return {
    type: GET_MEMBERS_BEGIN,
    payload
  };
}

export function getMembersSuccess(payload) {
  return {
    type: GET_MEMBERS_SUCCESS,
    payload
  };
}

export function getMembersError(error) {
  return {
    type: GET_MEMBERS_ERROR,
    error,
  };
}

/* Group creating */

export function createMembersBegin(payload) {
  return {
    type: CREATE_MEMBERS_BEGIN,
    payload,
  };
}

export function createMembersSuccess(payload) {
  return {
    type: CREATE_MEMBERS_SUCCESS,
    payload,
  };
}

export function createMembersError(error) {
  return {
    type: CREATE_MEMBERS_ERROR,
    error,
  };
}

/* Member updating */

export function updateMemberBegin(payload) {
  return {
    type: UPDATE_MEMBER_BEGIN,
    payload,
  };
}

export function updateMemberSuccess(payload) {
  return {
    type: UPDATE_MEMBER_SUCCESS,
    payload,
  };
}

export function updateMemberError(error) {
  return {
    type: UPDATE_MEMBER_ERROR,
    error,
  };
}

/* Member deleting */

export function deleteMemberBegin(payload) {
  return {
    type: DELETE_MEMBER_BEGIN,
    payload,
  };
}

export function deleteMemberSuccess(payload) {
  return {
    type: DELETE_MEMBER_SUCCESS,
    payload,
  };
}

export function deleteMemberError(error) {
  return {
    type: DELETE_MEMBER_ERROR,
    error,
  };
}

export function exportMembersBegin(payload) {
  return {
    type: EXPORT_MEMBERS_BEGIN,
    payload,
  };
}

export function exportMembersSuccess(payload) {
  return {
    type: EXPORT_MEMBERS_SUCCESS,
    payload,
  };
}

export function exportMembersError(error) {
  return {
    type: EXPORT_MEMBERS_ERROR,
    error,
  };
}

export function groupMembersUnmount() {
  return {
    type: GROUP_MEMBERS_UNMOUNT
  };
}
