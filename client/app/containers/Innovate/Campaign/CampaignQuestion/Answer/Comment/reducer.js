/*
 *
 * Comments reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_COMMENTS_BEGIN, GET_COMMENTS_SUCCESS, GET_COMMENTS_ERROR,
  CREATE_COMMENT_BEGIN, CREATE_COMMENT_SUCCESS, CREATE_COMMENT_ERROR,
  UPDATE_COMMENT_BEGIN, UPDATE_COMMENT_SUCCESS, UPDATE_COMMENT_ERROR,
  DELETE_COMMENT_BEGIN, DELETE_COMMENT_SUCCESS, DELETE_COMMENT_ERROR,
  ANSWER_COMMENTS_UNMOUNT, GET_COMMENT_BEGIN, GET_COMMENT_ERROR, GET_COMMENT_SUCCESS,
} from './constants';


export const initialState = {
  currentComment: null,
  isCommitting: false,
  commentList: [],
  commentTotal: null,
  isFetchingComments: true
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function commentsReducer(state = initialState, action) {
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_COMMENTS_BEGIN:
        draft.isFetchingComments = true;
        break;
      case GET_COMMENTS_SUCCESS:
        draft.commentList = action.payload.items;
        draft.commentTotal = action.payload.total;
        draft.isFetchingComments = false;
        break;
      case GET_COMMENTS_ERROR:
        draft.isFetchingComments = false;
        break;
      case CREATE_COMMENT_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_COMMENT_SUCCESS:
      case CREATE_COMMENT_ERROR:
        draft.isCommitting = false;
        break;
      case UPDATE_COMMENT_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_COMMENT_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_COMMENT_SUCCESS:
        draft.currentComment = action.payload.comment;
        draft.isFormLoading = false;
        break;
      case GET_COMMENT_ERROR:
        draft.isFormLoading = false;
        break;
      case ANSWER_COMMENTS_UNMOUNT:
        return initialState;
    }
  });
}

export default commentsReducer;
