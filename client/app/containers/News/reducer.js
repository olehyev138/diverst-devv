/*
 *
 * News reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_NEWS_ITEMS_SUCCESS, NEWS_FEED_UNMOUNT
} from 'containers/News/constants';

export const initialState = {
  newsItems: {}
};

/* eslint-disable default-case, no-param-reassign */
function newsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_NEWS_ITEMS_SUCCESS:
        draft.newsItems = action.payload.items;
        break;
      case NEWS_FEED_UNMOUNT:
        return initialState;
    }
  });
}

export default newsReducer;
