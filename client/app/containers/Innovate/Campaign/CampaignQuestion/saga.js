import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_QUESTIONS_BEGIN, GET_QUESTION_BEGIN, CREATE_QUESTION_BEGIN,
  DELETE_QUESTION_BEGIN, UPDATE_QUESTION_BEGIN, UPDATE_QUESTION_SUCCESS, UPDATE_QUESTION_ERROR,
} from 'containers/Innovate/Campaign/CampaignQuestion/constants';

import {
  getQuestionsSuccess, getQuestionsError, deleteQuestionSuccess,
  createQuestionError, deleteQuestionError, createQuestionSuccess,
  getQuestionSuccess, getQuestionError, updateQuestionBegin, updateQuestionError, updateQuestionSuccess
} from 'containers/Innovate/Campaign/CampaignQuestion/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';
import {updateCampaignError, updateCampaignSuccess} from "../actions";
export function* getQuestions(action) {
  try {
    const response = yield call(api.questions.all.bind(api.questions), action.payload);

    yield put(getQuestionsSuccess(response.data.page));
  } catch (err) {
    yield put(getQuestionsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load questions', options: { variant: 'warning' } }));
  }
}

export function* createQuestion(action) {
  try {
    const payload = { question: action.payload };
    const response = yield call(api.questions.create.bind(api.questions), payload);

    yield put(createQuestionSuccess());
    yield put(push(ROUTES.admin.innovate.campaigns.show.path(action.payload.campaign_id)));
    yield put(showSnackbar({ message: 'Question created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createQuestionError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create question', options: { variant: 'warning' } }));
  }
}

export function* updateQuestion(action) {
  try {
    const payload = { question: action.payload };
    const response = yield call(api.questions.update.bind(api.questions), payload.question.id, payload);

    yield put(updateQuestionSuccess());
    yield put(push(ROUTES.admin.innovate.campaigns.show.path(action.payload.campaign_id)));
    yield put(showSnackbar({
      message: 'Question updated',
      options: { variant: 'success' }
    }));
  } catch (err) {
    console.log(err);
    yield put(updateQuestionError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to update question',
      options: { variant: 'warning' }
    }));
  }
}


export function* getQuestion(action) {
  try {
    const response = yield call(api.questions.get.bind(api.questions), action.payload.id);
    yield put(getQuestionSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getQuestionError(err));
    yield put(showSnackbar({
      message: 'Failed to get question',
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteQuestion(action) {
  try {
    const payload = {
      campaign_id: action.payload.campaign.id,
      question_id: action.payload.question.id
    };

    yield call(api.questions.destroy.bind(api.questions), action.payload.question_id);

    yield put(deleteQuestionSuccess());
    yield put(push(ROUTES.innovate.campaigns.questions.index.path(action.payload.campaign.id)));
    yield put(showSnackbar({ message: 'Question deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteQuestionError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove question', options: { variant: 'warning' } }));
  }
}

export default function* questionsSaga() {
  yield takeLatest(GET_QUESTIONS_BEGIN, getQuestions);
  yield takeLatest(CREATE_QUESTION_BEGIN, createQuestion);
  yield takeLatest(DELETE_QUESTION_BEGIN, deleteQuestion);
  yield takeLatest(GET_QUESTION_BEGIN, getQuestion);
  yield takeLatest(UPDATE_QUESTION_BEGIN, updateQuestion);
}
