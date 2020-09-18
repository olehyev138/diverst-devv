import { call, put, takeEvery, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_FIELDS_BEGIN, CREATE_FIELD_BEGIN,
  GET_FIELD_BEGIN, UPDATE_FIELD_BEGIN, DELETE_FIELD_BEGIN,
  UPDATE_FIELD_POSITION_BEGIN,
} from 'containers/Shared/Field/constants';

import {
  getField, updateField, deleteField, getFields, createField, updateFieldPosition
} from 'containers/Shared/Field/saga';


export default function* fieldsSaga() {
  yield takeLatest(GET_FIELDS_BEGIN, action => getFields(action, api.enterprises));
  yield takeLatest(CREATE_FIELD_BEGIN, action => createField(action, api.enterprises));
  yield takeLatest(GET_FIELD_BEGIN, getField);
  yield takeLatest(UPDATE_FIELD_BEGIN, updateField);
  yield takeLatest(DELETE_FIELD_BEGIN, deleteField);
  yield takeEvery(UPDATE_FIELD_POSITION_BEGIN, updateFieldPosition);
}
