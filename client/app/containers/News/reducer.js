/*
 *
 * News reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_NEWS_ITEMS_SUCCESS, GET_NEWS_ITEM_SUCCESS,
  NEWS_FEED_UNMOUNT
} from 'containers/News/constants';

export const initialState = {
  newsItems: [],
  newsItemsTotal: null,
  currentNewsItem: null
};

/* eslint-disable default-case, no-param-reassign */
function newsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_NEWS_ITEMS_SUCCESS:
        draft.newsItems = action.payload.items;
        draft.newsItemsTotal = action.payload.total;
        break;
      case GET_NEWS_ITEM_SUCCESS:
        draft.currentNewsItem = action.payload.news_feed_link;
        break;
      case NEWS_FEED_UNMOUNT:
        return initialState;
    }
  });
}

export default newsReducer;
