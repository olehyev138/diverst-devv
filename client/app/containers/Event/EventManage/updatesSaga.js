import { takeLatest } from 'redux-saga/effects';
import api from 'api/api';

import {
  GET_UPDATE_BEGIN,
  GET_UPDATES_BEGIN,
  CREATE_UPDATE_BEGIN,
  UPDATE_UPDATE_BEGIN,
  DELETE_UPDATE_BEGIN,
  GET_UPDATE_PROTOTYPE_BEGIN
} from 'containers/Shared/Update/constants';

import {
  getUpdate, updateUpdate, deleteUpdate, getUpdatePrototype, getUpdates, createUpdate
} from 'containers/Shared/Update/saga';

export default function* KpiSaga() {
  yield takeLatest(GET_UPDATES_BEGIN, action => getUpdates(action, 'initiative_id'));
  yield takeLatest(CREATE_UPDATE_BEGIN, action => createUpdate(action, 'initiative_id'));
  yield takeLatest(GET_UPDATE_PROTOTYPE_BEGIN, action => getUpdatePrototype(action, 'initiative_id'));
  yield takeLatest(GET_UPDATE_BEGIN, getUpdate);
  yield takeLatest(UPDATE_UPDATE_BEGIN, updateUpdate);
  yield takeLatest(DELETE_UPDATE_BEGIN, deleteUpdate);
}
