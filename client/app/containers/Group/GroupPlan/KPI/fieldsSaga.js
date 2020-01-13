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
  getField, updateField, deleteField, getFields, createField
} from 'containers/Shared/Field/saga';

export default function* fieldsSaga() {
  yield takeLatest(GET_FIELDS_BEGIN, action => getFields(action, api.groups));
  yield takeLatest(CREATE_FIELD_BEGIN, action => createField(action, api.groups));
  yield takeLatest(GET_FIELD_BEGIN, getField);
  yield takeLatest(UPDATE_FIELD_BEGIN, updateField);
  yield takeLatest(DELETE_FIELD_BEGIN, deleteField);
}
