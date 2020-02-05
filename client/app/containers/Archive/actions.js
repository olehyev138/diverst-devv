/*
 *
 * Archive actions
 *
 */


import {
  GET_ARCHIVES_BEGIN,
  GET_ARCHIVES_SUCCESS,
  GET_ARCHIVES_ERROR,
  RESTORE_ARCHIVE_BEGIN,
  RESTORE_ARCHIVE_SUCCESS,
  RESTORE_ARCHIVE_ERROR
} from './constants';

export function getArchivesBegin(payload) {
  return {
    type: GET_ARCHIVES_BEGIN,
    payload
  };
}
export function getArchivesSuccess(payload) {
  return {
    type: GET_ARCHIVES_SUCCESS,
    payload
  };
}
export function getArchivesError(error) {
  return {
    type: GET_ARCHIVES_ERROR,
    error
  };
}

export function restoreArchiveBegin(payload) {
  return {
    type: RESTORE_ARCHIVE_BEGIN,
    payload
  };
}
export function restoreArchiveSuccess(payload){
  return {
    type: RESTORE_ARCHIVE_SUCCESS,
    payload
  };
}
export function restoreArchiveError(error){
  return {
    type: RESTORE_ARCHIVE_ERROR,
    error
  };
}
