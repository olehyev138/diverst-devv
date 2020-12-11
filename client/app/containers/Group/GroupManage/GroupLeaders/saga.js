import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

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

    yield put(showSnackbar({ message: messages.snackbars.errors.leaders, options: { variant: 'warning' } }));
  }
}

export function* getGroupLeader(action) {
  try {
    const response = yield call(api.groupLeaders.get.bind(api.groupLeaders), action.payload.id);
    yield put(getGroupLeaderSuccess(response.data));
  } catch (err) {
    yield put(getGroupLeaderError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.leader,
      options: { variant: 'warning' }
    }));
  }
}

export function* createGroupLeader(action) {
  try {
    const payload = { group_leader: action.payload };
    const response = yield call(api.groupLeaders.create.bind(api.groupLeaders), payload);
    yield put(createGroupLeaderSuccess());
    yield put(push(ROUTES.group.manage.leaders.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: messages.snackbars.success.create, options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupLeaderError(err));

    yield put(showSnackbar({ message: messages.snackbars.errors.create, options: { variant: 'warning' } }));
  }
}

export function* deleteGroupLeader(action) {
  try {
    yield call(api.groupLeaders.destroy.bind(api.groupLeaders), action.payload.id);
    yield put(deleteGroupLeaderSuccess());
    yield put(push(ROUTES.group.manage.leaders.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: messages.snackbars.success.delete, options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupLeaderError(err));

    yield put(showSnackbar({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } }));
  }
}

export function* updateGroupLeader(action) {
  try {
    const payload = { group_leader: action.payload };
    const response = yield call(api.groupLeaders.update.bind(api.groupLeaders), payload.group_leader.id, payload);
    yield put(updateGroupLeaderSuccess());
    yield put(push(ROUTES.group.manage.leaders.index.path(action.payload.group_id)));
    yield put(showSnackbar({
      message: messages.snackbars.success.update,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateGroupLeaderError(err));

    yield put(showSnackbar({
      message: messages.snackbars.errors.update,
      options: { variant: 'warning' }
    }));
  }
}

export default function* groupLeadersSaga() {
  yield takeLatest(GET_GROUP_LEADERS_BEGIN, getGroupLeaders);
  yield takeLatest(GET_GROUP_LEADER_BEGIN, getGroupLeader);
  yield takeLatest(UPDATE_GROUP_LEADER_BEGIN, updateGroupLeader);
  yield takeLatest(CREATE_GROUP_LEADER_BEGIN, createGroupLeader);
  yield takeLatest(DELETE_GROUP_LEADER_BEGIN, deleteGroupLeader);
}
