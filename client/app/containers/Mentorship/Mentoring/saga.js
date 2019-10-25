import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_USER_MENTORS_BEGIN, GET_AVAILABLE_MENTORS_BEGIN,
} from 'containers/Mentorship/Mentoring/constants';

import {
  getMentorsSuccess, getMentorsError,
  getAvailableMentorsSuccess, getAvailableMentorsError,
} from 'containers/Mentorship/Mentoring/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getMentors(action) {
  try {
    const { payload } = action;
    const response = yield call(api.users.all.bind(api.users), {
      ...payload,
      search_method: 'has_many_search',
      serializer: 'mentorship_lite',
    });
    yield put(getMentorsSuccess(response.data.page));
  } catch (err) {
    yield put(getMentorsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: `Failed to load user's ${action.payload.association}`, options: { variant: 'warning' } }));
  }
}

export function* getAvailableMentors(action) {
  try {
    const { payload } = action;
    const response = yield call(api.users.all.bind(api.users), { ...payload, serializer: 'mentorship_lite' });
    yield put(getAvailableMentorsSuccess(response.data.page));
  } catch (err) {
    yield put(getAvailableMentorsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: `Failed to load available ${action.payload.query_scopes[0]}`, options: { variant: 'warning' } }));
  }
}

export default function* mentorshipSaga() {
  yield takeLatest(GET_USER_MENTORS_BEGIN, getMentors);

  yield takeLatest(GET_AVAILABLE_MENTORS_BEGIN, getAvailableMentors);
}
