import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_BUDGET_ITEM_BEGIN,
  GET_BUDGET_ITEMS_BEGIN,
} from './constants';

import {
  getBudgetItemSuccess, getBudgetItemError,
  getBudgetItemsSuccess, getBudgetItemsError,
} from './actions';

export function* getBudgetItem(action) {
  try {
    const response = yield call(api.budgetItems.get.bind(api.budgetItems), action.payload.id);

    yield put(getBudgetItemSuccess(response.data));
  } catch (err) {
    yield put(getBudgetItemError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get budget item', options: { variant: 'warning' } }));
  }
}

export function* getBudgetItems(action) {
  try {
    const response = yield call(api.budgetItems.all.bind(api.budgetItems), action.payload);

    yield put(getBudgetItemsSuccess(response.data.page));
  } catch (err) {
    yield put(getBudgetItemsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get budget items', options: { variant: 'warning' } }));
  }
}


export default function* BudgetItemSaga() {
  yield takeLatest(GET_BUDGET_ITEM_BEGIN, getBudgetItem);
  yield takeLatest(GET_BUDGET_ITEMS_BEGIN, getBudgetItems);
}
