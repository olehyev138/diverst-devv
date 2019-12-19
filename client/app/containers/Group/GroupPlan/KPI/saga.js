import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_UPDATE_BEGIN,
  GET_UPDATES_BEGIN,
  CREATE_UPDATE_BEGIN,
  UPDATE_UPDATE_BEGIN,
  DELETE_UPDATE_BEGIN,
  GET_FIELD_BEGIN,
  GET_FIELDS_BEGIN,
  CREATE_FIELD_BEGIN,
  UPDATE_FIELD_BEGIN,
  DELETE_FIELD_BEGIN,
} from './constants';

import {
  getUpdateSuccess, getUpdateError,
  getUpdatesSuccess, getUpdatesError,
  createUpdateSuccess, createUpdateError,
  updateUpdateSuccess, updateUpdateError,
  deleteUpdateSuccess, deleteUpdateError,
  getFieldSuccess, getFieldError,
  getFieldsSuccess, getFieldsError,
  createFieldSuccess, createFieldError,
  updateFieldSuccess, updateFieldError,
  deleteFieldSuccess, deleteFieldError,
} from './actions';

export function* getUpdate(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getUpdateSuccess(response.data));
  } catch (err) {
    yield put(getUpdateError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get update', options: { variant: 'warning' } }));
  }
}

export function* getUpdates(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getUpdatesSuccess(response.data.page));
  } catch (err) {
    yield put(getUpdatesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get updates', options: { variant: 'warning' } }));
  }
}

export function* createUpdate(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createUpdateSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created update', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createUpdateError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create update', options: { variant: 'warning' } }));
  }
}

export function* updateUpdate(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(updateUpdateSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated update', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateUpdateError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update update', options: { variant: 'warning' } }));
  }
}

export function* deleteUpdate(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deleteUpdateSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted update', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteUpdateError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete update', options: { variant: 'warning' } }));
  }
}

export function* getField(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getFieldSuccess(response.data));
  } catch (err) {
    yield put(getFieldError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get field', options: { variant: 'warning' } }));
  }
}

export function* getFields(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getFieldsSuccess(response.data.page));
  } catch (err) {
    yield put(getFieldsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get fields', options: { variant: 'warning' } }));
  }
}

export function* createField(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createFieldSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created field', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createFieldError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create field', options: { variant: 'warning' } }));
  }
}

export function* updateField(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(updateFieldSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated field', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateFieldError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update field', options: { variant: 'warning' } }));
  }
}

export function* deleteField(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deleteFieldSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted field', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteFieldError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete field', options: { variant: 'warning' } }));
  }
}


export default function* KpiSaga() {
  yield takeLatest(GET_UPDATE_BEGIN, getUpdate);
  yield takeLatest(GET_UPDATES_BEGIN, getUpdates);
  yield takeLatest(CREATE_UPDATE_BEGIN, createUpdate);
  yield takeLatest(UPDATE_UPDATE_BEGIN, updateUpdate);
  yield takeLatest(DELETE_UPDATE_BEGIN, deleteUpdate);
  yield takeLatest(GET_FIELD_BEGIN, getField);
  yield takeLatest(GET_FIELDS_BEGIN, getFields);
  yield takeLatest(CREATE_FIELD_BEGIN, createField);
  yield takeLatest(UPDATE_FIELD_BEGIN, updateField);
  yield takeLatest(DELETE_FIELD_BEGIN, deleteField);
}
