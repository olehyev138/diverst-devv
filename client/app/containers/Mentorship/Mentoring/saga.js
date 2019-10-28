import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_USER_MENTORS_BEGIN, GET_AVAILABLE_MENTORS_BEGIN, DELETE_MENTORSHIP_BEGIN, REQUEST_MENTORSHIP_BEGIN
} from 'containers/Mentorship/Mentoring/constants';

import {
  getMentorsSuccess, getMentorsError,
  getAvailableMentorsSuccess, getAvailableMentorsError,
  deleteMentorshipSuccess, deleteMentorshipError,
  requestsMentorshipSuccess, requestsMentorshipError,
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

export function* deleteMentorship(action) {
  try {
    const { payload } = action;
    const path = payload.type === 'mentors'
      ? ROUTES.mentorship.mentors.path(payload.userId)
      : ROUTES.mentorship.mentee.path(payload.userId);

    yield call(api.mentorings.removeMembers.bind(api.mentorings), payload.id);

    yield put(deleteMentorshipSuccess());
    yield put(push(path));
    yield put(showSnackbar({ message: 'Mentorship deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteMentorshipError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete mentorship', options: { variant: 'warning' } }));
  }
}

export default function* mentorshipSaga() {
  yield takeLatest(GET_USER_MENTORS_BEGIN, getMentors);
  yield takeLatest(GET_AVAILABLE_MENTORS_BEGIN, getAvailableMentors);

  yield takeLatest(DELETE_MENTORSHIP_BEGIN, deleteMentorshipError);
}
