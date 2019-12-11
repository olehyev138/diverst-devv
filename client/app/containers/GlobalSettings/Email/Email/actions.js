/*
 *
 * Email actions
 *
 */

import {
  GET_EMAIL_BEGIN,
  GET_EMAIL_SUCCESS,
  GET_EMAIL_ERROR,
  GET_EMAILS_BEGIN,
  GET_EMAILS_SUCCESS,
  GET_EMAILS_ERROR,
  UPDATE_EMAIL_BEGIN,
  UPDATE_EMAIL_SUCCESS,
  UPDATE_EMAIL_ERROR,
  EMAILS_UNMOUNT,
} from './constants';

export function getEmailBegin(payload) {
  return {
    type: GET_EMAIL_BEGIN,
    payload,
  };
}

export function getEmailSuccess(payload) {
  return {
    type: GET_EMAIL_SUCCESS,
    payload,
  };
}

export function getEmailError(error) {
  return {
    type: GET_EMAIL_ERROR,
    error,
  };
}

export function getEmailsBegin(payload) {
  return {
    type: GET_EMAILS_BEGIN,
    payload,
  };
}

export function getEmailsSuccess(payload) {
  return {
    type: GET_EMAILS_SUCCESS,
    payload,
  };
}

export function getEmailsError(error) {
  return {
    type: GET_EMAILS_ERROR,
    error,
  };
}

export function updateEmailBegin(payload) {
  return {
    type: UPDATE_EMAIL_BEGIN,
    payload,
  };
}

export function updateEmailSuccess(payload) {
  return {
    type: UPDATE_EMAIL_SUCCESS,
    payload,
  };
}

export function updateEmailError(error) {
  return {
    type: UPDATE_EMAIL_ERROR,
    error,
  };
}

export function emailsUnmount(payload) {
  return {
    type: EMAILS_UNMOUNT,
    payload,
  };
}
