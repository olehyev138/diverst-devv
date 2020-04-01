/*
 *
 * Log actions
 *
 */

import {
  GET_LOGS_BEGIN,
  GET_LOGS_SUCCESS,
  GET_LOGS_ERROR,
  LOG_UNMOUNT,
} from 'containers/Log/constants';

/* Log listing */

export function getLogsBegin(payload) {
  return {
    type: GET_LOGS_BEGIN,
    payload
  };
}

export function getLogsSuccess(payload) {
  return {
    type: GET_LOGS_SUCCESS,
    payload
  };
}

export function getLogsError(error) {
  return {
    type: GET_LOGS_ERROR,
    error,
  };
}

export function logUnmount() {
  return {
    type: LOG_UNMOUNT
  };
}
