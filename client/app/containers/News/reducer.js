/*
 *
 * News reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_NEWS_ITEMS_SUCCESS, GET_NEWS_ITEM_SUCCESS, GET_NEWS_ITEMS_BEGIN,
  NEWS_FEED_UNMOUNT, GET_NEWS_ITEM_ERROR, GET_NEWS_ITEMS_ERROR,
  CREATE_GROUP_MESSAGE_BEGIN, CREATE_GROUP_MESSAGE_SUCCESS, CREATE_GROUP_MESSAGE_ERROR,
  UPDATE_GROUP_MESSAGE_BEGIN, UPDATE_GROUP_MESSAGE_SUCCESS, UPDATE_GROUP_MESSAGE_ERROR,
  CREATE_GROUP_MESSAGE_COMMENT_BEGIN, CREATE_GROUP_MESSAGE_COMMENT_SUCCESS, CREATE_GROUP_MESSAGE_COMMENT_ERROR,
} from 'containers/News/constants';

export const initialState = {
  isLoading: true,
  isCommitting: false,
  newsItems: [],
  newsItemsTotal: null,
  currentNewsItem: null
};

/* eslint-disable default-case, no-param-reassign */
function newsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
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
      case GET_NEWS_ITEM_SUCCESS:
        draft.currentNewsItem = action.payload.news_feed_link;
        draft.isLoading = false;
        break;
      case GET_NEWS_ITEM_ERROR:
        draft.isLoading = false;
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
        draft.isCommitting = false;
        break;
      case NEWS_FEED_UNMOUNT:
        return initialState;
    }
  });
}

export default newsReducer;
