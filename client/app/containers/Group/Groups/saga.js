import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import AuthService from 'utils/authService';
import { push } from 'connected-react-router';
import { GET_GROUPS_BEGIN, GET_GROUPS_SUCCESS, GET_GROUPS_ERROR } from 'containers/Group/Groups/constants';
import { getGroupsBegin, getGroupsSuccess, getGroupsError } from 'containers/Group/Groups/actions';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

export function* getGroups(action) {
  try {
    const response = yield call(api.groups.all.bind(api.groups), action.payload);
    yield put(getGroupsSuccess(response.data.page));
  } catch (err) {
    yield put(getGroupsError(err));
    yield put(showSnackbar({ message: 'Failed to load groups', options: { variant: 'warning' } }));
  }
}

export default function* groupsSaga() {
  yield takeLatest(GET_GROUPS_BEGIN, getGroups);
}
