import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_MEMBERS_BEGIN, CREATE_MEMBERS_BEGIN,
  DELETE_MEMBER_BEGIN
} from 'containers/Group/GroupMembers/constants';

import {
  getMembersSuccess, getMembersError, deleteMemberSuccess,
  createMembersError, deleteMemberError, createMembersSuccess
} from 'containers/Group/GroupMembers/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';
export function* getMembers(action) {
  console.log(action);
  try {
    const response = yield call(api.userGroups.all.bind(api.userGroups), action.payload);
    console.log(response);
    yield put(getMembersSuccess(response.data.page));
  } catch (err) {
    yield put(getMembersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load members', options: { variant: 'warning' } }));
  }
}

export function* createMembers(action) {
  try {
    const payload = {
      group_id: action.payload.groupId,
      member_ids: action.payload.attributes.member_ids
    };

    const response = yield call(api.groupMembers.addMembers.bind(api.groupMembers), payload);

    yield put(createMembersSuccess());
    yield put(push(ROUTES.group.members.index.path(action.payload.groupId)));
    yield put(showSnackbar({ message: 'User updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createMembersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create members', options: { variant: 'warning' } }));
  }
}

export function* deleteMembers(action) {
  try {
    const payload = {
      group_id: action.payload.groupId,
      member_ids: [action.payload.userId]
    };

    yield call(api.groupMembers.removeMembers.bind(api.groupMembers), payload);

    yield put(deleteMemberSuccess());
    yield put(push(ROUTES.group.members.index.path(action.payload.groupId)));
    yield put(showSnackbar({ message: 'User deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteMemberError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove members', options: { variant: 'warning' } }));
  }
}

export default function* membersSaga() {
  yield takeLatest(GET_MEMBERS_BEGIN, getMembers);
  yield takeLatest(CREATE_MEMBERS_BEGIN, createMembers);
  yield takeLatest(DELETE_MEMBER_BEGIN, deleteMembers);
}
