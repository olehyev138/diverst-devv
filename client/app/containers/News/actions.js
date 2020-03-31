/*
 *
 * News actions
 *
 */

import {
  GET_NEWS_ITEMS_BEGIN, GET_NEWS_ITEMS_SUCCESS, GET_NEWS_ITEMS_ERROR,
  GET_NEWS_ITEM_BEGIN, GET_NEWS_ITEM_SUCCESS, GET_NEWS_ITEM_ERROR,
  UPDATE_NEWS_ITEM_BEGIN, UPDATE_NEWS_ITEM_SUCCESS, UPDATE_NEWS_ITEM_ERROR,
  CREATE_GROUP_MESSAGE_BEGIN, CREATE_GROUP_MESSAGE_SUCCESS, CREATE_GROUP_MESSAGE_ERROR,
  UPDATE_GROUP_MESSAGE_BEGIN, UPDATE_GROUP_MESSAGE_SUCCESS, UPDATE_GROUP_MESSAGE_ERROR,
  DELETE_GROUP_MESSAGE_BEGIN, DELETE_GROUP_MESSAGE_SUCCESS, DELETE_GROUP_MESSAGE_ERROR,
  CREATE_GROUP_MESSAGE_COMMENT_BEGIN, CREATE_GROUP_MESSAGE_COMMENT_SUCCESS, CREATE_GROUP_MESSAGE_COMMENT_ERROR,
  NEWS_FEED_UNMOUNT, CREATE_NEWSLINK_BEGIN, CREATE_NEWSLINK_SUCCESS, CREATE_NEWSLINK_ERROR, UPDATE_NEWSLINK_BEGIN,
  UPDATE_NEWSLINK_SUCCESS, UPDATE_NEWSLINK_ERROR, DELETE_NEWSLINK_BEGIN, DELETE_NEWSLINK_SUCCESS,
  DELETE_NEWSLINK_ERROR, CREATE_NEWSLINK_COMMENT_BEGIN, CREATE_NEWSLINK_COMMENT_SUCCESS, CREATE_NEWSLINK_COMMENT_ERROR,
  CREATE_SOCIALLINK_BEGIN, CREATE_SOCIALLINK_SUCCESS, CREATE_SOCIALLINK_ERROR, UPDATE_SOCIALLINK_BEGIN,
  UPDATE_SOCIALLINK_SUCCESS, UPDATE_SOCIALLINK_ERROR, CREATE_SOCIALLINK_COMMENT_BEGIN, CREATE_SOCIALLINK_COMMENT_SUCCESS,
  CREATE_SOCIALLINK_COMMENT_ERROR, DELETE_SOCIALLINK_ERROR, DELETE_SOCIALLINK_BEGIN, DELETE_SOCIALLINK_SUCCESS,
  DELETE_NEWSLINK_COMMENT_BEGIN, DELETE_NEWSLINK_COMMENT_ERROR, DELETE_NEWSLINK_COMMENT_SUCCESS, DELETE_GROUP_MESSAGE_COMMENT_BEGIN,
  DELETE_GROUP_MESSAGE_COMMENT_ERROR, DELETE_GROUP_MESSAGE_COMMENT_SUCCESS,
  ARCHIVE_NEWS_ITEM_BEGIN, ARCHIVE_NEWS_ITEM_ERROR, ARCHIVE_NEWS_ITEM_SUCCESS,
  PIN_NEWS_ITEM_BEGIN, PIN_NEWS_ITEM_SUCCESS, PIN_NEWS_ITEM_ERROR,
  UNPIN_NEWS_ITEM_BEGIN, UNPIN_NEWS_ITEM_SUCCESS, UNPIN_NEWS_ITEM_ERROR, } from 'containers/News/constants';

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

export function updateNewsItemBegin(payload) {
  return {
    type: UPDATE_NEWS_ITEM_BEGIN,
    payload
  };
}

export function updateNewsItemSuccess(payload) {
  return {
    type: UPDATE_NEWS_ITEM_SUCCESS,
    payload
  };
}

