import { call, put, takeLatest } from 'redux-saga';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_MEMBERS_BEGIN, CREATE_MEMBERS_BEGIN,
  DELETE_MEMBER_BEGIN
} from 'containers/Group/GroupMembers/constants';

import {
  getMembersSuccess, getMembersError,
  createMembersError, deleteMemberError
} from 'containers/Group/GroupMembers/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getMembers(action) {
  try {
    const response = yield call(api.userGroups.all.bind(api.userGroups), action.payload);

    yield put(getMembersSuccess(response.data.page));
  } catch (err) {
    yield put(getMembersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load users', options: { variant: 'warning' } }));
  }
}

export function* createMembers(action) {
  try {
    const payload = { group: action.payload.attributes };
    const response = yield call(api.groups.update.bind(api.groups), action.payload.groupId, payload);

    // yield put(push(ROUTES.admin.manage.users.index.path()));
    yield put(showSnackbar({ message: 'User updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createMembersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update user', options: { variant: 'warning' } }));
  }
}

export function* deleteMember(action) {
  try {
    yield call(api.users.destroy.bind(api.users), action.payload);

    yield put(push(ROUTES.admin.manage.users.index.path()));
    yield put(showSnackbar({ message: 'User deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteMemberError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update user', options: { variant: 'warning' } }));
  }
}

export default function* membersSaga() {
  yield takeLatest(GET_MEMBERS_BEGIN, getMembers);
  yield takeLatest(CREATE_MEMBERS_BEGIN, createMembers);
  yield takeLatest(DELETE_MEMBER_BEGIN, deleteMember);
}
