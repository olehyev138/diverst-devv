import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_CURRENT_ANNUAL_BUDGET_BEGIN,
  GET_ANNUAL_BUDGET_BEGIN,
  GET_ANNUAL_BUDGETS_BEGIN,
  GET_CHILD_BUDGETS_BEGIN,
  CREATE_ANNUAL_BUDGET_BEGIN,
  UPDATE_ANNUAL_BUDGET_BEGIN,
} from './constants';

import {
  getCurrentAnnualBudgetSuccess, getCurrentAnnualBudgetError,
  getAnnualBudgetSuccess, getAnnualBudgetError,
  getAnnualBudgetsSuccess, getAnnualBudgetsError,
  createAnnualBudgetSuccess, createAnnualBudgetError,
  updateAnnualBudgetSuccess, updateAnnualBudgetError,
} from './actions';

export function* getCurrentAnnualBudget(action) {
  try {
    const { groupId, ...rest } = action.payload;
    const response = yield call(api.groups.currentAnnualBudget.bind(api.groups), groupId, rest);

    yield put(getCurrentAnnualBudgetSuccess(response.data));
  } catch (err) {
    yield put(getCurrentAnnualBudgetError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.currentAnnualBudget), options: { variant: 'warning' } }));
  }
}

export function* getAnnualBudget(action) {
  try {
    const response = yield call(api.annualBudgets.get.bind(api.annualBudgets), action.payload.id);

    yield put(getAnnualBudgetSuccess(response.data));
  } catch (err) {
    yield put(getAnnualBudgetError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.annualBudget), options: { variant: 'warning' } }));
  }
}

export function* getAnnualBudgets(action) {
  try {
    const response = yield call(api.annualBudgets.all.bind(api.annualBudgets), action.payload);

    yield put(getAnnualBudgetsSuccess(response.data.page));
  } catch (err) {
    yield put(getAnnualBudgetsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.annualBudgets), options: { variant: 'warning' } }));
  }
}

export function* getChildBudgets(action) {
  try {
    const { groupId, ...payload } = action.payload;
    const response = yield call(api.groups.currentChildBudgets.bind(api.groups), groupId, payload);

    yield put(getAnnualBudgetsSuccess(response.data.page));
  } catch (err) {
    yield put(getAnnualBudgetsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.annualBudgets), options: { variant: 'warning' } }));
  }
}

export function* updateAnnualBudget(action) {
  try {
    const payload = { annual_budget: action.payload };
    const response = yield call(api.annualBudgets.update.bind(api.annualBudgets), payload.annual_budget.id, payload);

    yield put(updateAnnualBudgetSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateAnnualBudgetError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'warning' } }));
  }
}


export default function* annualBudgetSaga() {
  yield takeLatest(GET_CURRENT_ANNUAL_BUDGET_BEGIN, getCurrentAnnualBudget);
  yield takeLatest(GET_ANNUAL_BUDGET_BEGIN, getAnnualBudget);
  yield takeLatest(GET_ANNUAL_BUDGETS_BEGIN, getAnnualBudgets);
  yield takeLatest(GET_CHILD_BUDGETS_BEGIN, getChildBudgets);
  yield takeLatest(UPDATE_ANNUAL_BUDGET_BEGIN, updateAnnualBudget);
}
