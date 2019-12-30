import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_FIELDS_BEGIN, CREATE_FIELD_BEGIN,
  GET_FIELD_BEGIN, UPDATE_FIELD_BEGIN, DELETE_FIELD_BEGIN
} from 'containers/Shared/Field/constants';

import {
  getFieldsSuccess, getFieldsError,
  createFieldSuccess, createFieldError,
} from 'containers/Shared/Field/actions';

import {
  getField, updateField, deleteField,
} from 'containers/Shared/Field/saga';

export function* getFields(action) {
  try {
    const { groupId, ...rest } = action.payload;
    const response = yield call(api.groups.fields.bind(api.groups), groupId, rest);
    yield put(getFieldsSuccess(response.data.page));
  } catch (err) {
    yield put(getFieldsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load fields', options: { variant: 'warning' } }));
  }
}

export function* createField(action) {
  try {
    const { groupId, ...rest } = action.payload;
    const payload = { field: rest };

    const response = yield call(api.groups.createFields.bind(api.groups), groupId, payload);

    yield put(createFieldSuccess());
    yield put(showSnackbar({ message: 'Field created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createFieldError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create field', options: { variant: 'warning' } }));
  }
}

export default function* fieldsSaga() {
  yield takeLatest(GET_FIELDS_BEGIN, getFields);
  yield takeLatest(GET_FIELD_BEGIN, getField);
  yield takeLatest(CREATE_FIELD_BEGIN, createField);
  yield takeLatest(UPDATE_FIELD_BEGIN, updateField);

  yield takeLatest(DELETE_FIELD_BEGIN, deleteField);
}
