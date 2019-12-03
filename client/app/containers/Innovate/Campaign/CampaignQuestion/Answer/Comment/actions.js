import {
  GET_COMMENTS_BEGIN, GET_COMMENTS_SUCCESS, GET_COMMENTS_ERROR, GET_COMMENT_BEGIN,
  GET_COMMENT_SUCCESS, GET_COMMENT_ERROR,
  CREATE_COMMENT_BEGIN, CREATE_COMMENT_SUCCESS, CREATE_COMMENT_ERROR,
  UPDATE_COMMENT_BEGIN, UPDATE_COMMENT_SUCCESS, UPDATE_COMMENT_ERROR,
  DELETE_COMMENT_BEGIN, DELETE_COMMENT_SUCCESS, DELETE_COMMENT_ERROR,
  ANSWER_COMMENTS_UNMOUNT
} from './constants';

/* Comment listing */

export function getCommentsBegin(payload) {
  return {
    type: GET_COMMENTS_BEGIN,
    payload
  };
}

export function getCommentsSuccess(payload) {
  return {
    type: GET_COMMENTS_SUCCESS,
    payload
  };
}

export function getCommentsError(error) {
  return {
    type: GET_COMMENTS_ERROR,
    error,
  };
}

export function getCommentBegin(payload) {
  return {
    type: GET_COMMENT_BEGIN,
    payload
  };
}

export function getCommentSuccess(payload) {
  return {
    type: GET_COMMENT_SUCCESS,
    payload
  };
}

export function getCommentError(error) {
  return {
    type: GET_COMMENT_ERROR,
    error,
  };
}
/* Comment creating */

export function createCommentBegin(payload) {
  return {
    type: CREATE_COMMENT_BEGIN,
    payload,
  };
}

export function createCommentSuccess(payload) {
  return {
    type: CREATE_COMMENT_SUCCESS,
    payload,
  };
}

export function createCommentError(error) {
  return {
    type: CREATE_COMMENT_ERROR,
    error,
  };
}

/* Comment updating */

export function updateCommentBegin(payload) {
  return {
    type: UPDATE_COMMENT_BEGIN,
    payload,
  };
}

export function updateCommentSuccess(payload) {
  return {
    type: UPDATE_COMMENT_SUCCESS,
    payload,
  };
}

export function updateCommentError(error) {
  return {
    type: UPDATE_COMMENT_ERROR,
    error,
  };
}

/* Comment deleting */

export function deleteCommentBegin(payload) {
  return {
    type: DELETE_COMMENT_BEGIN,
    payload,
  };
}

export function deleteCommentSuccess(payload) {
  return {
    type: DELETE_COMMENT_SUCCESS,
    payload,
  };
}

export function deleteCommentError(error) {
  return {
    type: DELETE_COMMENT_ERROR,
    error,
  };
}

export function answerCommentsUnmount() {
  return {
    type: ANSWER_COMMENTS_UNMOUNT
  };
}
