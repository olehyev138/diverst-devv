/*
 *
 * Members reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_QUESTIONS_BEGIN, GET_QUESTIONS_SUCCESS, GET_QUESTIONS_ERROR,
  CREATE_QUESTION_BEGIN, CREATE_QUESTION_SUCCESS, CREATE_QUESTION_ERROR,
  UPDATE_QUESTION_BEGIN, UPDATE_QUESTION_SUCCESS, UPDATE_QUESTION_ERROR,
  DELETE_QUESTION_BEGIN, DELETE_QUESTION_SUCCESS, DELETE_QUESTION_ERROR,
  CAMPAIGN_QUESTIONS_UNMOUNT, GET_QUESTION_BEGIN, GET_QUESTION_ERROR, GET_QUESTION_SUCCESS,
} from './constants';


export const initialState = {

  currentQuestion: null,
  isCommitting: false,
  questionList: [],
  questionTotal: null,
  isFetchingQuestions: true,
  isFormLoading: true,
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function questionsReducer(state = initialState, action) {
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_QUESTIONS_BEGIN:
        draft.isFetchingQuestions = true;
        break;
      case GET_QUESTIONS_SUCCESS:
        draft.questionList = action.payload.items;
        draft.questionTotal = action.payload.total;
        draft.isFetchingQuestions = false;
        break;
      case GET_QUESTIONS_ERROR:
        draft.isFetchingQuestions = false;
        break;
      case CREATE_QUESTION_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_QUESTION_SUCCESS:
      case CREATE_QUESTION_ERROR:
        draft.isCommitting = false;
        break;
      case UPDATE_QUESTION_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_QUESTION_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_QUESTION_SUCCESS:
        draft.currentQuestion = action.payload.question;
        draft.isFormLoading = false;
        break;
      case GET_QUESTION_ERROR:
        draft.isFormLoading = false;
        break;
      case CAMPAIGN_QUESTIONS_UNMOUNT:
        return initialState;
    }
  });
}

export default questionsReducer;
