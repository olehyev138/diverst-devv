import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_USERS_BEGIN, CREATE_USER_BEGIN,
  GET_USER_BEGIN, UPDATE_USER_BEGIN, DELETE_USER_BEGIN,
  UPDATE_FIELD_DATA_BEGIN, GET_USER_POSTS_BEGIN,
  GET_USER_EVENTS_BEGIN, GET_USER_DOWNLOADS_BEGIN,
} from 'containers/User/constants';

import {
  getUsersSuccess, getUsersError,
  createUserSuccess, createUserError,
  getUserSuccess, getUserError,
  updateUserSuccess, updateUserError,
  deleteUserSuccess, deleteUserError,
  getUserPostsSuccess, getUserPostsError,
  getUserEventsSuccess, getUserEventsError,
  updateFieldDataSuccess, getUserDownloadsSuccess,
  getUserDownloadsError
} from 'containers/User/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getUsers(action) {
  try {
    const response = yield call(api.users.all.bind(api.users), action.payload);
    yield put(getUsersSuccess(response.data.page));
  } catch (err) {
    yield put(getUsersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load users', options: { variant: 'warning' } }));
  }
}

export function* getUser(action) {
  try {
    const response = yield call(api.users.get.bind(api.users), action.payload.id);
    yield put(getUserSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getUserError(err));
    yield put(showSnackbar({ message: 'Failed to get user', options: { variant: 'warning' } }));
  }
}

export function* getUserPosts(action) {
  try {
    const response = yield call(api.user.getPosts.bind(api.user), action.payload);
    yield put(getUserPostsSuccess(response.data.page));
  } catch (err) {
    yield put(getUserPostsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load posts', options: { variant: 'warning' } }));
  }
}

export function* getUserEvents(action) {
  try {
    let response;
    if (action.payload.participation === 'all')
      response = yield call(api.user.getAllEvents.bind(api.user), action.payload);
    else
      response = yield call(api.user.getJoinedEvents.bind(api.user), action.payload);
    yield put(getUserEventsSuccess(response.data.page));
  } catch (err) {
    yield put(getUserEventsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load events', options: { variant: 'warning' } }));
  }
}

export function* getUserDownloads(action) {
  try {
    const response = yield call(api.user.getDownloads.bind(api.user), action.payload);
    yield put(getUserDownloadsSuccess(response.data.page));
  } catch (err) {
    yield put(getUserDownloadsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to retrieve downloads', options: { variant: 'warning' } }));
  }
}

export function* createUser(action) {
  try {
    const payload = { user: action.payload };

    const response = yield call(api.users.create.bind(api.users), payload);

    yield put(createUserSuccess());
    yield put(push(ROUTES.admin.system.users.index.path()));
    yield put(showSnackbar({ message: 'User created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createUserError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create user', options: { variant: 'warning' } }));
  }
}

export function* updateUser(action) {
  try {
    const payload = { user: action.payload };
    const response = yield call(api.users.update.bind(api.users), payload.user.id, payload);

    yield put(updateUserSuccess());
    yield put(push(payload.user.redirectPath || ROUTES.admin.system.users.index.path()));
    yield put(showSnackbar({ message: 'User updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateUserError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update user', options: { variant: 'warning' } }));
  }
}

export function* deleteUser(action) {
  try {
    yield call(api.users.destroy.bind(api.users), action.payload);

    yield put(deleteUserSuccess());
    yield put(push(ROUTES.admin.system.users.index.path()));
    yield put(showSnackbar({ message: 'User deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteUserError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update user', options: { variant: 'warning' } }));
  }
}

export function* updateFieldData(action) {
  try {
    const payload = { field_data: { field_data: action.payload.field_data } };
    const response = yield call(api.fieldData.updateFieldData.bind(api.fieldData), payload);

    yield put(updateFieldDataSuccess());
    yield put(showSnackbar({ message: 'Fields updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateUserError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update user', options: { variant: 'warning' } }));
  }
}


export default function* usersSaga() {
  yield takeLatest(GET_USERS_BEGIN, getUsers);
  yield takeLatest(GET_USER_BEGIN, getUser);
  yield takeLatest(CREATE_USER_BEGIN, createUser);
  yield takeLatest(UPDATE_USER_BEGIN, updateUser);
  yield takeLatest(DELETE_USER_BEGIN, deleteUser);
  yield takeLatest(GET_USER_POSTS_BEGIN, getUserPosts);
  yield takeLatest(GET_USER_EVENTS_BEGIN, getUserEvents);
  yield takeLatest(GET_USER_DOWNLOADS_BEGIN, getUserDownloads);
  yield takeLatest(UPDATE_FIELD_DATA_BEGIN, updateFieldData);
}
