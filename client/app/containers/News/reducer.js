/*
 *
 * News reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_NEWS_SUCCESS,
} from 'containers/News/constants';

export const initialState = {
};

/* eslint-disable default-case, no-param-reassign */
function newsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_NEWS_SUCCESS:
        break;
    }
  });
}

export default newsReducer;
