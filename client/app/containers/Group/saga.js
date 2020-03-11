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
  CARRY_BUDGET_BEGIN,
  RESET_BUDGET_BEGIN,
} from './constants';

import {
  getGroupsSuccess, getGroupsError,
  getAnnualBudgetsSuccess, getAnnualBudgetsError,
  getGroupSuccess, getGroupError,
  createGroupSuccess, createGroupError,
  updateGroupSuccess, updateGroupError,
  updateGroupSettingsSuccess, updateGroupSettingsError,
  deleteGroupSuccess, deleteGroupError,
  carryBudgetSuccess, carryBudgetError,
  resetBudgetSuccess, resetBudgetError,
} from './actions';

export function* getGroups(action) {
  try {
    const response = yield call(api.groups.all.bind(api.groups), action.payload);

    yield put(getGroupsSuccess(response.data.page));
  } catch (err) {
    yield put(getGroupsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load groups', options: { variant: 'warning' } }));
  }
}

export function* getAnnualBudgets(action) {
  try {
    const response = yield call(api.groups.annualBudgets.bind(api.groups), action.payload);

    yield put(getAnnualBudgetsSuccess(response.data.page));
  } catch (err) {
    yield put(getAnnualBudgetsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get annual budgets', options: { variant: 'warning' } }));
  }
}

export function* getGroup(action) {
  try {
    const response = yield call(api.groups.get.bind(api.groups), action.payload.id);
    yield put(getGroupSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getGroupError(err));
    yield put(showSnackbar({ message: 'Failed to get group', options: { variant: 'warning' } }));
  }
}


export function* createGroup(action) {
  try {
    const payload = { group: action.payload };

    // TODO: use bind here or no?
    const response = yield call(api.groups.create.bind(api.groups), payload);

    yield put(createGroupSuccess());
    yield put(push(ROUTES.admin.manage.groups.index.path()));
    yield put(showSnackbar({ message: 'Group created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create group', options: { variant: 'warning' } }));
  }
}

export function* updateGroup(action) {
  try {
    const payload = { group: action.payload };
    const response = yield call(api.groups.update.bind(api.groups), payload.group.id, payload);

    yield put(updateGroupSuccess());
    yield put(push(ROUTES.admin.manage.groups.index.path()));
    yield put(showSnackbar({ message: 'Group updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update group', options: { variant: 'warning' } }));
  }
}

export function* updateGroupSettings(action) {
  try {
    const payload = { group: action.payload };
    const response = yield call(api.groups.update.bind(api.groups), payload.group.id, payload);

    yield put(updateGroupSettingsSuccess({ group: response.data.group }));
    yield put(push(ROUTES.group.home.path(response.data.group.id)));
    yield put(showSnackbar({
      message: 'Group settings updated',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateGroupSettingsError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to update group settings',
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteGroup(action) {
  try {
    yield call(api.groups.destroy.bind(api.groups), action.payload);
    yield put(push(ROUTES.admin.manage.groups.index.path()));
    yield put(showSnackbar({ message: 'Group deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete group', options: { variant: 'warning' } }));
  }
}

export function* carryBudget(action) {
  try {
    yield call(api.groups.carryoverBudget.bind(api.groups), action.payload);

    yield put(carryBudgetSuccess({}));
    yield put(showSnackbar({ message: 'Successfully carried over the budget', options: { variant: 'success' } }));
  } catch (err) {
    yield put(carryBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to carry over the budget', options: { variant: 'warning' } }));
  }
}

export function* resetBudget(action) {
  try {
    yield call(api.groups.resetBudget.bind(api.groups), action.payload);

    yield put(resetBudgetSuccess({}));
    yield put(showSnackbar({ message: 'Successfully reset budget', options: { variant: 'success' } }));
  } catch (err) {
    yield put(resetBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to reset budget', options: { variant: 'warning' } }));
  }
}


export default function* groupsSaga() {
  yield takeLatest(GET_GROUPS_BEGIN, getGroups);
  yield takeLatest(GET_ANNUAL_BUDGETS_BEGIN, getAnnualBudgets);
  yield takeLatest(GET_GROUP_BEGIN, getGroup);
  yield takeLatest(CREATE_GROUP_BEGIN, createGroup);
  yield takeLatest(UPDATE_GROUP_BEGIN, updateGroup);
  yield takeLatest(UPDATE_GROUP_SETTINGS_BEGIN, updateGroupSettings);
  yield takeLatest(DELETE_GROUP_BEGIN, deleteGroup);
  yield takeLatest(CARRY_BUDGET_BEGIN, carryBudget);
  yield takeLatest(RESET_BUDGET_BEGIN, resetBudget);
}