/*
 *
 * Csvfile actions
 *
 */

import {
  CREATE_CSV_FILE_BEGIN,
  CREATE_CSV_FILE_SUCCESS,
  CREATE_CSV_FILE_ERROR,
  CSV_FILES_UNMOUNT,
} from './constants';

export function createCsvFileBegin(payload) {
  return {
    type: CREATE_CSV_FILE_BEGIN,
    payload,
  };
}

export function createCsvFileSuccess(payload) {
  return {
    type: CREATE_CSV_FILE_SUCCESS,
    payload,
  };
}

export function createCsvFileError(error) {
  return {
    type: CREATE_CSV_FILE_ERROR,
    error,
  };
}

export function csvFilesUnmount(payload) {
  return {
    type: CSV_FILES_UNMOUNT,
    payload,
  };
}
