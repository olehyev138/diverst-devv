import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';


import {
  GET_NEWS_BEGIN
} from 'containers/News/constants';

import {
  getNewsSuccess, getNewsError,
} from 'containers/News/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getNews(action) {
  try {
    // const response = yield call(api.groups.all.bind(api.groups), action.payload);
  } catch (err) {
    yield put(getNewsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load news', options: { variant: 'warning' } }));
  }
}

export default function* newsSaga() {
  yield takeLatest(GET_NEWS_BEGIN, getNews);
}
