import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  LIKE_NEWS_ITEM_BEGIN, LIKE_NEWS_ITEM_SUCCESS, LIKE_NEWS_ITEM_ERROR,
  UNLIKE_NEWS_ITEM_BEGIN, UNLIKE_NEWS_ITEM_SUCCESS, UNLIKE_NEWS_ITEM_ERROR
} from 'containers/Shared/Like/constants';

import {
  likeNewsItemBegin, likeNewsItemSuccess, likeNewsItemError,
  unlikeNewsItemBegin, unlikeNewsItemSuccess, unlikeNewsItemError
} from 'containers/Shared/Like/actions';

export function* likeNewsItem(action) {
  try {
    const { callback, ...rest } = action.payload;
    const payload = { like: rest };

    const response = yield call(api.likes.create.bind(api.likes), payload);
    yield put(likeNewsItemSuccess(response.data));
    callback();
  } catch (err) {
    // TODO: intl message
    yield put(likeNewsItemError(err));
    yield put(showSnackbar({ message: 'Failed to like news item', options: { variant: 'warning' } }));
  }
}

export function* unlikeNewsItem(action) {
  try {
    const { callback, ...rest } = action.payload;
    const payload = { like: rest };

    const response = yield call(api.likes.unlike.bind(api.likes), payload);
    yield put(unlikeNewsItemSuccess(response.data));
    callback();
  } catch (err) {
    // TODO: intl message
    yield put(unlikeNewsItemError(err));
    yield put(showSnackbar({ message: 'Failed to unlike news item', options: { variant: 'warning' } }));
  }
}

export default function* newsSaga() {
  yield takeLatest(LIKE_NEWS_ITEM_BEGIN, likeNewsItem);
  yield takeLatest(UNLIKE_NEWS_ITEM_BEGIN, unlikeNewsItem);
}
