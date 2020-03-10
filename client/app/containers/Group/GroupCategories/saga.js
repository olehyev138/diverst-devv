import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';


import {
  GET_GROUP_CATEGORIES_BEGIN,
  CREATE_GROUP_CATEGORIES_BEGIN,
  DELETE_GROUP_CATEGORIES_BEGIN,
  UPDATE_GROUP_CATEGORIES_BEGIN
} from 'containers/Group/GroupCategories/constants';

import {
  getGroupCategoriesBegin, getGroupCategoriesSuccess, getGroupCategoriesError,
  createGroupCategoriesBegin, createGroupCategoriesSuccess, createGroupCategoriesError,
  deleteGroupCategoriesBegin, deleteGroupCategoriesSuccess, deleteGroupCategoriesError,
  updateGroupCategoriesBegin, updateGroupCategoriesSuccess, updateGroupCategoriesError,
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
    const payload = { group_category_type: action.payload };

    // TODO: use bind here or no?
    const response = yield call(api.groupCategoryTypes.create.bind(api.groupCategoryTypes), payload);
    yield put(createGroupCategoriesSuccess());
    yield put(push(ROUTES.admin.manage.groups.categories.index.path()));
    yield put(showSnackbar({ message: 'Group categories created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupCategoriesError(err));
    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create group categories', options: { variant: 'warning' } }));
  }
}

export function* deleteGroupCategories(action) {
  try {
    yield call(api.groupCategoryTypes.destroy.bind(api.groupCategoryTypes), action.payload);
    yield put(push(ROUTES.admin.manage.groups.categories.index.path()));
    yield put(showSnackbar({ message: 'Group categories deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupCategoriesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete group categories', options: { variant: 'warning' } }));
  }
}

export function* updateGroupCategories(action) {
  try {
    const payload = { group_category_type: action.payload };
    console.log('saga');
    console.log(action);

    const response = yield call(api.groupCategoryTypes.update.bind(api.groupCategoryTypes), payload.id, payload);
    //
    // yield put(updateGroupCategoriesSuccess());
    // yield put(push(ROUTES.admin.manage.groups.categories.index.path()));
    // yield put(showSnackbar({ message: 'Group updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateGroupCategoriesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update group', options: { variant: 'warning' } }));
  }
}


export default function* groupsSaga() {
  yield takeLatest(GET_GROUP_CATEGORIES_BEGIN, getGroupCategories);
  yield takeLatest(CREATE_GROUP_CATEGORIES_BEGIN, createGroupCategories);
  yield takeLatest(DELETE_GROUP_CATEGORIES_BEGIN, deleteGroupCategories);
  yield takeLatest(UPDATE_GROUP_CATEGORIES_BEGIN, updateGroupCategories);
}
