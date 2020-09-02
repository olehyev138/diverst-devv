import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_PILLAR_BEGIN,
  GET_PILLARS_BEGIN,
  CREATE_PILLAR_BEGIN,
  UPDATE_PILLAR_BEGIN,
  DELETE_PILLAR_BEGIN,
} from './constants';

import {
  getPillarSuccess, getPillarError,
  getPillarsSuccess, getPillarsError,
  createPillarSuccess, createPillarError,
  updatePillarSuccess, updatePillarError,
  deletePillarSuccess, deletePillarError,
} from './actions';

export function* getPillar(action) {
  try {
    const response = yield call(api.pillars.get.bind(api.pillars), action.payload.id);

    yield put(getPillarSuccess(response.data));
  } catch (err) {
    yield put(getPillarError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.pillar), options: { variant: 'warning' } }));
  }
}

export function* getPillars(action) {
  try {
    const response = yield call(api.pillars.all.bind(api.pillars), action.payload);

    yield put(getPillarsSuccess(response.data.page));
  } catch (err) {
    yield put(getPillarsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.pillars), options: { variant: 'warning' } }));
  }
}

export function* createPillar(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createPillarSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createPillarError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create), options: { variant: 'warning' } }));
  }
}

export function* updatePillar(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(updatePillarSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updatePillarError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'warning' } }));
  }
}

export function* deletePillar(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deletePillarSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deletePillarError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}


export default function* PillarSaga() {
  yield takeLatest(GET_PILLAR_BEGIN, getPillar);
  yield takeLatest(GET_PILLARS_BEGIN, getPillars);
  yield takeLatest(CREATE_PILLAR_BEGIN, createPillar);
  yield takeLatest(UPDATE_PILLAR_BEGIN, updatePillar);
  yield takeLatest(DELETE_PILLAR_BEGIN, deletePillar);
}
