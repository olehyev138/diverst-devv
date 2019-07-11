import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';


import {
  GET_GROUPS_BEGIN, CREATE_GROUP_BEGIN,
  GET_GROUP_BEGIN, UPDATE_GROUP_BEGIN, DELETE_GROUP_BEGIN
} from 'containers/Group/constants';

import {
  getGroupsSuccess, getGroupsError,
  createGroupSuccess, createGroupError,
  getGroupSuccess, getGroupError,
  updateGroupSuccess, updateGroupError,
  deleteGroupError
} from 'containers/Group/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getGroups(action) {
  try {
    const response = yield call(api.groups.all.bind(api.groups), action.payload);

    yield put(getGroupsSuccess(response.data.page));
  } catch (err) {
    yield put(getGroupsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load groups', options: { variant: 'warning' } }));
  }
}

export function* getGroup(action) {
  try {
    const response = yield call(api.groups.get.bind(api.groups), action.payload.id);
    yield put(getGroupSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getGroupError(err));
    yield put(showSnackbar({ message: 'Failed to edit group', options: { variant: 'warning' } }));
  }
}


export function* createGroup(action) {
  try {
    const payload = { group: action.payload };

    // TODO: use bind here or no?
    const response = yield call(api.groups.create.bind(api.groups), payload);

    yield put(push(ROUTES.admin.manage.groups.index.path));
    yield put(showSnackbar({ message: 'Group created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create group', options: { variant: 'warning' } }));
  }
}

export function* updateGroup(action) {
  try {
    const payload = { group: action.payload };
    const response = yield call(api.groups.update.bind(api.groups), payload.group.id, payload);

    yield put(push(ROUTES.admin.manage.groups.index.path));
    yield put(showSnackbar({ message: 'Group updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update group', options: { variant: 'warning' } }));
  }
}

export function* deleteGroup(action) {
  try {
    yield call(api.groups.destroy.bind(api.groups), action.payload);
    yield put(push(ROUTES.admin.manage.groups.index.path));
    yield put(showSnackbar({ message: 'Group deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update group', options: { variant: 'warning' } }));
  }
}

export default function* groupsSaga() {
  yield takeLatest(GET_GROUPS_BEGIN, getGroups);
  yield takeLatest(GET_GROUP_BEGIN, getGroup);
  yield takeLatest(CREATE_GROUP_BEGIN, createGroup);
  yield takeLatest(UPDATE_GROUP_BEGIN, updateGroup);

  yield takeLatest(DELETE_GROUP_BEGIN, deleteGroup);
}
