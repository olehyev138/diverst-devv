import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_REGION_LEADERS_BEGIN, GET_REGION_LEADER_BEGIN, CREATE_REGION_LEADER_BEGIN,
  DELETE_REGION_LEADER_BEGIN, UPDATE_REGION_LEADER_BEGIN, UPDATE_REGION_LEADER_SUCCESS, UPDATE_REGION_LEADER_ERROR
} from './constants';

import {
  getRegionLeadersSuccess, getRegionLeadersError, deleteRegionLeaderSuccess,
  createRegionLeaderError, deleteRegionLeaderError, createRegionLeaderSuccess,
  updateRegionLeaderBegin, updateRegionLeaderSuccess, updateRegionLeaderError, getRegionLeaderSuccess, getRegionLeaderError,
} from './actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getRegionLeaders(action) {
  try {
    const response = yield call(api.regionLeaders.all.bind(api.regionLeaders), action.payload);
    yield put(getRegionLeadersSuccess(response.data.page));
  } catch (err) {
    yield put(getRegionLeadersError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.leaders), options: { variant: 'warning' } }));
  }
}

export function* getRegionLeader(action) {
  try {
    const response = yield call(api.regionLeaders.get.bind(api.regionLeaders), action.payload.id);
    yield put(getRegionLeaderSuccess(response.data));
  } catch (err) {
    yield put(getRegionLeaderError(err));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.leader),
      options: { variant: 'warning' }
    }));
  }
}

export function* createRegionLeader(action) {
  try {
    const payload = { region_leader: action.payload };
    const response = yield call(api.regionLeaders.create.bind(api.regionLeaders), payload);
    yield put(createRegionLeaderSuccess());
    yield put(push(ROUTES.region.manage.leaders.index.path(action.payload.region_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createRegionLeaderError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create), options: { variant: 'warning' } }));
  }
}

export function* deleteRegionLeader(action) {
  try {
    yield call(api.regionLeaders.destroy.bind(api.regionLeaders), action.payload.id);
    yield put(deleteRegionLeaderSuccess());
    yield put(push(ROUTES.region.manage.leaders.index.path(action.payload.region_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteRegionLeaderError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}

export function* updateRegionLeader(action) {
  try {
    const payload = { region_leader: action.payload };
    const response = yield call(api.regionLeaders.update.bind(api.regionLeaders), payload.region_leader.id, payload);
    yield put(updateRegionLeaderSuccess());
    yield put(push(ROUTES.region.manage.leaders.index.path(action.payload.region_id)));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.success.update),
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateRegionLeaderError(err));

    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.update),
      options: { variant: 'warning' }
    }));
  }
}

export default function* regionLeadersSaga() {
  yield takeLatest(GET_REGION_LEADERS_BEGIN, getRegionLeaders);
  yield takeLatest(GET_REGION_LEADER_BEGIN, getRegionLeader);
  yield takeLatest(UPDATE_REGION_LEADER_BEGIN, updateRegionLeader);
  yield takeLatest(CREATE_REGION_LEADER_BEGIN, createRegionLeader);
  yield takeLatest(DELETE_REGION_LEADER_BEGIN, deleteRegionLeader);
}
