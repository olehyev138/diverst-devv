import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_BUDGET_USERS_BEGIN,
} from './constants';

import {
  getBudgetUsersSuccess, getBudgetUsersError,
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


export default function* BudgetUserSaga() {
  yield takeLatest(GET_BUDGET_USERS_BEGIN, getBudgetUsers);
}
