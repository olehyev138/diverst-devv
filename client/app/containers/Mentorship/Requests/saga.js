import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_REQUESTS_BEGIN,
  GET_PROPOSALS_BEGIN,
  ACCEPT_REQUEST_BEGIN,
  REJECT_REQUEST_BEGIN,
  DELETE_REQUEST_BEGIN,
} from './constants';

import {
  getRequestsSuccess, getRequestsError,
  getProposalsSuccess, getProposalsError,
  acceptRequestSuccess, acceptRequestError,
  rejectRequestSuccess, rejectRequestError,
  deleteRequestSuccess, deleteRequestError,
} from './actions';

export function* getRequests(action) {
  try {
    const { payload } = action;
    payload.receiver_id = payload.userId;
    payload.query_scopes = [...(action.query_scopes || []), 'pending'];

    const response = yield call(api.mentoringRequests.all.bind(api.mentoringRequests), payload);

    yield put(getRequestsSuccess(response.data.page));
  } catch (err) {
    yield put(getRequestsError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.request, options: { variant: 'warning' } }));
  }
}

export function* getProposals(action) {
  try {
    const { payload } = action;
    payload.sender_id = payload.userId;

    const response = yield call(api.mentoringRequests.all.bind(api.mentoringRequests), payload);

    yield put(getProposalsSuccess(response.data.page));
  } catch (err) {
    yield put(getProposalsError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.proposal, options: { variant: 'warning' } }));
  }
}

export function* acceptRequest(action) {
  try {
    const response = yield call(api.mentoringRequests.acceptRequest.bind(api.mentoringRequests), action.payload.id);

    yield put(acceptRequestSuccess());
    yield put(showSnackbar({ message: messages.snackbars.success.accept, options: { variant: 'success' } }));
  } catch (err) {
    yield put(acceptRequestError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.accept, options: { variant: 'warning' } }));
  }
}

export function* rejectRequest(action) {
  try {
    const response = yield call(api.mentoringRequests.rejectRequest.bind(api.mentoringRequests), action.payload.id);

    yield put(rejectRequestSuccess());
    yield put(showSnackbar({ message: messages.snackbars.success.reject, options: { variant: 'success' } }));
  } catch (err) {
    yield put(rejectRequestError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.reject, options: { variant: 'warning' } }));
  }
}

export function* deleteRequest(action) {
  try {
    const response = yield call(api.mentoringRequests.destroy.bind(api.mentoringRequests), action.payload.id);

    yield put(deleteRequestSuccess());
    yield put(showSnackbar({ message: messages.snackbars.success.delete, options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteRequestError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } }));
  }
}


export default function* RequestSaga() {
  yield takeLatest(GET_REQUESTS_BEGIN, getRequests);
  yield takeLatest(GET_PROPOSALS_BEGIN, getProposals);
  yield takeLatest(ACCEPT_REQUEST_BEGIN, acceptRequest);
  yield takeLatest(REJECT_REQUEST_BEGIN, rejectRequest);
  yield takeLatest(DELETE_REQUEST_BEGIN, deleteRequest);
}
