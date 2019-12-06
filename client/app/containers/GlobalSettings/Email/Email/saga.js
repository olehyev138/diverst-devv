import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_EMAIL_BEGIN,
  GET_EMAILS_BEGIN,
  GET_VARIABLES_BEGIN,
  CREATE_EMAIL_BEGIN,
  UPDATE_EMAIL_BEGIN,
  DELETE_EMAIL_BEGIN,
} from './constants';

import {
  getEmailSuccess, getEmailError,
  getEmailsSuccess, getEmailsError,
  getVariablesSuccess, getVariablesError,
  createEmailSuccess, createEmailError,
  updateEmailSuccess, updateEmailError,
  deleteEmailSuccess, deleteEmailError,
} from './actions';

export function* getEmail(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getEmailSuccess(response.data));
  } catch (err) {
    yield put(getEmailError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get email', options: { variant: 'warning' } }));
  }
}

export function* getEmails(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getEmailsSuccess(response.data.page));
  } catch (err) {
    yield put(getEmailsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get emails', options: { variant: 'warning' } }));
  }
}

export function* getVariables(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getVariablesSuccess(response.data.page));
  } catch (err) {
    yield put(getVariablesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get variables', options: { variant: 'warning' } }));
  }
}

export function* createEmail(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createEmailSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created email', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createEmailError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create email', options: { variant: 'warning' } }));
  }
}

export function* updateEmail(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(updateEmailSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated email', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateEmailError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update email', options: { variant: 'warning' } }));
  }
}

export function* deleteEmail(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deleteEmailSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted email', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteEmailError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete email', options: { variant: 'warning' } }));
  }
}


export default function* EmailSaga() {
  yield takeLatest(GET_EMAIL_BEGIN, getEmail);
  yield takeLatest(GET_EMAILS_BEGIN, getEmails);
  yield takeLatest(GET_VARIABLES_BEGIN, getVariables);
  yield takeLatest(CREATE_EMAIL_BEGIN, createEmail);
  yield takeLatest(UPDATE_EMAIL_BEGIN, updateEmail);
  yield takeLatest(DELETE_EMAIL_BEGIN, deleteEmail);
}
