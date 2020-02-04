/*
 *
 * Archive actions
 *
 */


import {
  GET_ARCHIVES_BEGIN,
  GET_ARCHIVES_SUCCESS,
  GET_ARCHIVES_ERROR,
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
