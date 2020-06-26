import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_USERS_BEGIN,
  GET_USER_BEGIN,
  GET_USER_POSTS_BEGIN,
  GET_USER_EVENTS_BEGIN,
  GET_USER_DOWNLOADS_BEGIN,
  CREATE_USER_BEGIN,
  UPDATE_USER_BEGIN,
  DELETE_USER_BEGIN,
  UPDATE_FIELD_DATA_BEGIN,
  EXPORT_USERS_BEGIN,
  GET_USER_DOWNLOAD_DATA_BEGIN, GET_USER_PROTOTYPE_BEGIN, GET_SAMPLE_IMPORT_BEGIN,
} from './constants';

import {
  getUsersSuccess,
  getUsersError,
  getUserSuccess,
  getUserError,
  getUserPostsSuccess,
  getUserPostsError,
  getUserEventsSuccess,
  getUserEventsError,
  getUserDownloadsSuccess,
  getUserDownloadsError,
  createUserSuccess,
  createUserError,
  updateUserSuccess,
  updateUserError,
  deleteUserSuccess,
  deleteUserError,
  updateFieldDataSuccess,
  updateFieldDataError,
  exportUsersSuccess,
  exportUsersError,
  getUserDownloadDataSuccess,
  getUserDownloadDataError,
  getUserPrototypeSuccess,
  getUserPrototypeError,
  getSampleImportSuccess, getSampleImportError,
} from './actions';

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
    const { participation, userId, ...rest } = action.payload;
    const payload = {
      ...rest,
      query_scopes: [
        ...rest.query_scopes,
        participation === 'all' ? ['available_events_for_user', userId] : ['joined_events_for_user', userId]
      ]
    };
    const response = yield call(api.initiatives.all.bind(api.initiatives), payload);
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

export function* exportUsers(action) {
  try {
    const response = yield call(api.users.csvExport.bind(api.users), action.payload);

    yield put(exportUsersSuccess({}));
    yield put(showSnackbar({ message: 'Successfully exported users', options: { variant: 'success' } }));
  } catch (err) {
    yield put(exportUsersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to export users', options: { variant: 'warning' } }));
  }
}

export function* getSampleImport(action) {
  try {
    const response = yield call(api.users.sampleCSV.bind(api.users), action.payload);
    yield put(getSampleImportSuccess({}));
  } catch (err) {
    yield put(getSampleImportError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to export users', options: { variant: 'warning' } }));
  }
}

export function* getUserDownloadData(action) {
  try {
    const response = yield call(api.user.getDownloadData.bind(api.user), action.payload);

    yield put(getUserDownloadDataSuccess({ data: response.data, contentType: response.headers['content-type'] }));
  } catch (err) {
    yield put(getUserDownloadDataError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to retrieve file data', options: { variant: 'warning' } }));
  }
}

export function* getUserPrototype(action, updatableKey) {
  try {
    const response = yield call(api.users.prototype.bind(api.users), action.payload);

    yield put(getUserPrototypeSuccess(response.data));
  } catch (err) {
    yield put(getUserPrototypeError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get user', options: { variant: 'warning' } }));
  }
}


export default function* usersSaga() {
  yield takeLatest(GET_USERS_BEGIN, getUsers);
  yield takeLatest(GET_USER_BEGIN, getUser);
  yield takeLatest(GET_USER_POSTS_BEGIN, getUserPosts);
  yield takeLatest(GET_USER_EVENTS_BEGIN, getUserEvents);
  yield takeLatest(GET_USER_DOWNLOADS_BEGIN, getUserDownloads);
  yield takeLatest(CREATE_USER_BEGIN, createUser);
  yield takeLatest(UPDATE_USER_BEGIN, updateUser);
  yield takeLatest(DELETE_USER_BEGIN, deleteUser);
  yield takeLatest(UPDATE_FIELD_DATA_BEGIN, updateFieldData);
  yield takeLatest(EXPORT_USERS_BEGIN, exportUsers);
  yield takeLatest(GET_SAMPLE_IMPORT_BEGIN, getSampleImport);
  yield takeLatest(GET_USER_DOWNLOAD_DATA_BEGIN, getUserDownloadData);
  yield takeLatest(GET_USER_PROTOTYPE_BEGIN, getUserPrototype);
}
