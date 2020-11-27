import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_OUTCOMES_BEGIN, CREATE_OUTCOME_BEGIN,
  GET_OUTCOME_BEGIN, UPDATE_OUTCOME_BEGIN, DELETE_OUTCOME_BEGIN
} from 'containers/Group/Outcome/constants';

import {
  getOutcomesSuccess, getOutcomesError,
  createOutcomeSuccess, createOutcomeError,
  getOutcomeSuccess, getOutcomeError,
  updateOutcomeSuccess, updateOutcomeError,
  deleteOutcomeError, deleteOutcomeSuccess
} from 'containers/Group/Outcome/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getOutcomes(action) {
  try {
    const response = yield call(api.outcomes.all.bind(api.outcomes), action.payload);

    yield put(getOutcomesSuccess(response.data.page));
  } catch (err) {
    yield put(getOutcomesError(err));

    yield put(showSnackbar({ message: messages.snackbars.errors.outcomes, options: { variant: 'warning' } }));
  }
}

export function* getOutcome(action) {
  try {
    const response = yield call(api.outcomes.get.bind(api.outcomes), action.payload.id);
    yield put(getOutcomeSuccess(response.data));
  } catch (err) {
    yield put(getOutcomeError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.outcome, options: { variant: 'warning' } }));
  }
}


export function* createOutcome(action) {
  try {
    const payload = { outcome: action.payload };

    // TODO: use bind here or no?
    const response = yield call(api.outcomes.create.bind(api.outcomes), payload);

    yield put(createOutcomeSuccess());
    yield put(push(ROUTES.group.plan.outcomes.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: messages.snackbars.success.create, options: { variant: 'success' } }));
  } catch (err) {
    yield put(createOutcomeError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.create, options: { variant: 'warning' } }));
  }
}

export function* updateOutcome(action) {
  try {
    const payload = { outcome: action.payload };
    const response = yield call(api.outcomes.update.bind(api.outcomes), payload.outcome.id, payload);

    yield put(updateOutcomeSuccess());
    yield put(push(ROUTES.group.plan.outcomes.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: messages.snackbars.success.update, options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateOutcomeError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.update, options: { variant: 'warning' } }));
  }
}

export function* deleteOutcome(action) {
  try {
    yield call(api.outcomes.destroy.bind(api.outcomes), action.payload.id);

    yield put(deleteOutcomeSuccess());
    yield put(push(ROUTES.group.plan.outcomes.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: messages.snackbars.success.delete, options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteOutcomeError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } }));
  }
}

export default function* outcomesSaga() {
  yield takeLatest(GET_OUTCOMES_BEGIN, getOutcomes);
  yield takeLatest(GET_OUTCOME_BEGIN, getOutcome);
  yield takeLatest(CREATE_OUTCOME_BEGIN, createOutcome);
  yield takeLatest(UPDATE_OUTCOME_BEGIN, updateOutcome);
  yield takeLatest(DELETE_OUTCOME_BEGIN, deleteOutcome);
}
