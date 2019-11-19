import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_QUESTIONS_BEGIN, GET_QUESTION_BEGIN, CREATE_QUESTION_BEGIN,
  DELETE_QUESTION_BEGIN
} from 'containers/Innovate/Campaign/CampaignQuestion/constants';

import {
  getQuestionsSuccess, getQuestionsError, deleteQuestionSuccess,
  createQuestionError, deleteQuestionError, createQuestionSuccess
} from 'containers/Innovate/Campaign/CampaignQuestion/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';
export function* getMembers(action) {
  try {
    const response = yield call(api.userGroups.all.bind(api.userGroups), action.payload);

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