export function updateNewsItemError(error) {
  return {
    type: UPDATE_NEWS_ITEM_ERROR,
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

export function deleteGroupMessageCommentBegin(payload) {
  return {
    type: DELETE_GROUP_MESSAGE_COMMENT_BEGIN,
    payload,
  };
}

export function deleteGroupMessageCommentSuccess(payload) {
  return {
    type: DELETE_GROUP_MESSAGE_COMMENT_SUCCESS,
    payload,
  };
}

export function deleteGroupMessageCommentError(error) {
  return {
    type: DELETE_GROUP_MESSAGE_COMMENT_ERROR,
    error,
  };
}

export function newsFeedUnmount() {
  return {
    type: NEWS_FEED_UNMOUNT,
  };
}

/* Group Message creating */

export function createNewsLinkBegin(payload) {
  return {
    type: CREATE_NEWSLINK_BEGIN,
    payload,
  };
}

export function createNewsLinkSuccess(payload) {
  return {
    type: CREATE_NEWSLINK_SUCCESS,
    payload,
  };
}

export function createNewsLinkError(error) {
  return {
    type: CREATE_NEWSLINK_ERROR,
    error,
  };
}

/* Group Message updating */

export function updateNewsLinkBegin(payload) {
  return {
    type: UPDATE_NEWSLINK_BEGIN,
    payload,
  };
}

export function updateNewsLinkSuccess(payload) {
  return {
    type: UPDATE_NEWSLINK_SUCCESS,
    payload,
  };
}

export function updateNewsLinkError(error) {
  return {
    type: UPDATE_NEWSLINK_ERROR,
    error,
  };
}

/* News Link deleting */

export function deleteNewsLinkBegin(payload) {
  return {
    type: DELETE_NEWSLINK_BEGIN,
    payload,
  };
}

export function deleteNewsLinkSuccess(payload) {
  return {
    type: DELETE_NEWSLINK_SUCCESS,
    payload,
  };
}

export function deleteNewsLinkError(error) {
  return {
    type: DELETE_NEWSLINK_ERROR,
    error,
  };
}

/* Group Message comments */

export function createNewsLinkCommentBegin(payload) {
  return {
    type: CREATE_NEWSLINK_COMMENT_BEGIN,
    payload,
  };
}

export function createNewsLinkCommentSuccess(payload) {
  return {
    type: CREATE_NEWSLINK_COMMENT_SUCCESS,
    payload,
  };
}

export function createNewsLinkCommentError(error) {
  return {
    type: CREATE_NEWSLINK_COMMENT_ERROR,
    error,
  };
}

// Social Link Actions

export function createSocialLinkBegin(payload) {
  return {
    type: CREATE_SOCIALLINK_BEGIN,
    payload,
  };
}

export function createSocialLinkSuccess(payload) {
  return {
    type: CREATE_NEWSLINK_SUCCESS,
    payload,
  };
}

export function createSocialLinkError(error) {
  return {
    type: CREATE_SOCIALLINK_ERROR,
    error,
  };
}

/* Social Link updating */

export function updateSocialLinkBegin(payload) {
  return {
    type: UPDATE_SOCIALLINK_BEGIN,
    payload,
  };
}

export function updateSocialLinkSuccess(payload) {
  return {
    type: UPDATE_SOCIALLINK_SUCCESS,
    payload,
  };
}

export function updateSocialLinkError(error) {
  return {
    type: UPDATE_SOCIALLINK_ERROR,
    error,
  };
}

/* Social Link deleting */

export function deleteSocialLinkBegin(payload) {
  return {
    type: DELETE_SOCIALLINK_BEGIN,
    payload,
  };
}

export function deleteSocialLinkSuccess(payload) {
  return {
    type: DELETE_SOCIALLINK_SUCCESS,
    payload,
  };
}

export function deleteSocialLinkError(error) {
  return {
    type: DELETE_SOCIALLINK_ERROR,
    error,
  };
}

/* Group Message comments */

export function createSocialLinkCommentBegin(payload) {
  return {
    type: CREATE_SOCIALLINK_COMMENT_BEGIN,
    payload,
  };
}

export function createSocialLinkCommentSuccess(payload) {
  return {
    type: CREATE_SOCIALLINK_COMMENT_SUCCESS,
    payload,
  };
}

export function createSocialLinkCommentError(error) {
  return {
    type: CREATE_SOCIALLINK_COMMENT_ERROR,
    error,
  };
}

export function deleteNewsLinkCommentBegin(payload) {
  return {
    type: DELETE_NEWSLINK_COMMENT_BEGIN,
    payload,
  };
}

export function deleteNewsLinkCommentSuccess(payload) {
  return {
    type: DELETE_NEWSLINK_COMMENT_SUCCESS,
    payload,
  };
}

export function deleteNewsLinkCommentError(error) {
  return {
    type: DELETE_NEWSLINK_COMMENT_ERROR,
    error,
  };
}

export function archiveNewsItemBegin(payload) {
  return {
    type: ARCHIVE_NEWS_ITEM_BEGIN,
    payload,
  };
}

export function archiveNewsItemSuccess(payload) {
  return {
    type: ARCHIVE_NEWS_ITEM_SUCCESS,
    payload,
  };
}

export function archiveNewsItemError(error) {
  return {
    type: ARCHIVE_NEWS_ITEM_ERROR,
    error,
  };
}

export function pinNewsItemBegin(payload) {
  return {
    type: PIN_NEWS_ITEM_BEGIN,
    payload,
  };
}

export function pinNewsItemSuccess(payload) {
  return {
    type: PIN_NEWS_ITEM_SUCCESS,
    payload,
  };
}

export function pinNewsItemError(error) {
  return {
    type: PIN_NEWS_ITEM_ERROR,
    error,
  };
}

export function unpinNewsItemBegin(payload) {
  return {
    type: UNPIN_NEWS_ITEM_BEGIN,
    payload,
  };
}

export function unpinNewsItemSuccess(payload) {
  return {
    type: UNPIN_NEWS_ITEM_SUCCESS,
    payload,
  };
}

export function unpinNewsItemError(error) {
  return {
    type: UNPIN_NEWS_ITEM_ERROR,
    error,
  };
}
