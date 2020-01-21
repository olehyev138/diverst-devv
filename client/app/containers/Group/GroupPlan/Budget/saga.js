import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  UPDATE_ANNUAL_BUDGET_BEGIN,
  CREATE_BUDGET_BEGIN,
  UPDATE_BUDGET_BEGIN,
  DELETE_BUDGET_BEGIN,
} from './constants';

import {
  updateAnnualBudgetSuccess, updateAnnualBudgetError,
  createBudgetSuccess, createBudgetError,
  updateBudgetSuccess, updateBudgetError,
  deleteBudgetSuccess, deleteBudgetError,
} from './actions';

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

export function* createBudget(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createBudgetSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created budget', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create budget', options: { variant: 'warning' } }));
  }
}

export function* updateBudget(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(updateBudgetSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated budget', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update budget', options: { variant: 'warning' } }));
  }
}

export function* deleteBudget(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deleteBudgetSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted budget', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete budget', options: { variant: 'warning' } }));
  }
}


export default function* BudgetSaga() {
  yield takeLatest(UPDATE_ANNUAL_BUDGET_BEGIN, updateAnnualBudget);
  yield takeLatest(CREATE_BUDGET_BEGIN, createBudget);
  yield takeLatest(UPDATE_BUDGET_BEGIN, updateBudget);
  yield takeLatest(DELETE_BUDGET_BEGIN, deleteBudget);
}
