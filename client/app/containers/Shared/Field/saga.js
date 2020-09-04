import { call, put, takeEvery, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import messages from './messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

import {
  GET_FIELD_BEGIN, UPDATE_FIELD_BEGIN, DELETE_FIELD_BEGIN, UPDATE_FIELD_POSITION_BEGIN
} from 'containers/Shared/Field/constants';

import {
  getFieldSuccess, getFieldError,
  updateFieldSuccess, updateFieldError,
  deleteFieldError, deleteFieldSuccess,
  getFieldsSuccess, getFieldsError,
  createFieldSuccess, createFieldError,
  updateFieldPositionSuccess, updateFieldPositionError,
} from 'containers/Shared/Field/actions';

export function* getField(action) {
  try {
    const response = yield call(api.fields.get.bind(api.fields), action.payload.id);
    yield put(getFieldSuccess(response.data));
  } catch (err) {
    yield put(getFieldError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.field), options: { variant: 'warning' } }));
  }
}

export function* updateFieldPosition(action) {
  try {
    const payload = { field: { id: action.payload.id, position: action.payload.position, type: action.payload.type } };
    yield call(api.fields.update.bind(api.fields), payload.field.id, payload);
    yield put(updateFieldPositionSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.position), options: { variant: 'warning' } }));
  } catch (err) {
    yield put(updateFieldPositionError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.position), options: { variant: 'warning' } }));
  }
}

export function* updateField(action) {
  try {
    const payload = { field: action.payload };
    const response = yield call(api.fields.update.bind(api.fields), payload.field.id, payload);

    yield put(updateFieldSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateFieldError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'warning' } }));
  }
}

export function* deleteField(action) {
  try {
    yield call(api.fields.destroy.bind(api.fields), action.payload);

    yield put(deleteFieldSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteFieldError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}

export function* getFields(action, fieldDefinerApi) {
  try {
    const { fieldDefinerId, ...rest } = action.payload;
    const response = yield call(fieldDefinerApi.fields.bind(fieldDefinerApi), fieldDefinerId, rest);
    yield put(getFieldsSuccess(response.data.page));
  } catch (err) {
    yield put(getFieldsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.fields), options: { variant: 'warning' } }));
  }
}

export function* createField(action, fieldDefinerApi) {
  try {
    const { fieldDefinerId, ...rest } = action.payload;
    const payload = { field: rest };

    const response = yield call(fieldDefinerApi.createFields.bind(fieldDefinerApi), fieldDefinerId, payload);

    yield put(createFieldSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createFieldError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create), options: { variant: 'warning' } }));
  }
}


export default function* fieldsSaga() {
  yield takeLatest(GET_FIELD_BEGIN, getField);
  yield takeLatest(UPDATE_FIELD_BEGIN, updateField);
  yield takeLatest(DELETE_FIELD_BEGIN, deleteField);
}
