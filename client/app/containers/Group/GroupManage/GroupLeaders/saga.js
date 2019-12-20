import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_GROUP_LEADERS_BEGIN, GET_GROUP_LEADER_BEGIN, CREATE_GROUP_LEADER_BEGIN,
  DELETE_GROUP_LEADER_BEGIN, UPDATE_GROUP_LEADER_BEGIN, UPDATE_GROUP_LEADER_SUCCESS, UPDATE_GROUP_LEADER_ERROR
} from './constants';

import {
  getGroupLeadersSuccess, getGroupLeadersError, deleteGroupLeaderSuccess,
  createGroupLeaderError, deleteGroupLeaderError, createGroupLeaderSuccess,
  updateGroupLeaderBegin, updateGroupLeaderSuccess, updateGroupLeaderError, getGroupLeaderSuccess, getGroupLeaderError,
} from './actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getGroupLeaders(action) {
  try {
    const response = yield call(api.groupLeaders.all.bind(api.groupLeaders), action.payload);
    yield put(getGroupLeadersSuccess(response.data.page));
  } catch (err) {
    yield put(getGroupLeadersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load groupLeaders', options: { variant: 'warning' } }));
  }
}

export function* getGroupLeader(action) {
  try {
    const response = yield call(api.groupLeaders.get.bind(api.groupLeaders), action.payload.id);
    yield put(getGroupLeaderSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getGroupLeaderError(err));
    yield put(showSnackbar({
      message: 'Failed to get groupLeader',
      options: { variant: 'warning' }
    }));
  }
}

export function* createGroupLeaders(action) {
  try {
    const payload = { group_leader: action.payload };
    const response = yield call(api.groupLeaders.create.bind(api.groupLeaders), payload);
    yield put(createGroupLeaderSuccess());
    yield put(push(ROUTES.group.manage.leaders.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'GroupLeader created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupLeaderError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create groupLeaders', options: { variant: 'warning' } }));
  }
}

export function* deleteGroupLeaders(action) {
  try {
    yield call(api.groupLeaders.destroy.bind(api.groupLeaders), action.payload.id);
    yield put(deleteGroupLeaderSuccess());
    yield put(push(ROUTES.group.manage.leaders.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'Group leader deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupLeaderError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove groupLeaders', options: { variant: 'warning' } }));
  }
}

export function* updateGroupLeader(action) {
  try {
    const payload = { group_leader: action.payload };
    const response = yield call(api.groupLeaders.update.bind(api.groupLeaders), payload.group_leader.id, payload);
    yield put(updateGroupLeaderSuccess());
    yield put(push(ROUTES.group.manage.leaders.index.path(action.payload.group_id)));
    yield put(showSnackbar({
      message: 'GroupLeader updated',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateGroupLeaderError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to update groupLeader',
      options: { variant: 'warning' }
    }));
  }
}

export default function* groupLeadersSaga() {
  yield takeLatest(GET_GROUP_LEADERS_BEGIN, getGroupLeaders);
  yield takeLatest(GET_GROUP_LEADER_BEGIN, getGroupLeader);
  yield takeLatest(UPDATE_GROUP_LEADER_BEGIN, updateGroupLeader);
  yield takeLatest(CREATE_GROUP_LEADER_BEGIN, createGroupLeaders);
  yield takeLatest(DELETE_GROUP_LEADER_BEGIN, deleteGroupLeaders);
}
