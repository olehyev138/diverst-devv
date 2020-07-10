import { call, put, takeEvery, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

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
    // TODO: intl message
    yield put(getFieldError(err));
    yield put(showSnackbar({ message: 'Failed to get field', options: { variant: 'warning' } }));
  }
}

export function* updateFieldPosition(action) {
  try {
    const payload = { field: { id: action.payload.id, position: action.payload.position, type: action.payload.type } };
    yield call(api.fields.update.bind(api.fields), payload.field.id, payload);
    yield put(updateFieldPositionSuccess());
    yield put(showSnackbar({ message: 'Field order updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateFieldPositionError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update field order', options: { variant: 'warning' } }));
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

export function* getFields(action, fieldDefinerApi) {
  try {
    const { fieldDefinerId, ...rest } = action.payload;
    const response = yield call(fieldDefinerApi.fields.bind(fieldDefinerApi), fieldDefinerId, rest);
    yield put(getFieldsSuccess(response.data.page));
  } catch (err) {
    yield put(getFieldsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load fields', options: { variant: 'warning' } }));
  }
}

export function* createField(action, fieldDefinerApi) {
  try {
    const { fieldDefinerId, ...rest } = action.payload;
    const payload = { field: rest };

    const response = yield call(fieldDefinerApi.createFields.bind(fieldDefinerApi), fieldDefinerId, payload);

    yield put(createFieldSuccess());
    yield put(showSnackbar({ message: 'Field created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createFieldError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create field', options: { variant: 'warning' } }));
  }
}


export default function* fieldsSaga() {
  yield takeLatest(GET_FIELD_BEGIN, getField);
  yield takeLatest(UPDATE_FIELD_BEGIN, updateField);
  yield takeLatest(DELETE_FIELD_BEGIN, deleteField);
}
