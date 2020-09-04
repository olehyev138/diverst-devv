import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_GROUP_CATEGORIES_BEGIN,
  GET_GROUP_CATEGORY_BEGIN,
  CREATE_GROUP_CATEGORIES_BEGIN,
  DELETE_GROUP_CATEGORIES_BEGIN,
  UPDATE_GROUP_CATEGORIES_BEGIN
} from 'containers/Group/GroupCategories/constants';

import {
  getGroupCategoriesBegin, getGroupCategoriesSuccess, getGroupCategoriesError,
  getGroupCategoryBegin, getGroupCategorySuccess, getGroupCategoryError,
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
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.categories), options: { variant: 'warning' } }));
  }
}

export function* getGroupCategory(action) {
  try {
    const response = yield call(api.groupCategoryTypes.get.bind(api.groupCategoryTypes), action.payload.id);

    yield put(getGroupCategorySuccess(response.data));
  } catch (err) {
    yield put(getGroupCategoryError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.category), options: { variant: 'warning' } }));
  }
}

export function* createGroupCategories(action) {
  try {
    const payload = { group_category_type: action.payload };
    const response = yield call(api.groupCategoryTypes.create.bind(api.groupCategoryTypes), payload);

    yield put(createGroupCategoriesSuccess());
    yield put(push(ROUTES.admin.manage.groups.categories.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupCategoriesError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create), options: { variant: 'warning' } }));
  }
}

export function* deleteGroupCategories(action) {
  try {
    yield call(api.groupCategoryTypes.destroy.bind(api.groupCategoryTypes), action.payload);
    yield put(deleteGroupCategoriesSuccess());
    yield put(push(ROUTES.admin.manage.groups.categories.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupCategoriesError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}

export function* updateGroupCategories(action) {
  try {
    const payload = { group_category_type: action.payload };
    const response = yield call(api.groupCategoryTypes.update.bind(api.groupCategoryTypes), payload.group_category_type.id, payload);

    yield put(updateGroupCategoriesSuccess());
    yield put(push(ROUTES.admin.manage.groups.categories.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateGroupCategoriesError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'warning' } }));
  }
}


export default function* groupsSaga() {
  yield takeLatest(GET_GROUP_CATEGORIES_BEGIN, getGroupCategories);
  yield takeLatest(GET_GROUP_CATEGORY_BEGIN, getGroupCategory);
  yield takeLatest(CREATE_GROUP_CATEGORIES_BEGIN, createGroupCategories);
  yield takeLatest(DELETE_GROUP_CATEGORIES_BEGIN, deleteGroupCategories);
  yield takeLatest(UPDATE_GROUP_CATEGORIES_BEGIN, updateGroupCategories);
}
