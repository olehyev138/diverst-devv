import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';


import {
  GET_GROUP_CATEGORIES_BEGIN
} from 'containers/Group/GroupCategories/constants';

import {
  getGroupCategoriesBegin, getGroupCategoriesSuccess, getGroupCategoriesError,
} from 'containers/Group/GroupCategories/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';


export function* getGroupCategories(action) {
  try {
    const response = yield call(api.groups.all.bind(api.groupCategoryTypes), action.payload);

    yield put(getGroupCategoriesSuccess(response.data.page));
  } catch (err) {
    yield put(getGroupCategoriesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load groups categories', options: { variant: 'warning' } }));
  }
}


export default function* groupsSaga() {
  yield takeLatest(GET_GROUP_CATEGORIES_BEGIN, getGroupCategories);
}
