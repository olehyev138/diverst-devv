import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_USER_MENTORS_BEGIN, GET_USER_MENTEES_BEGIN, GET_AVAILABLE_MENTORS_BEGIN, GET_AVAILABLE_MENTEES_BEGIN,
} from 'containers/Mentorship/Mentoring/constants';

import {
  getMentorsSuccess, getMentorsError,
  getMenteesSuccess, getMenteesError,
  getAvailableMentorsSuccess, getAvailableMentorsError,
  getAvailableMenteesSuccess, getAvailableMenteesError,
} from 'containers/Mentorship/Mentoring/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getMentors(action) {
  try {
    const { payload } = action;
    // const response = yield call(api.mentorings.all.bind(api.mentorings), payload);
    const response = yield call(api.users.all.bind(api.users), {
      ...payload,
      search_method: 'has_many_search',
      association: 'mentors',
      serializer: 'mentorship_lite',
    });
    yield put(getMentorsSuccess(response.data.page));
  } catch (err) {
    yield put(getMentorsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load user\'s mentors', options: { variant: 'warning' } }));
  }
}

export function* getMentees(action) {
  try {
    const { payload } = action;
    // const response = yield call(api.mentorings.all.bind(api.mentorings), payload);
    const response = yield call(api.users.all.bind(api.users), {
      ...payload,
      search_method: 'has_many_search',
      association: 'mentees',
      serializer: 'mentorship_lite',
    });
    yield put(getMenteesSuccess(response.data.page));
  } catch (err) {
    yield put(getMenteesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load user\'s mentees', options: { variant: 'warning' } }));
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
    yield put(showSnackbar({ message: 'Failed to load available mentors', options: { variant: 'warning' } }));
  }
}

export function* getAvailableMentees(action) {
  try {
    const { payload } = action;
    const response = yield call(api.users.all.bind(api.users), { ...payload, serializer: 'mentorship_lite' });
    yield put(getAvailableMenteesSuccess(response.data.page));
  } catch (err) {
    yield put(getAvailableMenteesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load available mentees', options: { variant: 'warning' } }));
  }
}

export default function* mentorshipSaga() {
  yield takeLatest(GET_USER_MENTORS_BEGIN, getMentors);
  yield takeLatest(GET_USER_MENTEES_BEGIN, getMentees);

  yield takeLatest(GET_AVAILABLE_MENTORS_BEGIN, getAvailableMentors);
  yield takeLatest(GET_AVAILABLE_MENTEES_BEGIN, getAvailableMentees);
}
