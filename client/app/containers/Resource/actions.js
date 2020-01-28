/*
 *
 * Resource actions
 *
 */

import {
  GET_FOLDERS_BEGIN,
  GET_FOLDERS_SUCCESS,
  GET_FOLDERS_ERROR,
  CREATE_FOLDER_BEGIN,
  CREATE_FOLDER_SUCCESS,
  CREATE_FOLDER_ERROR,
  DELETE_FOLDER_BEGIN,
  DELETE_FOLDER_SUCCESS,
  DELETE_FOLDER_ERROR,
  VALIDATE_FOLDER_PASSWORD_BEGIN,
  VALIDATE_FOLDER_PASSWORD_SUCCESS,
  VALIDATE_FOLDER_PASSWORD_ERROR,
  GET_FOLDER_BEGIN,
  GET_FOLDER_SUCCESS,
  GET_FOLDER_ERROR,
  UPDATE_FOLDER_BEGIN,
  UPDATE_FOLDER_SUCCESS,
  UPDATE_FOLDER_ERROR,
  FOLDERS_UNMOUNT,
  GET_RESOURCES_BEGIN,
  GET_RESOURCES_SUCCESS,
  GET_RESOURCES_ERROR,
  CREATE_RESOURCE_BEGIN,
  CREATE_RESOURCE_SUCCESS,
  CREATE_RESOURCE_ERROR,
  DELETE_RESOURCE_BEGIN,
  DELETE_RESOURCE_SUCCESS,
  DELETE_RESOURCE_ERROR,
  GET_RESOURCE_BEGIN,
  GET_RESOURCE_SUCCESS,
  GET_RESOURCE_ERROR,
  UPDATE_RESOURCE_BEGIN,
  UPDATE_RESOURCE_SUCCESS,
  UPDATE_RESOURCE_ERROR,
  RESOURCES_UNMOUNT,
  ARCHIVE_RESOURCE_SUCCESS,
  ARCHIVE_RESOURCE_ERROR,
  ARCHIVE_RESOURCE_BEGIN,
} from './constants';

export function getFoldersBegin(payload) {
  return {
    type: GET_FOLDERS_BEGIN,
    payload
  };
}

export function getFoldersSuccess(payload) {
  return {
    type: GET_FOLDERS_SUCCESS,
    payload
  };
}

export function getFoldersError(error) {
  return {
    type: GET_FOLDERS_ERROR,
    error
  };
}

/* Getting specific folder */

export function getFolderBegin(payload) {
  return {
    type: GET_FOLDER_BEGIN,
    payload
  };
}

export function getFolderSuccess(payload) {
  return {
    type: GET_FOLDER_SUCCESS,
    payload
  };
}

export function getFolderError(error) {
  return {
    type: GET_FOLDER_ERROR,
    error,
  };
}

/* Folder creating */

export function createFolderBegin(payload) {
  return {
    type: CREATE_FOLDER_BEGIN,
    payload,
  };
}

export function createFolderSuccess(payload) {
  return {
    type: CREATE_FOLDER_SUCCESS,
    payload,
  };
}

export function createFolderError(error) {
  return {
    type: CREATE_FOLDER_ERROR,
    error,
  };
}

/* Folder updating */

export function updateFolderBegin(payload) {
  return {
    type: UPDATE_FOLDER_BEGIN,
    payload,
  };
}

export function updateFolderSuccess(payload) {
  return {
    type: UPDATE_FOLDER_SUCCESS,
    payload,
  };
}

export function updateFolderError(error) {
  return {
    type: UPDATE_FOLDER_ERROR,
    error,
  };
}

/* Folder deleting */

export function deleteFolderBegin(payload) {
  return {
    type: DELETE_FOLDER_BEGIN,
    payload,
  };
}

export function deleteFolderSuccess(payload) {
  return {
    type: DELETE_FOLDER_SUCCESS,
    payload,
  };
}

export function deleteFolderError(error) {
  return {
    type: DELETE_FOLDER_ERROR,
    error,
  };
}

export function validateFolderPasswordBegin(payload) {
  return {
    type: VALIDATE_FOLDER_PASSWORD_BEGIN,
    payload,
  };
}

export function validateFolderPasswordSuccess(payload) {
  return {
    type: VALIDATE_FOLDER_PASSWORD_SUCCESS,
    payload,
  };
}

export function validateFolderPasswordError(error) {
  return {
    type: VALIDATE_FOLDER_PASSWORD_ERROR,
    error,
  };
}

export function foldersUnmount() {
  return {
    type: FOLDERS_UNMOUNT,
  };
}

export function getResourcesBegin(payload) {
  return {
    type: GET_RESOURCES_BEGIN,
    payload
  };
}

export function getResourcesSuccess(payload) {
  return {
    type: GET_RESOURCES_SUCCESS,
    payload
  };
}

export function getResourcesError(error) {
  return {
    type: GET_RESOURCES_ERROR,
    error
  };
}

/* Getting specific resource */

export function getResourceBegin(payload) {
  return {
    type: GET_RESOURCE_BEGIN,
    payload
  };
}

export function getResourceSuccess(payload) {
  return {
    type: GET_RESOURCE_SUCCESS,
    payload
  };
}

export function getResourceError(error) {
  return {
    type: GET_RESOURCE_ERROR,
    error,
  };
}

/* Resource creating */

export function createResourceBegin(payload) {
  return {
    type: CREATE_RESOURCE_BEGIN,
    payload,
  };
}

export function createResourceSuccess(payload) {
  return {
    type: CREATE_RESOURCE_SUCCESS,
    payload,
  };
}

export function createResourceError(error) {
  return {
    type: CREATE_RESOURCE_ERROR,
    error,
  };
}

/* Resource updating */

export function updateResourceBegin(payload) {
  return {
    type: UPDATE_RESOURCE_BEGIN,
    payload,
  };
}

export function updateResourceSuccess(payload) {
  return {
    type: UPDATE_RESOURCE_SUCCESS,
    payload,
  };
}

export function updateResourceError(error) {
  return {
    type: UPDATE_RESOURCE_ERROR,
    error,
  };
}

/* Resource deleting */

export function deleteResourceBegin(payload) {
  return {
    type: DELETE_RESOURCE_BEGIN,
    payload,
  };
}

export function deleteResourceSuccess(payload) {
  return {
    type: DELETE_RESOURCE_SUCCESS,
    payload,
  };
}

export function deleteResourceError(error) {
  return {
    type: DELETE_RESOURCE_ERROR,
    error,
  };
}

export function resourcesUnmount() {
  return {
    type: RESOURCES_UNMOUNT,
  };
}

export function archiveResourceBegin(payload){
  return {
    type: ARCHIVE_RESOURCE_BEGIN,
    payload,
  };
}

export function archiveResourceSuccess(payload){
  return {
    type: ARCHIVE_RESOURCE_SUCCESS,
    payload,
  };
}

export function archiveResourceError(error){
  return {
    type: ARCHIVE_RESOURCE_ERROR,
    error,
  };
}
