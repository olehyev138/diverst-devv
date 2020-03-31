/*
 *
 * News actions
 *
 */

import {
  LIKE_NEWS_ITEM_BEGIN, LIKE_NEWS_ITEM_SUCCESS, LIKE_NEWS_ITEM_ERROR,
  UNLIKE_NEWS_ITEM_BEGIN, UNLIKE_NEWS_ITEM_SUCCESS, UNLIKE_NEWS_ITEM_ERROR
} from 'containers/Shared/Like/constants';

export function likeNewsItemBegin(payload) {
  return {
    type: LIKE_NEWS_ITEM_BEGIN,
    payload
  };
}

export function likeNewsItemSuccess(payload) {
  return {
    type: LIKE_NEWS_ITEM_SUCCESS,
    payload
  };
}

export function likeNewsItemError(error) {
  return {
    type: LIKE_NEWS_ITEM_ERROR,
    error,
  };
}

export function unlikeNewsItemBegin(payload) {
  return {
    type: UNLIKE_NEWS_ITEM_BEGIN,
    payload
  };
}

export function unlikeNewsItemSuccess(payload) {
  return {
    type: UNLIKE_NEWS_ITEM_SUCCESS,
    payload
  };
}

export function unlikeNewsItemError(error) {
  return {
    type: UNLIKE_NEWS_ITEM_ERROR,
    error,
  };
}
