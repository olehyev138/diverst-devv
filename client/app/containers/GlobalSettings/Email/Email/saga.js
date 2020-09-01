import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_EMAIL_BEGIN,
  GET_EMAILS_BEGIN,
  UPDATE_EMAIL_BEGIN,
} from './constants';

import {
  getEmailSuccess, getEmailError,
  getEmailsSuccess, getEmailsError,
  updateEmailSuccess, updateEmailError,
} from './actions';

export function* getEmail(action) {
  try {
    const response = yield call(api.emails.get.bind(api.emails), action.payload.id);

    yield put(getEmailSuccess(response.data));
  } catch (err) {
    yield put(getEmailError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.update.email), options: { variant: 'warning' } }));
  }
}

export function* getEmails(action) {
  try {
    const response = yield call(api.emails.all.bind(api.emails), action.payload);

    yield put(getEmailsSuccess(response.data.page));
  } catch (err) {
    yield put(getEmailsError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.update.emails), options: { variant: 'warning' } }));
  }
}

export function* updateEmail(action) {
  try {
    const payload = { email: action.payload };
    const response = yield call(api.emails.update.bind(api.emails), payload.email.id, payload);

    yield put(updateEmailSuccess({}));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateEmailError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'warning' } }));
  }
}


export default function* EmailSaga() {
  yield takeLatest(GET_EMAIL_BEGIN, getEmail);
  yield takeLatest(GET_EMAILS_BEGIN, getEmails);
  yield takeLatest(UPDATE_EMAIL_BEGIN, updateEmail);
}
