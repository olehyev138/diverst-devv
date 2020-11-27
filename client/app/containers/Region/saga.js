import { call, put, takeLatest, select } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import messages from './messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

import {
  GET_REGIONS_BEGIN,
  GET_GROUP_REGIONS_BEGIN,
  GET_REGION_MEMBERS_BEGIN,
  GET_REGION_BEGIN,
  CREATE_REGION_BEGIN,
  UPDATE_REGION_BEGIN,
  DELETE_REGION_BEGIN,
} from './constants';

import {
  getRegionsSuccess, getRegionsError,
  getGroupRegionsBegin, getGroupRegionsSuccess, getGroupRegionsError,
  getRegionMembersSuccess, getRegionMembersError,
  getRegionSuccess, getRegionError,
  createRegionSuccess, createRegionError,
  updateRegionSuccess, updateRegionError,
  deleteRegionSuccess, deleteRegionError,
} from 'containers/Region/actions';

import { selectCustomText } from 'containers/Shared/App/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';
import { customTexts } from 'utils/customTextHelpers';


export function* getRegions(action) {
  const customText = yield select(selectCustomText());
  try {
    const response = yield call(api.regions.all.bind(api.regions), action.payload);
    yield put(getRegionsSuccess(response.data.page));
  } catch (err) {
    yield put(getRegionsError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.regions, options: { variant: 'warning' } }));
  }
}

export function* getGroupRegions(action) {
  const customText = yield select(selectCustomText());
  try {
    const response = yield call(api.regions.groupRegions.bind(api.regions), action.payload);
    yield put(getGroupRegionsSuccess(response.data.page));
  } catch (err) {
    yield put(getGroupRegionsError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.regions, options: { variant: 'warning' } }));
  }
}

export function* getRegion(action) {
  const customText = yield select(selectCustomText());
  try {
    const response = yield call(api.regions.get.bind(api.regions), action.payload.id);
    yield put(getRegionSuccess(response.data));
  } catch (err) {
    yield put(getRegionError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.region, options: { variant: 'warning' } }));
  }
}

export function* createRegion(action) {
  const customText = yield select(selectCustomText());
  try {
    const payload = { region: action.payload };
    const response = yield call(api.regions.create.bind(api.regions), payload);

    yield put(createRegionSuccess());
    yield put(push(ROUTES.admin.manage.groups.regions.index.path(action.payload.parent_id)));
    yield put(showSnackbar({ message: messages.snackbars.success.create, options: { variant: 'success' } }));
  } catch (err) {
    yield put(createRegionError(err));
    yield put(push(ROUTES.admin.manage.groups.regions.index.path(action.payload.parent_id)));
    yield put(showSnackbar({ message: messages.snackbars.errors.create, options: { variant: 'warning' } }));
  }
}

export function* updateRegion(action) {
  const customText = yield select(selectCustomText());
  try {
    const payload = { region: action.payload };
    const response = yield call(api.regions.update.bind(api.regions), payload.region.id, payload);

    yield put(updateRegionSuccess());
    yield put(push(ROUTES.admin.manage.groups.regions.index.path(action.payload.parent_id)));
    yield put(showSnackbar({ message: messages.snackbars.success.update, options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateRegionError(err));
    yield put(push(ROUTES.admin.manage.groups.regions.index.path(action.payload.parent_id)));
    yield put(showSnackbar({ message: messages.snackbars.errors.update, options: { variant: 'warning' } }));
  }
}

export function* deleteRegion(action) {
  const customText = yield select(selectCustomText());
  try {
    yield call(api.regions.destroy.bind(api.regions), action.payload.region_id);

    yield put(deleteRegionSuccess());
    yield put(getGroupRegionsBegin({ group_id: action.payload.group_id }));
    yield put(showSnackbar({ message: messages.snackbars.success.delete, options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteRegionError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } }));
  }
}

export function* getMembers(action) {
  const customText = yield select(selectCustomText());
  try {
    const response = yield call(api.regions.members.bind(api.regions), action.payload.id, action.payload);
    yield put(getRegionMembersSuccess(response.data.page));
  } catch (err) {
    yield put(getRegionMembersError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.members, options: { variant: 'warning' } }));
  }
}


export default function* regionsSaga() {
  yield takeLatest(GET_REGIONS_BEGIN, getRegions);
  yield takeLatest(GET_GROUP_REGIONS_BEGIN, getGroupRegions);
  yield takeLatest(GET_REGION_MEMBERS_BEGIN, getMembers);
  yield takeLatest(GET_REGION_BEGIN, getRegion);
  yield takeLatest(CREATE_REGION_BEGIN, createRegion);
  yield takeLatest(UPDATE_REGION_BEGIN, updateRegion);
  yield takeLatest(DELETE_REGION_BEGIN, deleteRegion);
}
