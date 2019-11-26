import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_ANSWERS_BEGIN, GET_ANSWER_BEGIN, CREATE_ANSWER_BEGIN,
  DELETE_ANSWER_BEGIN, UPDATE_ANSWER_BEGIN, UPDATE_ANSWER_SUCCESS, UPDATE_ANSWER_ERROR,
} from 'containers/Innovate/Campaign/CampaignQuestion/Answer/constants';

import {
  getAnswersSuccess, getAnswersError, deleteAnswerSuccess,
  createAnswerError, deleteAnswerError, createAnswerSuccess,
  getAnswerSuccess, getAnswerError, updateAnswerBegin, updateAnswerError, updateAnswerSuccess
} from 'containers/Innovate/Campaign/CampaignQuestion/Answer/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getAnswers(action) {
  try {
    const response = yield call(api.answers.all.bind(api.answers), action.payload);

    yield put(getAnswersSuccess(response.data.page));
  } catch (err) {
    yield put(getAnswersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load answers', options: { variant: 'warning' } }));
  }
}

export function* createAnswer(action) {
  try {
    const payload = { answer: action.payload };
    const response = yield call(api.answers.create.bind(api.answers), payload);

    yield put(createAnswerSuccess());
    yield put(push(ROUTES.admin.innovate.campaigns.show.path(action.payload.campaign_id)));
    yield put(showSnackbar({ message: 'Answer created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createAnswerError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create answer', options: { variant: 'warning' } }));
  }
}

export function* updateAnswer(action) {
  try {
    const payload = { answer: action.payload };
    const response = yield call(api.answers.update.bind(api.answers), payload.answer.id, payload);

    yield put(updateAnswerSuccess());
    yield put(push(ROUTES.admin.innovate.campaigns.show.path(action.payload.campaign_id)));
    yield put(showSnackbar({
      message: 'Answer updated',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateAnswerError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to update answer',
      options: { variant: 'warning' }
    }));
  }
}


export function* getAnswer(action) {
  try {
    const response = yield call(api.answers.get.bind(api.answers), action.payload.id);
    yield put(getAnswerSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getAnswerError(err));
    yield put(showSnackbar({
      message: 'Failed to get answer',
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteAnswer(action) {
  try {
    yield call(api.answers.destroy.bind(api.answers), action.payload.answerId);

    yield put(deleteAnswerSuccess());
    yield put(push(ROUTES.admin.innovate.campaigns.show.path(action.payload.campaignId)));
    yield put(showSnackbar({ message: 'Answer deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteAnswerError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove answer', options: { variant: 'warning' } }));
  }
}

export default function* answersSaga() {
  yield takeLatest(GET_ANSWERS_BEGIN, getAnswers);
  yield takeLatest(CREATE_ANSWER_BEGIN, createAnswer);
  yield takeLatest(DELETE_ANSWER_BEGIN, deleteAnswer);
  yield takeLatest(GET_ANSWER_BEGIN, getAnswer);
  yield takeLatest(UPDATE_ANSWER_BEGIN, updateAnswer);
}
