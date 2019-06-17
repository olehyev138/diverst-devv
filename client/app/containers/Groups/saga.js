import { call, put, takeLatest } from 'redux-saga/dist/redux-saga-effects-npm-proxy.esm';
import api from 'api/api';
import AuthService from 'utils/authService';
import { push } from 'connected-react-router';
import { GET_GROUPS_BEGIN, GET_GROUPS_SUCCESS, GET_GROUPS_ERROR } from 'containers/Groups/constants';
import { getGroupsBegin, getGroupsSuccess, getGroupsError } from 'containers/Groups/actions';

import { showSnackbar } from 'containers/Notifier/actions';

export function* getGroups(action) {
  try {
    const response = yield call(api.groups.all.bind(api.groups), action.payload);
    yield put(getGroupsSuccess(response.data));
  } catch (err) {
    yield put(getGroupsError(err));
    yield put(showSnackbar({ message: 'Failed to load groups', options: { variant: 'warning' } }));
  }
}

export default function* groupsSaga() {
  yield takeLatest(GET_GROUPS_BEGIN, getGroups);
}
