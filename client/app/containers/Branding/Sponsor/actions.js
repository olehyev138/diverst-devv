/*
 *
 * Sponsor actions
 *
 */

import {
  GET_SPONSORS_BEGIN, GET_SPONSORS_SUCCESS, GET_SPONSORS_ERROR,
  GET_SPONSOR_BEGIN, GET_SPONSOR_SUCCESS, GET_SPONSOR_ERROR,
  CREATE_SPONSOR_BEGIN, CREATE_SPONSOR_SUCCESS, CREATE_SPONSOR_ERROR,
  UPDATE_SPONSOR_BEGIN, UPDATE_SPONSOR_SUCCESS, UPDATE_SPONSOR_ERROR,
  DELETE_SPONSOR_BEGIN, DELETE_SPONSOR_SUCCESS, DELETE_SPONSOR_ERROR,
  SPONSORS_UNMOUNT
} from 'containers/Branding/Sponsor/constants';
import { CREATE_GROUP_SPONSOR_BEGIN, UPDATE_GROUP_SPONSOR_BEGIN } from '../../Group/GroupManage/GroupSponsors/constants';

/* Sponsor listing */

export function getSponsorsBegin(payload) {
  return {
    type: GET_SPONSORS_BEGIN,
    payload
  };
}

export function getSponsorsSuccess(payload) {
  return {
    type: GET_SPONSORS_SUCCESS,
    payload
  };
}

export function getSponsorsError(error) {
  return {
    type: GET_SPONSORS_ERROR,
    error,
  };
}

/* Sponsor Getting */

export function getSponsorBegin(payload) {
  return {
    type: GET_SPONSOR_BEGIN,
    payload
  };
}

export function getSponsorSuccess(payload) {
  return {
    type: GET_SPONSOR_SUCCESS,
    payload
  };
}

export function getSponsorError(error) {
  return {
    type: GET_SPONSOR_ERROR,
    error,
  };
}

/* Sponsor creating */

export function createSponsorBegin(payload) {
  return {
    type: CREATE_SPONSOR_BEGIN,
    payload,
  };
}

export function createGroupSponsorBegin(payload) {
  return {
    type: CREATE_GROUP_SPONSOR_BEGIN,
    payload,
  };
}

export function createSponsorSuccess(payload) {
  return {
    type: CREATE_SPONSOR_SUCCESS,
    payload,
  };
}

export function createSponsorError(error) {
  return {
    type: CREATE_SPONSOR_ERROR,
    error,
  };
}

/* Sponsor updating */

export function updateSponsorBegin(payload) {
  return {
    type: UPDATE_SPONSOR_BEGIN,
    payload,
  };
}

export function updateGroupSponsorBegin(payload) {
  return {
    type: UPDATE_GROUP_SPONSOR_BEGIN,
    payload,
  };
}

export function updateSponsorSuccess(payload) {
  return {
    type: UPDATE_SPONSOR_SUCCESS,
    payload,
  };
}

export function updateSponsorError(error) {
  return {
    type: UPDATE_SPONSOR_ERROR,
    error,
  };
}

/* Sponsor deleting */

export function deleteSponsorBegin(payload) {
  return {
    type: DELETE_SPONSOR_BEGIN,
    payload,
  };
}

export function deleteSponsorSuccess(payload) {
  return {
    type: DELETE_SPONSOR_SUCCESS,
    payload,
  };
}

export function deleteSponsorError(error) {
  return {
    type: DELETE_SPONSOR_ERROR,
    error,
  };
}

export function sponsorsUnmount() {
  return {
    type: SPONSORS_UNMOUNT
  };
}
