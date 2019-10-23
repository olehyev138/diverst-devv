import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_MENTORSHIP_USERS_BEGIN,
  GET_MENTORSHIP_USER_BEGIN,
  UPDATE_MENTORSHIP_USER_BEGIN, GET_USER_MENTORS_BEGIN, GET_USER_MENTEES_BEGIN,
} from 'containers/Mentorship/constants';

import {
  getUsersSuccess, getUsersError,
  getUserSuccess, getUserError,
  updateUserSuccess, updateUserError,
  getMentorsSuccess, getMentorsError,
  getMenteesSuccess, getMenteesError
} from 'containers/Mentorship/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

function addSerializer(action) {
  action.payload.serializer = 'mentorship';
}

export function* getUsers(action) {
  try {
    addSerializer(action);
    const response = yield call(api.users.all.bind(api.users), action.payload);
    yield put(getUsersSuccess(response.data.page));
  } catch (err) {
    yield put(getUsersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load users', options: { variant: 'warning' } }));
  }
}

export function* getUser(action) {
  console.log('fonge');
  try {
    addSerializer(action);
    const response = yield call(api.users.get.bind(api.users), action.payload.id, { serializer: action.payload.serializer });
    yield put(getUserSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getUserError(err));
    yield put(showSnackbar({ message: 'Failed to get user', options: { variant: 'warning' } }));
  }
}

export function* updateUser(action) {
  try {
    addSerializer(action);
    const payload = { user: action.payload };
    const response = yield call(api.users.update.bind(api.users), payload.user.id, payload);
    yield put(push(ROUTES.user.mentorship.show.path(payload.user.id)));
    yield put(showSnackbar({ message: 'User updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateUserError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update user', options: { variant: 'warning' } }));
  }
}

export function* getMentors(action) {
  console.log('ostie');
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
  yield takeLatest(GET_MENTORSHIP_USERS_BEGIN, getUsers);
  yield takeLatest(GET_MENTORSHIP_USER_BEGIN, getUser);
  yield takeLatest(UPDATE_MENTORSHIP_USER_BEGIN, updateUser);

  yield takeLatest(GET_USER_MENTORS_BEGIN, getMentors);
  yield takeLatest(GET_USER_MENTEES_BEGIN, getMentees);
}
