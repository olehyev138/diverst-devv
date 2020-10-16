import { all, call, put, takeLatest, takeEvery } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import messages from './messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

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
  JOIN_GROUP_BEGIN,
  LEAVE_GROUP_BEGIN,
  GROUP_CATEGORIZE_BEGIN,
  UPDATE_GROUP_POSITION_BEGIN,
  JOIN_SUBGROUPS_BEGIN,
  GET_COLORS_BEGIN
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
  leaveGroupSuccess, leaveGroupError,
  joinGroupSuccess, joinGroupError,
  updateGroupPositionSuccess, updateGroupPositionError,
  groupCategorizeSuccess, groupCategorizeError,
  joinSubgroupsSuccess, joinSubgroupsError,
  getColorsError, getColorsSuccess,
} from 'containers/Group/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';


export function* getGroups(action) {
  try {
    const response = yield call(api.groups.all.bind(api.groups), action.payload);
    yield put(getGroupsSuccess(response.data.page));
  } catch (err) {
    yield put(getGroupsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.groups), options: { variant: 'warning' } }));
  }
}

export function* getColors(action) {
  try {
    const response = yield call(api.groups.colors.bind(api.groups));

    yield put(getColorsSuccess(response.data));
  } catch (err) {
    yield put(getColorsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.colors), options: { variant: 'warning' } }));
  }
}

export function* getAnnualBudgets(action) {
  try {
    const response = yield call(api.groups.annualBudgets.bind(api.groups), action.payload);

    yield put(getAnnualBudgetsSuccess(response.data.page));
  } catch (err) {
    yield put(getAnnualBudgetsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.annualBudgets), options: { variant: 'warning' } }));
  }
}

export function* getGroup(action) {
  try {
    const response = yield call(api.groups.get.bind(api.groups), action.payload.id);
    yield put(getGroupSuccess(response.data));
  } catch (err) {
    yield put(getGroupError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.group), options: { variant: 'warning' } }));
  }
}


export function* createGroup(action) {
  try {
    const payload = { group: action.payload };
    // TODO: use bind here or no?
    const response = yield call(api.groups.create.bind(api.groups), payload);

    yield put(createGroupSuccess());
    yield put(push(ROUTES.group.home.path(response.data.group.id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupError(err));
    yield put(push(ROUTES.admin.manage.groups.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create), options: { variant: 'warning' } }));
  }
}

export function* categorizeGroup(action) {
  try {
    const response = yield call(api.groups.updateCategories.bind(api.groups), action.payload.id, action.payload);

    yield put(groupCategorizeSuccess());
    yield put(push(ROUTES.admin.manage.groups.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.group_categorize), options: { variant: 'success' } }));
  } catch (err) {
    yield put(groupCategorizeError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.group_categorize), options: { variant: 'warning' } }));
  }
}

export function* updateGroup(action) {
  try {
    const payload = { group: action.payload };
    const response = yield call(api.groups.update.bind(api.groups), payload.group.id, payload);

    yield put(updateGroupSuccess());
    yield put(push(ROUTES.admin.manage.groups.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateGroupError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'warning' } }));
  }
}

export function* updateGroupPosition(action) {
  try {
    const payload = { group: { id: action.payload.id, position: action.payload.position } };
    yield call(api.groups.update.bind(api.groups), payload.group.id, payload.group);

    yield put(updateGroupPositionSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update_group_position), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateGroupPositionError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update_group_position), options: { variant: 'warning' } }));
  }
}

export function* updateGroupSettings(action) {
  try {
    const payload = { group: action.payload };

    const response = yield call(api.groups.update.bind(api.groups), payload.group.id, payload);

    yield put(updateGroupSettingsSuccess({ group: response.data.group }));
    yield put(push(ROUTES.group.home.path(response.data.group.id)));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.success.update_group_settings),
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateGroupSettingsError(err));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.update_group_settings),
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteGroup(action) {
  try {
    yield call(api.groups.destroy.bind(api.groups), action.payload);
    yield put(deleteGroupSuccess());
    yield put(push(ROUTES.admin.manage.groups.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}

export function* carryBudget(action) {
  try {
    yield call(api.groups.carryoverBudget.bind(api.groups), action.payload);

    yield put(carryBudgetSuccess({}));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.carry), options: { variant: 'success' } }));
  } catch (err) {
    yield put(carryBudgetError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.carry), options: { variant: 'warning' } }));
  }
}

export function* resetBudget(action) {
  try {
    yield call(api.groups.resetBudget.bind(api.groups), action.payload);

    yield put(resetBudgetSuccess({}));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.reset), options: { variant: 'success' } }));
  } catch (err) {
    yield put(resetBudgetError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.reset), options: { variant: 'warning' } }));
  }
}

export function* joinGroup(action) {
  const payload = { user_group: action.payload };
  try {
    const response = yield call(api.userGroups.join.bind(api.userGroups), payload);
    yield put(joinGroupSuccess());
  } catch (err) {
    yield put(joinGroupError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.join), options: { variant: 'warning' } }));
  }
}

export function* leaveGroup(action) {
  const payload = { user_group: action.payload };
  try {
    const response = yield call(api.userGroups.leave.bind(api.userGroups), payload);

    yield put(leaveGroupSuccess());
  } catch (err) {
    yield put(leaveGroupError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.leave), options: { variant: 'warning' } }));
  }
}

export function* joinSubgroups(action) {
  try {
    const response = yield call(api.userGroups.joinSubgroups.bind(api.userGroups), action.payload);
    yield put(joinSubgroupsSuccess());
  } catch (err) {
    yield put(joinSubgroupsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.join_subgroups), options: { variant: 'warning' } }));
  }
}


export default function* groupsSaga() {
  yield takeLatest(GET_GROUPS_BEGIN, getGroups);
  yield takeLatest(GET_COLORS_BEGIN, getColors);
  yield takeLatest(GET_ANNUAL_BUDGETS_BEGIN, getAnnualBudgets);
  yield takeLatest(GET_GROUP_BEGIN, getGroup);
  yield takeLatest(CREATE_GROUP_BEGIN, createGroup);
  yield takeLatest(UPDATE_GROUP_BEGIN, updateGroup);
  yield takeLatest(UPDATE_GROUP_SETTINGS_BEGIN, updateGroupSettings);
  yield takeEvery(UPDATE_GROUP_POSITION_BEGIN, updateGroupPosition);
  yield takeLatest(DELETE_GROUP_BEGIN, deleteGroup);
  yield takeLatest(CARRY_BUDGET_BEGIN, carryBudget);
  yield takeLatest(RESET_BUDGET_BEGIN, resetBudget);
  yield takeLatest(JOIN_GROUP_BEGIN, joinGroup);
  yield takeLatest(LEAVE_GROUP_BEGIN, leaveGroup);
  yield takeLatest(GROUP_CATEGORIZE_BEGIN, categorizeGroup);
  yield takeLatest(JOIN_SUBGROUPS_BEGIN, joinSubgroups);
}
