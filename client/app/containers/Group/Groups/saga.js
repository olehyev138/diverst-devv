import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_GROUPS_BEGIN, CREATE_GROUP_BEGIN, UPDATE_GROUP_BEGIN, DELETE_GROUP_BEGIN
} from 'containers/Group/Groups/constants';
import {
  getGroupsSuccess, getGroupsError,
  createGroupSuccess, createGroupError
} from 'containers/Group/Groups/actions';

export function* getGroups(action) {
  try {
    const response = yield call(api.groups.all.bind(api.groups), action.payload);
    yield put(getGroupsSuccess(response.data));
  } catch (err) {
    yield put(getGroupsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load groups', options: { variant: 'warning' } }));
  }
}

export function* createGroups(action) {
  try {
    // const response = yield call(api.groups.all.bind(api.groups), action.payload);
    yield put(createGroupSuccess(response.data));
  } catch (err) {
    yield put(createGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create groups', options: { variant: 'warning' } }));
  }
}

export default function* groupsSaga() {
  yield takeLatest(GET_GROUPS_BEGIN, getGroups);
  yield takeLatest(CREATE_GROUP_BEGIN, createGroups);
}
