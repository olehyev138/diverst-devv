/*
 *
 * News actions
 *
 */

import {
  GET_NEWS_ITEMS_BEGIN, GET_NEWS_ITEMS_SUCCESS, GET_NEWS_ITEMS_ERROR,
  GET_NEWS_ITEM_BEGIN, GET_NEWS_ITEM_SUCCESS, GET_NEWS_ITEM_ERROR,
  CREATE_GROUP_MESSAGE_BEGIN, CREATE_GROUP_MESSAGE_SUCCESS, CREATE_GROUP_MESSAGE_ERROR,
  UPDATE_GROUP_MESSAGE_BEGIN, UPDATE_GROUP_MESSAGE_SUCCESS, UPDATE_GROUP_MESSAGE_ERROR,
  DELETE_GROUP_MESSAGE_BEGIN, DELETE_GROUP_MESSAGE_SUCCESS, DELETE_GROUP_MESSAGE_ERROR,
  CREATE_GROUP_MESSAGE_COMMENT_BEGIN, CREATE_GROUP_MESSAGE_COMMENT_SUCCESS, CREATE_GROUP_MESSAGE_COMMENT_ERROR,
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

/* Getting specific news item */

export function getNewsItemBegin(payload) {
  return {
    type: GET_NEWS_ITEM_BEGIN,
    payload
  };
}

export function getNewsItemSuccess(payload) {
  return {
    type: GET_NEWS_ITEM_SUCCESS,
    payload
  };
}

export function getNewsItemError(error) {
  return {
    type: GET_NEWS_ITEM_ERROR,
    error,
  };
}

/* Group Message creating */

export function createGroupMessageBegin(payload) {
  return {
    type: CREATE_GROUP_MESSAGE_BEGIN,
    payload,
  };
}

export function createGroupMessageSuccess(payload) {
  return {
    type: CREATE_GROUP_MESSAGE_SUCCESS,
    payload,
  };
}

export function createGroupMessageError(error) {
  return {
    type: CREATE_GROUP_MESSAGE_ERROR,
    error,
  };
}

/* Group Message updating */

export function updateGroupMessageBegin(payload) {
  return {
    type: UPDATE_GROUP_MESSAGE_BEGIN,
    payload,
  };
}

export function updateGroupMessageSuccess(payload) {
  return {
    type: UPDATE_GROUP_MESSAGE_SUCCESS,
    payload,
  };
}

export function updateGroupMessageError(error) {
  return {
    type: UPDATE_GROUP_MESSAGE_ERROR,
    error,
  };
}

/* Group Message deleting */

export function deleteGroupMessageBegin(payload) {
  return {
    type: DELETE_GROUP_MESSAGE_BEGIN,
    payload,
  };
}

export function deleteGroupMessageSuccess(payload) {
  return {
    type: DELETE_GROUP_MESSAGE_SUCCESS,
    payload,
  };
}

export function deleteGroupMessageError(error) {
  return {
    type: DELETE_GROUP_MESSAGE_ERROR,
    error,
  };
}

/* Group Message comments */

export function createGroupMessageCommentBegin(payload) {
  return {
    type: CREATE_GROUP_MESSAGE_COMMENT_BEGIN,
    payload,
  };
}

export function createGroupMessageCommentSuccess(payload) {
  return {
    type: CREATE_GROUP_MESSAGE_COMMENT_SUCCESS,
    payload,
  };
}

export function createGroupMessageCommentError(error) {
  return {
    type: CREATE_GROUP_MESSAGE_COMMENT_ERROR,
    error,
  };
}

export function newsFeedUnmount() {
  return {
    type: NEWS_FEED_UNMOUNT,
  };
}
