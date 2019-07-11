/*
 *
 * News actions
 *
 */

import {
  GET_NEWS_BEGIN, GET_NEWS_SUCCESS, GET_NEWS_ERROR
} from 'containers/News/constants';

/* Group listing */

export function getNewsBegin(payload) {
  return {
    type: GET_NEWS_BEGIN,
    payload
  };
}

export function getNewsSuccess(payload) {
  return {
    type: GET_NEWS_SUCCESS,
    payload
  };
}

export function getNewsError(error) {
  return {
    type: GET_NEWS_ERROR,
    error,
  };
}
