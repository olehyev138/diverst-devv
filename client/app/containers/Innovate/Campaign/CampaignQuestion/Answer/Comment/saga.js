import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_COMMENTS_BEGIN, GET_COMMENT_BEGIN, CREATE_COMMENT_BEGIN,
  DELETE_COMMENT_BEGIN, UPDATE_COMMENT_BEGIN, UPDATE_COMMENT_SUCCESS, UPDATE_COMMENT_ERROR,
} from 'containers/Innovate/Campaign/CampaignQuestion/Answer/Comment/constants';

import {
  getCommentsSuccess, getCommentsError, deleteCommentSuccess,
  createCommentError, deleteCommentError, createCommentSuccess,
  getCommentSuccess, getCommentError, updateCommentBegin, updateCommentError, updateCommentSuccess
} from 'containers/Innovate/Campaign/CampaignQuestion/Answer/Comment/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getComments(action) {
  try {
    const response = yield call(api.comments.all.bind(api.comments), action.payload);
    yield put(getCommentsSuccess(response.data.page));
  } catch (err) {
    yield put(getCommentsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load comments', options: { variant: 'warning' } }));
  }
}

export function* createComment(action) {
  try {
    const payload = { comment: action.payload };
    const response = yield call(api.comments.create.bind(api.comments), payload);

    yield put(createCommentSuccess());
    yield put(push(ROUTES.admin.innovate.campaigns.show.path(action.payload.campaign_id)));
    yield put(showSnackbar({ message: 'Comment created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createCommentError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create comment', options: { variant: 'warning' } }));
  }
}

export function* updateComment(action) {
  try {
    const payload = { answer: action.payload };
    const response = yield call(api.comments.update.bind(api.comments), payload.comment.id, payload);

    yield put(updateCommentSuccess());
    yield put(push(ROUTES.admin.innovate.campaigns.show.path(action.payload.campaign_id)));
    yield put(showSnackbar({
      message: 'Comment updated',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateCommentError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to update comment',
      options: { variant: 'warning' }
    }));
  }
}


export function* getComment(action) {
  try {
    const response = yield call(api.comments.get.bind(api.comments), action.payload.id);
    yield put(getCommentSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getCommentError(err));
    yield put(showSnackbar({
      message: 'Failed to get comment',
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteComment(action) {
  try {
    yield call(api.comments.destroy.bind(api.comments), action.payload.commentId);

    yield put(deleteCommentSuccess());
    yield put(push(ROUTES.admin.innovate.campaigns.show.path(action.payload.campaignId)));
    yield put(showSnackbar({ message: 'Comment deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteCommentError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove comment', options: { variant: 'warning' } }));
  }
}

export default function* answersSaga() {
  yield takeLatest(GET_COMMENTS_BEGIN, getComments);
  yield takeLatest(CREATE_COMMENT_BEGIN, createComment);
  yield takeLatest(DELETE_COMMENT_BEGIN, deleteComment);
  yield takeLatest(GET_COMMENT_BEGIN, getComment);
  yield takeLatest(UPDATE_COMMENT_BEGIN, updateComment);
}
