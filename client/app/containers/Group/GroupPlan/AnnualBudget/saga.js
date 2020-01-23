import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_CURRENT_ANNUAL_BUDGET_BEGIN,
  GET_ANNUAL_BUDGET_BEGIN,
  GET_ANNUAL_BUDGETS_BEGIN,
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

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get current annual budget', options: { variant: 'warning' } }));
  }
}

export function* getAnnualBudget(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getAnnualBudgetSuccess(response.data));
  } catch (err) {
    yield put(getAnnualBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get annual budget', options: { variant: 'warning' } }));
  }
}

export function* getAnnualBudgets(action) {
  try {
    const response = yield call(api.annualBudgets.all.bind(api.annualBudgets), action.payload);

    yield put(getAnnualBudgetsSuccess(response.data.page));
  } catch (err) {
    yield put(getAnnualBudgetsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get annual budgets', options: { variant: 'warning' } }));
  }
}

export function* createAnnualBudget(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createAnnualBudgetSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created annual budget', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createAnnualBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create annual budget', options: { variant: 'warning' } }));
  }
}

export function* updateAnnualBudget(action) {
  try {
    const payload = { annual_budget: action.payload };
    const response = yield call(api.annualBudgets.update.bind(api.annualBudgets), payload.annual_budget.id, payload);

    yield put(updateAnnualBudgetSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated annual budget', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateAnnualBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update annual budget', options: { variant: 'warning' } }));
  }
}


export default function* AnnualBudgetSaga() {
  yield takeLatest(GET_CURRENT_ANNUAL_BUDGET_BEGIN, getCurrentAnnualBudget);
  yield takeLatest(GET_ANNUAL_BUDGET_BEGIN, getAnnualBudget);
  yield takeLatest(GET_ANNUAL_BUDGETS_BEGIN, getAnnualBudgets);
  yield takeLatest(CREATE_ANNUAL_BUDGET_BEGIN, createAnnualBudget);
  yield takeLatest(UPDATE_ANNUAL_BUDGET_BEGIN, updateAnnualBudget);
}
