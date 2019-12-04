import {
  GET_ANSWERS_BEGIN, GET_ANSWERS_SUCCESS, GET_ANSWERS_ERROR, GET_ANSWER_BEGIN,
  GET_ANSWER_SUCCESS, GET_ANSWER_ERROR,
  CREATE_ANSWER_BEGIN, CREATE_ANSWER_SUCCESS, CREATE_ANSWER_ERROR,
  UPDATE_ANSWER_BEGIN, UPDATE_ANSWER_SUCCESS, UPDATE_ANSWER_ERROR,
  DELETE_ANSWER_BEGIN, DELETE_ANSWER_SUCCESS, DELETE_ANSWER_ERROR,
  QUESTION_ANSWERS_UNMOUNT
} from './constants';

/* Member listing */

export function getAnswersBegin(payload) {
  return {
    type: GET_ANSWERS_BEGIN,
    payload
  };
}

export function getAnswersSuccess(payload) {
  return {
    type: GET_ANSWERS_SUCCESS,
    payload
  };
}

export function getAnswersError(error) {
  return {
    type: GET_ANSWERS_ERROR,
    error,
  };
}

export function getAnswerBegin(payload) {
  return {
    type: GET_ANSWER_BEGIN,
    payload
  };
}

export function getAnswerSuccess(payload) {
  return {
    type: GET_ANSWER_SUCCESS,
    payload
  };
}

export function getAnswerError(error) {
  return {
    type: GET_ANSWER_ERROR,
    error,
  };
}
/* Group creating */

export function createAnswerBegin(payload) {
  return {
    type: CREATE_ANSWER_BEGIN,
    payload,
  };
}

export function createAnswerSuccess(payload) {
  return {
    type: CREATE_ANSWER_SUCCESS,
    payload,
  };
}

export function createAnswerError(error) {
  return {
    type: CREATE_ANSWER_ERROR,
    error,
  };
}

/* Member updating */

export function updateAnswerBegin(payload) {
  return {
    type: UPDATE_ANSWER_BEGIN,
    payload,
  };
}

export function updateAnswerSuccess(payload) {
  return {
    type: UPDATE_ANSWER_SUCCESS,
    payload,
  };
}

export function updateAnswerError(error) {
  return {
    type: UPDATE_ANSWER_ERROR,
    error,
  };
}

/* Member deleting */

export function deleteAnswerBegin(payload) {
  return {
    type: DELETE_ANSWER_BEGIN,
    payload,
  };
}

export function deleteAnswerSuccess(payload) {
  return {
    type: DELETE_ANSWER_SUCCESS,
    payload,
  };
}

export function deleteAnswerError(error) {
  return {
    type: DELETE_ANSWER_ERROR,
    error,
  };
}

export function questionAnswersUnmount() {
  return {
    type: QUESTION_ANSWERS_UNMOUNT
  };
}
