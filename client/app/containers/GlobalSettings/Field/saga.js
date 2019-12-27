import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_FIELDS_BEGIN, CREATE_FIELD_BEGIN,
  GET_FIELD_BEGIN, UPDATE_FIELD_BEGIN, DELETE_FIELD_BEGIN
} from 'containers/GlobalSettings/Field/constants';

import {
  getFieldsSuccess, getFieldsError,
  createFieldSuccess, createFieldError,
  getFieldSuccess, getFieldError,
  updateFieldSuccess, updateFieldError,
  deleteFieldError, deleteFieldSuccess
} from 'containers/GlobalSettings/Field/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getFields(action) {
  try {
    const { enterpriseId, ...rest } = action.payload;
    const response = yield call(api.enterprises.fields.bind(api.enterprises), enterpriseId, rest);
    yield put(getFieldsSuccess(response.data.page));
  } catch (err) {
    yield put(getFieldsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load fields', options: { variant: 'warning' } }));
  }
}

export function* getField(action) {
  try {
    const response = yield call(api.fields.get.bind(api.fields), action.payload.id);
    yield put(getFieldSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getFieldError(err));
    yield put(showSnackbar({ message: 'Failed to get field', options: { variant: 'warning' } }));
  }
}


export function* createField(action) {
  try {
    const { enterpriseId, ...rest } = action.payload;
    const payload = { field: rest };

    const response = yield call(api.enterprises.createFields.bind(api.enterprises), enterpriseId, payload);

    yield put(createFieldSuccess());
    yield put(showSnackbar({ message: 'Field created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createFieldError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create field', options: { variant: 'warning' } }));
  }
}

export function* updateField(action) {
  try {
    const payload = { field: action.payload };
    const response = yield call(api.fields.update.bind(api.fields), payload.field.id, payload);

    yield put(updateFieldSuccess());
    yield put(showSnackbar({ message: 'Field updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateFieldError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update field', options: { variant: 'warning' } }));
  }
}

export function* deleteField(action) {
  try {
    yield call(api.fields.destroy.bind(api.fields), action.payload);

    yield put(deleteFieldSuccess());
    yield put(showSnackbar({ message: 'Field deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteFieldError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update field', options: { variant: 'warning' } }));
  }
}

export default function* fieldsSaga() {
  yield takeLatest(GET_FIELDS_BEGIN, getFields);
  yield takeLatest(GET_FIELD_BEGIN, getField);
  yield takeLatest(CREATE_FIELD_BEGIN, createField);
  yield takeLatest(UPDATE_FIELD_BEGIN, updateField);

  yield takeLatest(DELETE_FIELD_BEGIN, deleteField);
}
