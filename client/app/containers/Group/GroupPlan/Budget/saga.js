import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_BUDGET_BEGIN,
  GET_BUDGETS_BEGIN,
  CREATE_BUDGET_REQUEST_BEGIN,
  APPROVE_BUDGET_BEGIN,
  DECLINE_BUDGET_BEGIN,
  DELETE_BUDGET_BEGIN,
} from './constants';

import {
  getBudgetSuccess, getBudgetError,
  getBudgetsSuccess, getBudgetsError,
  createBudgetRequestSuccess, createBudgetRequestError,
  approveBudgetSuccess, approveBudgetError,
  declineBudgetSuccess, declineBudgetError,
  deleteBudgetSuccess, deleteBudgetError,
} from './actions';

export function* getBudget(action) {
  try {
    const response = yield call(api.budgets.get.bind(api.budgets), action.payload.id);

    yield put(getBudgetSuccess(response.data));
  } catch (err) {
    yield put(getBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get budget', options: { variant: 'warning' } }));
  }
}

export function* getBudgets(action) {
  try {
    const response = yield call(api.budgets.all.bind(api.budgets), action.payload);

    yield put(getBudgetsSuccess(response.data.page));
  } catch (err) {
    yield put(getBudgetsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get budgets', options: { variant: 'warning' } }));
  }
}

export function* createBudgetRequest(action) {
  try {
    const { path, groupId, ...rest } = action.payload;
    const payload = { group_id: groupId, budget: rest };
    const response = yield call(api.budgets.create.bind(api.budgets), payload);

    yield put(createBudgetRequestSuccess({}));
    yield put(push(path));
    yield put(showSnackbar({ message: 'Successfully created budget request', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createBudgetRequestError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create budget request', options: { variant: 'warning' } }));
  }
}

export function* approveBudget(action) {
  try {
    const { id } = action.payload;
    const response = yield call(api.budgets.approve.bind(api.budgets), id);

    yield put(approveBudgetSuccess(response.data));
    yield put(showSnackbar({ message: 'Successfully approved budget', options: { variant: 'success' } }));
  } catch (err) {
    yield put(approveBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to approve budget', options: { variant: 'warning' } }));
  }
}

export function* declineBudget(action) {
  try {
    const payload = { budget: action.payload };
    const response = yield call(api.budgets.reject.bind(api.budgets), payload.budget.id, payload);

    yield put(declineBudgetSuccess(response.data));
    yield put(showSnackbar({ message: 'Successfully declined budget', options: { variant: 'success' } }));
  } catch (err) {
    yield put(declineBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to decline budget', options: { variant: 'warning' } }));
  }
}

export function* deleteBudget(action) {
  try {
    const { id } = action.payload;
    yield call(api.budgets.destroy.bind(api.budgets), id);

    yield put(deleteBudgetSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted budget', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteBudgetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete budget', options: { variant: 'warning' } }));
  }
}


export default function* BudgetSaga() {
  yield takeLatest(GET_BUDGET_BEGIN, getBudget);
  yield takeLatest(GET_BUDGETS_BEGIN, getBudgets);
  yield takeLatest(CREATE_BUDGET_REQUEST_BEGIN, createBudgetRequest);
  yield takeLatest(APPROVE_BUDGET_BEGIN, approveBudget);
  yield takeLatest(DECLINE_BUDGET_BEGIN, declineBudget);
  yield takeLatest(DELETE_BUDGET_BEGIN, deleteBudget);
}
