import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

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

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get requests', options: { variant: 'warning' } }));
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

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get proposals', options: { variant: 'warning' } }));
  }
}

export function* acceptRequest(action) {
  try {
    const response = yield call(api.mentoringRequests.acceptRequest.bind(api.mentoringRequests), action.payload.id);

    yield put(showSnackbar({ message: 'Successfully accepted request', options: { variant: 'success' } }));
  } catch (err) {
    yield put(acceptRequestError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to accept request', options: { variant: 'warning' } }));
  }
}

export function* rejectRequest(action) {
  try {
    const response = yield call(api.mentoringRequests.rejectRequest.bind(api.mentoringRequests), action.payload.id);

    yield put(showSnackbar({ message: 'Successfully denied request', options: { variant: 'success' } }));
  } catch (err) {
    yield put(rejectRequestError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to reject request', options: { variant: 'warning' } }));
  }
}

export function* deleteRequest(action) {
  try {
    const response = yield call(api.mentoringRequests.destroy.bind(api.mentoringRequests), action.payload.id);

    yield put(showSnackbar({ message: 'Successfully deleted request', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteRequestError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete request', options: { variant: 'warning' } }));
  }
}


export default function* RequestSaga() {
  yield takeLatest(GET_REQUESTS_BEGIN, getRequests);
  yield takeLatest(GET_PROPOSALS_BEGIN, getProposals);
  yield takeLatest(ACCEPT_REQUEST_BEGIN, acceptRequest);
  yield takeLatest(REJECT_REQUEST_BEGIN, rejectRequest);
  yield takeLatest(DELETE_REQUEST_BEGIN, deleteRequest);
}
