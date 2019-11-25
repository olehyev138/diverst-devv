// Campaign Question Actions

import {
  GET_QUESTIONS_BEGIN, GET_QUESTIONS_SUCCESS, GET_QUESTIONS_ERROR, GET_QUESTION_BEGIN,
  GET_QUESTION_SUCCESS, GET_QUESTION_ERROR,
  CREATE_QUESTION_BEGIN, CREATE_QUESTION_SUCCESS, CREATE_QUESTION_ERROR,
  UPDATE_QUESTION_BEGIN, UPDATE_QUESTION_SUCCESS, UPDATE_QUESTION_ERROR,
  DELETE_QUESTION_BEGIN, DELETE_QUESTION_SUCCESS, DELETE_QUESTION_ERROR,
  CAMPAIGN_QUESTIONS_UNMOUNT
} from 'containers/Innovate/Campaign/CampaignQuestion/constants';

/* Member listing */

export function getQuestionsBegin(payload) {
  return {
    type: GET_QUESTIONS_BEGIN,
    payload
  };
}

export function getQuestionsSuccess(payload) {
  return {
    type: GET_QUESTIONS_SUCCESS,
    payload
  };
}

export function getQuestionsError(error) {
  return {
    type: GET_QUESTIONS_ERROR,
    error,
  };
}

export function getQuestionBegin(payload) {
  return {
    type: GET_QUESTION_BEGIN,
    payload
  };
}

export function getQuestionSuccess(payload) {
  return {
    type: GET_QUESTION_SUCCESS,
    payload
  };
}

export function getQuestionError(error) {
  return {
    type: GET_QUESTION_ERROR,
    error,
  };
}
/* Group creating */

export function createQuestionBegin(payload) {
  return {
    type: CREATE_QUESTION_BEGIN,
    payload,
  };
}

export function createQuestionSuccess(payload) {
  return {
    type: CREATE_QUESTION_SUCCESS,
    payload,
  };
}

export function createQuestionError(error) {
  return {
    type: CREATE_QUESTION_ERROR,
    error,
  };
}

/* Member updating */

export function updateQuestionBegin(payload) {
  return {
    type: UPDATE_QUESTION_BEGIN,
    payload,
  };
}

export function updateQuestionSuccess(payload) {
  return {
    type: UPDATE_QUESTION_SUCCESS,
    payload,
  };
}

export function updateQuestionError(error) {
  return {
    type: UPDATE_QUESTION_ERROR,
    error,
  };
}

/* Member deleting */

export function deleteQuestionBegin(payload) {
  return {
    type: DELETE_QUESTION_BEGIN,
    payload,
  };
}

export function deleteQuestionSuccess(payload) {
  return {
    type: DELETE_QUESTION_SUCCESS,
    payload,
  };
}

export function deleteQuestionError(error) {
  return {
    type: DELETE_QUESTION_ERROR,
    error,
  };
}

export function campaignQuestionsUnmount() {
  return {
    type: CAMPAIGN_QUESTIONS_UNMOUNT
  };
}
