import { all, call, put, takeLatest, takeEvery } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import messages from './messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

import {
  GET_REGIONS_BEGIN,
  GET_REGION_BEGIN,
  CREATE_REGION_BEGIN,
  UPDATE_REGION_BEGIN,
  DELETE_REGION_BEGIN,
} from './constants';

import {
  getRegionsSuccess, getRegionsError,
  getRegionSuccess, getRegionError,
  createRegionSuccess, createRegionError,
  updateRegionSuccess, updateRegionError,
  deleteRegionSuccess, deleteRegionError,
} from 'containers/Region/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';


export function* getRegions(action) {
  try {
    const response = yield call(api.regions.all.bind(api.regions), action.payload);
    yield put(getRegionsSuccess(response.data.page));
  } catch (err) {
    yield put(getRegionsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.regions), options: { variant: 'warning' } }));
  }
}

export function* getRegion(action) {
  try {
    const response = yield call(api.regions.get.bind(api.regions), action.payload.id);
    yield put(getRegionSuccess(response.data));
  } catch (err) {
    yield put(getRegionError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.region), options: { variant: 'warning' } }));
  }
}

export function* createRegion(action) {
  try {
    const payload = { region: action.payload };
    const response = yield call(api.regions.create.bind(api.regions), payload);

    yield put(createRegionSuccess());
    // yield put(push(ROUTES.region.home.path(response.data.region.id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createRegionError(err));
    // yield put(push(ROUTES.admin.manage.regions.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create), options: { variant: 'warning' } }));
  }
}

export function* updateRegion(action) {
  try {
    const payload = { region: action.payload };
    const response = yield call(api.regions.update.bind(api.regions), payload.region.id, payload);

    yield put(updateRegionSuccess());
    // yield put(push(ROUTES.admin.manage.regions.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateRegionError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'warning' } }));
  }
}

export function* deleteRegion(action) {
  try {
    yield call(api.regions.destroy.bind(api.regions), action.payload);

    yield put(deleteRegionSuccess());
    // yield put(push(ROUTES.admin.manage.regions.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteRegionError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}


export default function* regionsSaga() {
  yield takeLatest(GET_REGIONS_BEGIN, getRegions);
  yield takeLatest(GET_REGION_BEGIN, getRegion);
  yield takeLatest(CREATE_REGION_BEGIN, createRegion);
  yield takeLatest(UPDATE_REGION_BEGIN, updateRegion);
  yield takeLatest(DELETE_REGION_BEGIN, deleteRegion);
}
