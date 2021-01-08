import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

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
    yield put(showSnackbar({ message: messages.snackbars.errors.budget, options: { variant: 'warning' } }));
  }
}

export function* getBudgets(action) {
  try {
    const response = yield call(api.budgets.all.bind(api.budgets), action.payload);

    yield put(getBudgetsSuccess(response.data.page));
  } catch (err) {
    yield put(getBudgetsError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.budgets, options: { variant: 'warning' } }));
  }
}

export function* createBudgetRequest(action) {
  try {
    const { path, groupId, ...rest } = action.payload;
    const payload = { budget: { group_id: groupId, ...rest } };
    const response = yield call(api.budgets.create.bind(api.budgets), payload);

    yield put(createBudgetRequestSuccess());
    yield put(push(path));
    yield put(showSnackbar({ message: messages.snackbars.success.budget_request, options: { variant: 'success' } }));
  } catch (err) {
    yield put(createBudgetRequestError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.budget_request, options: { variant: 'warning' } }));
  }
}

export function* approveBudget(action) {
  try {
    const { id } = action.payload;
    const response = yield call(api.budgets.approve.bind(api.budgets), id);

    yield put(approveBudgetSuccess(response.data));
    yield put(showSnackbar({ message: messages.snackbars.success.approve, options: { variant: 'success' } }));
  } catch (err) {
    yield put(approveBudgetError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.approve, options: { variant: 'warning' } }));
  }
}

export function* declineBudget(action) {
  try {
    const payload = { budget: action.payload };
    const response = yield call(api.budgets.reject.bind(api.budgets), payload.budget.id, payload);

    yield put(declineBudgetSuccess(response.data));
    yield put(showSnackbar({ message: messages.snackbars.success.decline, options: { variant: 'success' } }));
  } catch (err) {
    yield put(declineBudgetError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.decline, options: { variant: 'warning' } }));
  }
}

export function* deleteBudget(action) {
  try {
    const { id } = action.payload;
    yield call(api.budgets.destroy.bind(api.budgets), id);

    yield put(deleteBudgetSuccess());
    yield put(showSnackbar({ message: messages.snackbars.success.delete, options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteBudgetError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } }));
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
