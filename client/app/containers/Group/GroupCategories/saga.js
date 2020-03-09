import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';


import {
  GET_GROUP_CATEGORIES_BEGIN,
  CREATE_GROUP_CATEGORIES_BEGIN
} from 'containers/Group/GroupCategories/constants';

import {
  getGroupCategoriesBegin, getGroupCategoriesSuccess, getGroupCategoriesError,
  createGroupCategoriesBegin, createGroupCategoriesSuccess, createGroupCategoriesError,
} from 'containers/Group/GroupCategories/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';


export function* getGroupCategories(action) {
  try {
    const response = yield call(api.groupCategoryTypes.all.bind(api.groupCategoryTypes), action.payload);
    yield put(getGroupCategoriesSuccess(response.data.page));
  } catch (err) {
    yield put(getGroupCategoriesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load groups categories', options: { variant: 'warning' } }));
  }
}
export function* createGroupCategories(action) {
  try {
    const payload = { group: action.payload };

    // TODO: use bind here or no?
    const response = yield call(api.groupCategoryTypes.create.bind(api.groupCategoryTypes), payload);
    const response2 = yield call(api.groupCategories.create.bind(api.groupCategories), payload);

    yield put(createGroupCategoriesSuccess());
    yield put(push(ROUTES.admin.manage.groups.categories.index.path()));
    yield put(showSnackbar({ message: 'Group categories created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupCategoriesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create group categories', options: { variant: 'warning' } }));
  }
}


export default function* groupsSaga() {
  yield takeLatest(GET_GROUP_CATEGORIES_BEGIN, getGroupCategories);
  yield takeLatest(CREATE_GROUP_CATEGORIES_BEGIN, createGroupCategories);
}
