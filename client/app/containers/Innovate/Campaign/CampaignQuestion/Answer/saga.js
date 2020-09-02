import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import messages from './messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

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
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.answers), options: { variant: 'warning' } }));
  }
}

export function* createAnswer(action) {
  try {
    const payload = { answer: action.payload };
    const response = yield call(api.answers.create.bind(api.answers), payload);

    yield put(createAnswerSuccess());
    yield put(push(ROUTES.admin.innovate.campaigns.show.path(action.payload.campaign_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createAnswerError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create), options: { variant: 'warning' } }));
  }
}

export function* updateAnswer(action) {
  try {
    const payload = { answer: action.payload };
    const response = yield call(api.answers.update.bind(api.answers), payload.answer.id, payload);

    yield put(updateAnswerSuccess());
    yield put(push(ROUTES.admin.innovate.campaigns.show.path(action.payload.campaign_id)));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.success.update),
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateAnswerError(err));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.update),
      options: { variant: 'warning' }
    }));
  }
}


export function* getAnswer(action) {
  try {
    const response = yield call(api.answers.get.bind(api.answers), action.payload.id);
    yield put(getAnswerSuccess(response.data));
  } catch (err) {
    yield put(getAnswerError(err));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.answer),
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteAnswer(action) {
  try {
    yield call(api.answers.destroy.bind(api.answers), action.payload.answerId);

    yield put(deleteAnswerSuccess());
    yield put(push(ROUTES.admin.innovate.campaigns.show.path(action.payload.campaignId)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.pillars), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteAnswerError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}

export default function* answersSaga() {
  yield takeLatest(GET_ANSWERS_BEGIN, getAnswers);
  yield takeLatest(CREATE_ANSWER_BEGIN, createAnswer);
  yield takeLatest(DELETE_ANSWER_BEGIN, deleteAnswer);
  yield takeLatest(GET_ANSWER_BEGIN, getAnswer);
  yield takeLatest(UPDATE_ANSWER_BEGIN, updateAnswer);
}
