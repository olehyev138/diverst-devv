/*
 *
 * Answers reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_ANSWERS_BEGIN, GET_ANSWERS_SUCCESS, GET_ANSWERS_ERROR,
  CREATE_ANSWER_BEGIN, CREATE_ANSWER_SUCCESS, CREATE_ANSWER_ERROR,
  UPDATE_ANSWER_BEGIN, UPDATE_ANSWER_SUCCESS, UPDATE_ANSWER_ERROR,
  DELETE_ANSWER_BEGIN, DELETE_ANSWER_SUCCESS, DELETE_ANSWER_ERROR,
  QUESTION_ANSWERS_UNMOUNT, GET_ANSWER_BEGIN, GET_ANSWER_ERROR, GET_ANSWER_SUCCESS,
} from './constants';


export const initialState = {
  currentAnswer: null,
  isCommitting: false,
  answerList: [],
  answerTotal: null,
  isFetchingAnswers: true
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function answersReducer(state = initialState, action) {
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_ANSWERS_BEGIN:
        draft.isFetchingAnswers = true;
        break;
      case GET_ANSWERS_SUCCESS:
        draft.answerList = action.payload.items;
        draft.answerTotal = action.payload.total;
        draft.isFetchingAnswers = false;
        break;
      case GET_ANSWERS_ERROR:
        draft.isFetchingAnswers = false;
        break;
      case CREATE_ANSWER_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_ANSWER_SUCCESS:
      case CREATE_ANSWER_ERROR:
        draft.isCommitting = false;
        break;
      case UPDATE_ANSWER_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_ANSWER_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_ANSWER_SUCCESS:
        draft.currentAnswer = action.payload.answer;
        draft.isFormLoading = false;
        break;
      case GET_ANSWER_ERROR:
        draft.isFormLoading = false;
        break;
      case QUESTION_ANSWERS_UNMOUNT:
        return initialState;
    }
  });
}

export default answersReducer;
