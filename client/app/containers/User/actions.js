/*
 *
 * User actions
 *
 */

import {
  GET_USERS_BEGIN,
  GET_USERS_SUCCESS,
  GET_USERS_ERROR,
  GET_USER_BEGIN,
  GET_USER_SUCCESS,
  GET_USER_ERROR,
  GET_USER_POSTS_BEGIN,
  GET_USER_POSTS_SUCCESS,
  GET_USER_POSTS_ERROR,
  GET_USER_EVENTS_BEGIN,
  GET_USER_EVENTS_SUCCESS,
  GET_USER_EVENTS_ERROR,
  GET_USER_DOWNLOADS_BEGIN,
  GET_USER_DOWNLOADS_SUCCESS,
  GET_USER_DOWNLOADS_ERROR,
  CREATE_USER_BEGIN,
  CREATE_USER_SUCCESS,
  CREATE_USER_ERROR,
  UPDATE_USER_BEGIN,
  UPDATE_USER_SUCCESS,
  UPDATE_USER_ERROR,
  DELETE_USER_BEGIN,
  DELETE_USER_SUCCESS,
  DELETE_USER_ERROR,
  UPDATE_FIELD_DATA_BEGIN,
  UPDATE_FIELD_DATA_SUCCESS,
  UPDATE_FIELD_DATA_ERROR,
  EXPORT_USERS_BEGIN,
  EXPORT_USERS_SUCCESS,
  EXPORT_USERS_ERROR,
  GET_USER_DOWNLOAD_DATA_BEGIN,
  GET_USER_DOWNLOAD_DATA_SUCCESS,
  GET_USER_DOWNLOAD_DATA_ERROR,
  GET_USER_PROTOTYPE_BEGIN,
  GET_USER_PROTOTYPE_SUCCESS,
  GET_USER_PROTOTYPE_ERROR,
  USER_UNMOUNT,
} from './constants';

export function getUsersBegin(payload) {
  return {
    type: GET_USERS_BEGIN,
    payload,
  };
}

export function getUsersSuccess(payload) {
  return {
    type: GET_USERS_SUCCESS,
    payload,
  };
}

export function getUsersError(error) {
  return {
    type: GET_USERS_ERROR,
    error,
  };
}

/* Getting specific user */

export function getUserBegin(payload) {
  return {
    type: GET_USER_BEGIN,
    payload,
  };
}

export function getUserSuccess(payload) {
  return {
    type: GET_USER_SUCCESS,
    payload,
  };
}

export function getUserError(error) {
  return {
    type: GET_USER_ERROR,
    error,
  };
}

export function getUserPostsBegin(payload) {
  return {
    type: GET_USER_POSTS_BEGIN,
    payload,
  };
}

export function getUserPostsSuccess(payload) {
  return {
    type: GET_USER_POSTS_SUCCESS,
    payload,
  };
}

export function getUserPostsError(error) {
  return {
    type: GET_USER_POSTS_ERROR,
    error,
  };
}

export function getUserEventsBegin(payload) {
  return {
    type: GET_USER_EVENTS_BEGIN,
    payload,
  };
}

export function getUserEventsSuccess(payload) {
  return {
    type: GET_USER_EVENTS_SUCCESS,
    payload,
  };
}

export function getUserEventsError(error) {
  return {
    type: GET_USER_EVENTS_ERROR,
    error,
  };
}

export function getUserDownloadsBegin(payload) {
  return {
    type: GET_USER_DOWNLOADS_BEGIN,
    payload,
  };
}

export function getUserDownloadsSuccess(payload) {
  return {
    type: GET_USER_DOWNLOADS_SUCCESS,
    payload,
  };
}

export function getUserDownloadsError(error) {
  return {
    type: GET_USER_DOWNLOADS_ERROR,
    error,
  };
}

/* User creating */

export function createUserBegin(payload) {
  return {
    type: CREATE_USER_BEGIN,
    payload,
  };
}

export function createUserSuccess(payload) {
  return {
    type: CREATE_USER_SUCCESS,
    payload,
  };
}

export function createUserError(error) {
  return {
    type: CREATE_USER_ERROR,
    error,
  };
}

/* User updating */

export function updateUserBegin(payload) {
  return {
    type: UPDATE_USER_BEGIN,
    payload,
  };
}

export function updateUserSuccess(payload) {
  return {
    type: UPDATE_USER_SUCCESS,
    payload,
  };
}

export function updateUserError(error) {
  return {
    type: UPDATE_USER_ERROR,
    error,
  };
}

/* User deleting */

export function deleteUserBegin(payload) {
  return {
    type: DELETE_USER_BEGIN,
    payload,
  };
}

export function deleteUserSuccess(payload) {
  return {
    type: DELETE_USER_SUCCESS,
    payload,
  };
}

export function deleteUserError(error) {
  return {
    type: DELETE_USER_ERROR,
    error,
  };
}

/* Field Data updating */

export function updateFieldDataBegin(payload) {
  return {
    type: UPDATE_FIELD_DATA_BEGIN,
    payload,
  };
}

export function updateFieldDataSuccess(payload) {
  return {
    type: UPDATE_FIELD_DATA_SUCCESS,
    payload,
  };
}

export function updateFieldDataError(error) {
  return {
    type: UPDATE_FIELD_DATA_ERROR,
    error,
  };
}

export function exportUsersBegin(payload) {
  return {
    type: EXPORT_USERS_BEGIN,
    payload,
  };
}

export function exportUsersSuccess(payload) {
  return {
    type: EXPORT_USERS_SUCCESS,
    payload,
  };
}

export function exportUsersError(error) {
  return {
    type: EXPORT_USERS_ERROR,
    error,
  };
}

export function getUserDownloadDataBegin(payload) {
  return {
    type: GET_USER_DOWNLOAD_DATA_BEGIN,
    payload,
  };
}

export function getUserDownloadDataSuccess(payload) {
  return {
    type: GET_USER_DOWNLOAD_DATA_SUCCESS,
    payload,
  };
}

export function getUserDownloadDataError(error) {
  return {
    type: GET_USER_DOWNLOAD_DATA_ERROR,
    error,
  };
}

export function getUserPrototypeBegin(payload) {
  return {
    type: GET_USER_PROTOTYPE_BEGIN,
    payload,
  };
}

export function getUserPrototypeSuccess(payload) {
  return {
    type: GET_USER_PROTOTYPE_SUCCESS,
    payload,
  };
}

export function getUserPrototypeError(error) {
  return {
    type: GET_USER_PROTOTYPE_ERROR,
    error,
  };
}

export function userUnmount() {
  return {
    type: USER_UNMOUNT
  };
}
