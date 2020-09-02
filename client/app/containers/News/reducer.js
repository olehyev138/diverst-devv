/*
 *
 * News reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_NEWS_ITEMS_SUCCESS,
  GET_NEWS_ITEM_SUCCESS,
  GET_NEWS_ITEMS_BEGIN,
  NEWS_FEED_UNMOUNT,
  GET_NEWS_ITEM_ERROR,
  GET_NEWS_ITEMS_ERROR,
  GET_NEWS_ITEM_BEGIN,
  CREATE_GROUP_MESSAGE_BEGIN,
  CREATE_GROUP_MESSAGE_SUCCESS,
  CREATE_GROUP_MESSAGE_ERROR,
  UPDATE_GROUP_MESSAGE_BEGIN,
  UPDATE_GROUP_MESSAGE_SUCCESS,
  UPDATE_GROUP_MESSAGE_ERROR,
  CREATE_GROUP_MESSAGE_COMMENT_BEGIN,
  CREATE_GROUP_MESSAGE_COMMENT_SUCCESS,
  CREATE_GROUP_MESSAGE_COMMENT_ERROR,

  CREATE_NEWSLINK_BEGIN,
  CREATE_NEWSLINK_SUCCESS,
  CREATE_NEWSLINK_ERROR,
  UPDATE_NEWSLINK_BEGIN,
  UPDATE_NEWSLINK_SUCCESS,
  UPDATE_NEWSLINK_ERROR,
  CREATE_NEWSLINK_COMMENT_BEGIN,
  CREATE_NEWSLINK_COMMENT_SUCCESS,
  CREATE_NEWSLINK_COMMENT_ERROR,

  CREATE_SOCIALLINK_BEGIN,
  CREATE_SOCIALLINK_SUCCESS,
  CREATE_SOCIALLINK_ERROR,
  UPDATE_SOCIALLINK_BEGIN,
  UPDATE_SOCIALLINK_SUCCESS,
  UPDATE_SOCIALLINK_ERROR,
  CREATE_SOCIALLINK_COMMENT_BEGIN,
  CREATE_SOCIALLINK_COMMENT_SUCCESS,
  CREATE_SOCIALLINK_COMMENT_ERROR,
  DELETE_SOCIALLINK_ERROR,
  DELETE_SOCIALLINK_BEGIN,
  DELETE_SOCIALLINK_SUCCESS,

  UPDATE_NEWS_ITEM_BEGIN,
  UPDATE_NEWS_ITEM_SUCCESS,
  UPDATE_NEWS_ITEM_ERROR,

  ARCHIVE_NEWS_ITEM_BEGIN,
  ARCHIVE_NEWS_ITEM_SUCCESS,
  ARCHIVE_NEWS_ITEM_ERROR,

  PIN_NEWS_ITEM_BEGIN,
  PIN_NEWS_ITEM_SUCCESS,
  PIN_NEWS_ITEM_ERROR,

  UNPIN_NEWS_ITEM_BEGIN,
  UNPIN_NEWS_ITEM_SUCCESS,
  UNPIN_NEWS_ITEM_ERROR,
  APPROVE_NEWS_ITEM_BEGIN,
  APPROVE_NEWS_ITEM_SUCCESS,
  APPROVE_NEWS_ITEM_ERROR,
  DELETE_NEWSLINK_BEGIN,
  DELETE_GROUP_MESSAGE_BEGIN,
  DELETE_NEWSLINK_SUCCESS,
  DELETE_GROUP_MESSAGE_SUCCESS,
} from 'containers/News/constants';

export const initialState = {
  isLoading: true,
  isFormLoading: true,
  isCommitting: false,
  newsItems: [],
  newsItemsTotal: null,
  currentNewsItem: null,
  hasChanged: false,
};

/* eslint-disable default-case, no-param-reassign */
function newsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_NEWS_ITEMS_BEGIN:
        draft.isLoading = true;
        break;
      case GET_NEWS_ITEMS_SUCCESS:
        draft.newsItems = action.payload.items;
        draft.newsItemsTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_NEWS_ITEMS_ERROR:
        draft.isLoading = false;
        break;
      case GET_NEWS_ITEM_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_NEWS_ITEM_SUCCESS:
        draft.currentNewsItem = action.payload.news_feed_link;
        draft.isFormLoading = false;
        break;
      case GET_NEWS_ITEM_ERROR:
        draft.isFormLoading = false;
        break;
      case UPDATE_NEWS_ITEM_BEGIN:
        draft.isCommitting = true;
        break;
      case UPDATE_NEWS_ITEM_SUCCESS:
        draft.isCommitting = false;
        break;
      case UPDATE_NEWS_ITEM_ERROR:
        draft.isCommitting = false;
        break;
      case CREATE_GROUP_MESSAGE_BEGIN:
      case UPDATE_GROUP_MESSAGE_BEGIN:
      case CREATE_GROUP_MESSAGE_COMMENT_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_GROUP_MESSAGE_SUCCESS:
      case UPDATE_GROUP_MESSAGE_SUCCESS:
      case CREATE_GROUP_MESSAGE_COMMENT_SUCCESS:
      case CREATE_GROUP_MESSAGE_ERROR:
      case UPDATE_GROUP_MESSAGE_ERROR:
      case CREATE_GROUP_MESSAGE_COMMENT_ERROR:
      case CREATE_NEWSLINK_BEGIN:
      case UPDATE_NEWSLINK_BEGIN:
      case CREATE_NEWSLINK_COMMENT_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_NEWSLINK_SUCCESS:
      case UPDATE_NEWSLINK_SUCCESS:
      case CREATE_NEWSLINK_COMMENT_SUCCESS:
      case CREATE_NEWSLINK_ERROR:
      case UPDATE_NEWSLINK_ERROR:
      case CREATE_NEWSLINK_COMMENT_ERROR:
        draft.isCommitting = false;
        break;
      case CREATE_SOCIALLINK_BEGIN:
      case UPDATE_SOCIALLINK_BEGIN:
      case CREATE_SOCIALLINK_COMMENT_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_SOCIALLINK_SUCCESS:
      case UPDATE_SOCIALLINK_SUCCESS:
      case CREATE_SOCIALLINK_COMMENT_SUCCESS:
      case CREATE_SOCIALLINK_ERROR:
      case UPDATE_SOCIALLINK_ERROR:
      case CREATE_SOCIALLINK_COMMENT_ERROR:
      case ARCHIVE_NEWS_ITEM_ERROR:
      case PIN_NEWS_ITEM_ERROR:
      case UNPIN_NEWS_ITEM_ERROR:
        draft.isCommitting = false;
        break;
      case NEWS_FEED_UNMOUNT:
        return initialState;
      case DELETE_SOCIALLINK_BEGIN:
      case DELETE_NEWSLINK_BEGIN:
      case DELETE_GROUP_MESSAGE_BEGIN:
        draft.hasChanged = false;
        break;
      case DELETE_SOCIALLINK_SUCCESS:
      case DELETE_NEWSLINK_SUCCESS:
      case DELETE_GROUP_MESSAGE_SUCCESS:
        draft.hasChanged = true;
        break;
      case APPROVE_NEWS_ITEM_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;
      case APPROVE_NEWS_ITEM_SUCCESS:
        draft.isCommitting = false;
        if (state.newsItems.every(news => news.approved === false)) {
          draft.newsItems = state.newsItems.filter(news => news.id !== action.payload.news_feed_link.id);
          draft.newsItemsTotal -= 1;
        } else
          draft.hasChanged = true;
        break;
      case APPROVE_NEWS_ITEM_ERROR:
        draft.isCommitting = false;
        break;
      case ARCHIVE_NEWS_ITEM_BEGIN:
      case PIN_NEWS_ITEM_BEGIN:
      case UNPIN_NEWS_ITEM_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;
      case ARCHIVE_NEWS_ITEM_SUCCESS:
      case PIN_NEWS_ITEM_SUCCESS:
      case UNPIN_NEWS_ITEM_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;
    }
  });
}

export default newsReducer;
