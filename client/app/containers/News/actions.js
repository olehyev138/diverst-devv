/*
 *
 * News actions
 *
 */

import {
  GET_NEWS_ITEMS_BEGIN, GET_NEWS_ITEMS_SUCCESS, GET_NEWS_ITEMS_ERROR,
  NEWS_FEED_UNMOUNT
} from 'containers/News/constants';

export function getNewsItemsBegin(payload) {
  return {
    type: GET_NEWS_ITEMS_BEGIN,
    payload
  };
}

export function getNewsItemsSuccess(payload) {
  return {
    type: GET_NEWS_ITEMS_SUCCESS,
    payload
  };
}

export function getNewsItemsError(error) {
  return {
    type: GET_NEWS_ITEMS_ERROR,
    error,
  };
}

export function newsFeedUnmount() {
  return {
    type: NEWS_FEED_UNMOUNT,
  };
}
