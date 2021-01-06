import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_BUDGET_USERS_BEGIN, FINALIZE_EXPENSES_BEGIN
} from './constants';

import {
  getBudgetUsersSuccess, getBudgetUsersError,
  finalizeExpensesError, finalizeExpensesSuccess
} from './actions';

export function* getBudgetUsers(action) {
  try {
    const response = yield call(api.budgetUsers.all.bind(api.budgetUsers), action.payload);

    yield put(getBudgetUsersSuccess(response.data.page));
  } catch (err) {
    yield put(getBudgetUsersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get budget users', options: { variant: 'warning' } }));
  }
}

export function* finalizeExpenses(action) {
  try {
    const response = yield call(api.budgetUsers.finalizeExpenses.bind(api.budgetUsers), action.payload.id);
    yield put(finalizeExpensesSuccess(response.data));
    yield put(showSnackbar({ message: 'Successfully finalized budget item use', options: { variant: 'success' } }));
  } catch (err) {
    yield put(finalizeExpensesError(err));

    yield put(showSnackbar({ message: 'Failed to finalize budget item use', options: { variant: 'warning' } }));
  }
}


export default function* BudgetUserSaga() {
  yield takeLatest(GET_BUDGET_USERS_BEGIN, getBudgetUsers);
  yield takeLatest(FINALIZE_EXPENSES_BEGIN, finalizeExpenses);
}
