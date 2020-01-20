import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_GROUPS_BEGIN,
  GET_ANNUAL_BUDGETS_BEGIN,
  GET_GROUP_BEGIN,
  CREATE_GROUP_BEGIN,
  UPDATE_GROUP_BEGIN,
  UPDATE_GROUP_SETTINGS_BEGIN,
  DELETE_GROUP_BEGIN,
} from './constants';

import {
  getGroupsSuccess, getGroupsError,
  getAnnualBudgetsSuccess, getAnnualBudgetsError,
  getGroupSuccess, getGroupError,
  createGroupSuccess, createGroupError,
  updateGroupSuccess, updateGroupError,
  updateGroupSettingsSuccess, updateGroupSettingsError,
  deleteGroupSuccess, deleteGroupError,
} from './actions';

export function* getGroups(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getGroupsSuccess(response.data.page));
  } catch (err) {
    yield put(getGroupsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get groups', options: { variant: 'warning' } }));
  }
}

export function* getAnnualBudgets(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getAnnualBudgetsSuccess(response.data.page));
  } catch (err) {
    yield put(getAnnualBudgetsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get annual budgets', options: { variant: 'warning' } }));
  }
}

export function* getGroup(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getGroupSuccess(response.data));
  } catch (err) {
    yield put(getGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get group', options: { variant: 'warning' } }));
  }
}

export function* createGroup(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createGroupSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created group', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create group', options: { variant: 'warning' } }));
  }
}

export function* updateGroup(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(updateGroupSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated group', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update group', options: { variant: 'warning' } }));
  }
}

export function* updateGroupSettings(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(updateGroupSettingsSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated group settings', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateGroupSettingsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update group settings', options: { variant: 'warning' } }));
  }
}

export function* deleteGroup(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deleteGroupSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted group', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete group', options: { variant: 'warning' } }));
  }
}


export default function* GroupSaga() {
  yield takeLatest(GET_GROUPS_BEGIN, getGroups);
  yield takeLatest(GET_ANNUAL_BUDGETS_BEGIN, getAnnualBudgets);
  yield takeLatest(GET_GROUP_BEGIN, getGroup);
  yield takeLatest(CREATE_GROUP_BEGIN, createGroup);
  yield takeLatest(UPDATE_GROUP_BEGIN, updateGroup);
  yield takeLatest(UPDATE_GROUP_SETTINGS_BEGIN, updateGroupSettings);
  yield takeLatest(DELETE_GROUP_BEGIN, deleteGroup);
}
