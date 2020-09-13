import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_EXPENSE_BEGIN,
  GET_EXPENSES_BEGIN,
  CREATE_EXPENSE_BEGIN,
  UPDATE_EXPENSE_BEGIN,
  DELETE_EXPENSE_BEGIN,
} from './constants';

import {
  getExpenseSuccess, getExpenseError,
  getExpensesSuccess, getExpensesError,
  createExpenseSuccess, createExpenseError,
  updateExpenseSuccess, updateExpenseError,
  deleteExpenseSuccess, deleteExpenseError,
} from './actions';

export function* getExpense(action) {
  try {
    const response = yield call(api.initiativeExpenses.get.bind(api.initiativeExpenses), action.payload.id);

    yield put(getExpenseSuccess(response.data));
  } catch (err) {
    yield put(getExpenseError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.expense), options: { variant: 'warning' } }));
  }
}

export function* getExpenses(action) {
  try {
    const response = yield call(api.initiativeExpenses.all.bind(api.initiativeExpenses), action.payload);

    yield put(getExpensesSuccess(response.data.page));
  } catch (err) {
    yield put(getExpensesError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.expenses), options: { variant: 'warning' } }));
  }
}

export function* createExpense(action) {
  try {
    const { path, ...rest } = action.payload;
    const payload = { initiative_expense: rest };

    const response = yield call(api.initiativeExpenses.create.bind(api.initiativeExpenses), payload);

    yield put(createExpenseSuccess(response.data));
    yield put(push(path));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createExpenseError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create), options: { variant: 'warning' } }));
  }
}

export function* updateExpense(action) {
  try {
    const { path, id, ...rest } = action.payload;
    const payload = { initiative_expense: rest };

    const response = yield call(api.initiativeExpenses.update.bind(api.initiativeExpenses), id, payload);

    yield put(updateExpenseSuccess());
    yield put(push(path));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateExpenseError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'warning' } }));
  }
}

export function* deleteExpense(action) {
  try {
    const response = yield call(api.initiativeExpenses.destroy.bind(api.initiativeExpenses), action.payload.id);

    yield put(deleteExpenseSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteExpenseError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}


export default function* ExpenseSaga() {
  yield takeLatest(GET_EXPENSE_BEGIN, getExpense);
  yield takeLatest(GET_EXPENSES_BEGIN, getExpenses);
  yield takeLatest(CREATE_EXPENSE_BEGIN, createExpense);
  yield takeLatest(UPDATE_EXPENSE_BEGIN, updateExpense);
  yield takeLatest(DELETE_EXPENSE_BEGIN, deleteExpense);
}