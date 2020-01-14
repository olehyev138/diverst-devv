import { takeLatest } from 'redux-saga/effects';
import api from 'api/api';

import {
  GET_UPDATE_BEGIN,
  GET_UPDATES_BEGIN,
  GET_METRICS_BEGIN,
  CREATE_UPDATE_BEGIN,
  UPDATE_UPDATE_BEGIN,
  DELETE_UPDATE_BEGIN,
  GET_UPDATE_PROTOTYPE_BEGIN
} from 'containers/Shared/Update/constants';

import {
  getUpdate, updateUpdate, deleteUpdate, getMetrics, getUpdatePrototype, getUpdates, createUpdate
} from 'containers/Shared/Update/saga';

export default function* KpiSaga() {
  yield takeLatest(GET_UPDATES_BEGIN, action => getUpdates(action, api.initiatives));
  yield takeLatest(GET_METRICS_BEGIN, action => getMetrics(action, api.initiatives));
  yield takeLatest(CREATE_UPDATE_BEGIN, action => createUpdate(action, api.initiatives));
  yield takeLatest(GET_UPDATE_PROTOTYPE_BEGIN, action => getUpdatePrototype(action, api.initiatives));
  yield takeLatest(GET_UPDATE_BEGIN, getUpdate);
  yield takeLatest(UPDATE_UPDATE_BEGIN, updateUpdate);
  yield takeLatest(DELETE_UPDATE_BEGIN, deleteUpdate);
}
