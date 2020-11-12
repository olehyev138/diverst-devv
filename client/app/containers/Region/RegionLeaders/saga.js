import { call, put, takeLatest, select } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_REGION_LEADERS_BEGIN, GET_REGION_LEADER_BEGIN, CREATE_REGION_LEADER_BEGIN,
  DELETE_REGION_LEADER_BEGIN, UPDATE_REGION_LEADER_BEGIN,
} from './constants';

import {
  getRegionLeadersBegin,
  getRegionLeadersSuccess, getRegionLeadersError, deleteRegionLeaderSuccess,
  createRegionLeaderError, deleteRegionLeaderError, createRegionLeaderSuccess,
  updateRegionLeaderSuccess, updateRegionLeaderError, getRegionLeaderSuccess, getRegionLeaderError,
} from './actions';

import { selectCustomText } from 'containers/Shared/App/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';
import { customTexts } from 'utils/customTextHelpers';

export function* getRegionLeaders(action) {
  const customText = yield select(selectCustomText());
  try {
    const response = yield call(api.regionLeaders.all.bind(api.regionLeaders), action.payload);
    yield put(getRegionLeadersSuccess(response.data.page));
  } catch (err) {
    yield put(getRegionLeadersError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.leaders, customText), options: { variant: 'warning' } }));
  }
}

export function* getRegionLeader(action) {
  const customText = yield select(selectCustomText());
  try {
    const response = yield call(api.regionLeaders.get.bind(api.regionLeaders), action.payload.id);
    yield put(getRegionLeaderSuccess(response.data));
  } catch (err) {
    yield put(getRegionLeaderError(err));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.leader, customText),
      options: { variant: 'warning' }
    }));
  }
}

export function* createRegionLeader(action) {
  const customText = yield select(selectCustomText());
  try {
    const payload = { region_leader: action.payload };
    const response = yield call(api.regionLeaders.create.bind(api.regionLeaders), payload);
    yield put(createRegionLeaderSuccess());
    yield put(push(ROUTES.region.leaders.index.path(action.payload.region_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create, customText), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createRegionLeaderError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create, customText), options: { variant: 'warning' } }));
  }
}

export function* deleteRegionLeader(action) {
  const customText = yield select(selectCustomText());
  try {
    yield call(api.regionLeaders.destroy.bind(api.regionLeaders), action.payload.id);
    yield put(deleteRegionLeaderSuccess());
    yield put(getRegionLeadersBegin({ region_id: action.payload.region_id }));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete, customText), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteRegionLeaderError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete, customText), options: { variant: 'warning' } }));
  }
}

export function* updateRegionLeader(action) {
  const customText = yield select(selectCustomText());
  try {
    const payload = { region_leader: action.payload };
    const response = yield call(api.regionLeaders.update.bind(api.regionLeaders), payload.region_leader.id, payload);
    yield put(updateRegionLeaderSuccess());
    yield put(push(ROUTES.region.leaders.index.path(action.payload.region_id)));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.success.update, customText),
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateRegionLeaderError(err));

    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.update, customText),
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
