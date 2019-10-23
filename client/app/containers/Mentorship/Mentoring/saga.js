import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_USER_MENTORS_BEGIN, GET_USER_MENTEES_BEGIN,
} from 'containers/Mentorship/Mentoring/constants';

import {
  getMentorsSuccess, getMentorsError,
  getMenteesSuccess, getMenteesError
} from 'containers/Mentorship/Mentoring/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getMentors(action) {
  console.log('aa_getMentors');
  try {
    const { payload } = action;
    payload.mentee_id = payload.userId;
    const response = yield call(api.mentorings.all.bind(api.mentorings), payload);
    yield put(getMentorsSuccess(response.data.page));
  } catch (err) {
    yield put(getMentorsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load user\'s mentors', options: { variant: 'warning' } }));
  }
}

export function* getMentees(action) {
  console.log('aa_getMentee');
  try {
    const { payload } = action;
    payload.mentor_id = payload.userId;
    const response = yield call(api.mentorings.all.bind(api.mentorings), payload);
    yield put(getMenteesSuccess(response.data.page));
  } catch (err) {
    yield put(getMenteesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load user\'s mentees', options: { variant: 'warning' } }));
  }
}


export default function* mentorshipSaga() {
  yield takeLatest(GET_USER_MENTORS_BEGIN, getMentors);
  yield takeLatest(GET_USER_MENTEES_BEGIN, getMentees);
}
