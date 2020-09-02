import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_POLICY_BEGIN,
  GET_POLICIES_BEGIN,
  CREATE_POLICY_BEGIN,
  UPDATE_POLICY_BEGIN,
  DELETE_POLICY_BEGIN,
} from './constants';

import {
  getPolicySuccess, getPolicyError,
  getPoliciesSuccess, getPoliciesError,
  createPolicySuccess, createPolicyError,
  updatePolicySuccess, updatePolicyError,
  deletePolicySuccess, deletePolicyError,
} from './actions';

export function* getPolicy(action) {
  try {
    const response = yield call(api.policyTemplates.get.bind(api.policyTemplates), action.payload.id);

    yield put(getPolicySuccess(response.data));
  } catch (err) {
    yield put(getPolicyError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.policy), options: { variant: 'warning' } }));
  }
}

export function* getPolicies(action) {
  try {
    const response = yield call(api.policyTemplates.all.bind(api.policyTemplates), action.payload);

    yield put(getPoliciesSuccess(response.data.page));
  } catch (err) {
    yield put(getPoliciesError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.policies), options: { variant: 'warning' } }));
  }
}

export function* createPolicy(action) {
  try {
    const payload = { policy_group_template: action.payload };
    const response = yield call(api.policyTemplates.create.bind(api.policyTemplates), payload);

    yield put(createPolicySuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createPolicyError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create), options: { variant: 'warning' } }));
  }
}

export function* updatePolicy(action) {
  try {
    const payload = { policy_group_template: action.payload };
    const response = yield call(api.policyTemplates.update.bind(api.policyTemplates), payload.policy_group_template.id, payload);

    yield put(updatePolicySuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update), options: { variant: 'success' } }));
    yield put(push(ROUTES.admin.system.users.policy_templates.index.path()));
  } catch (err) {
    yield put(updatePolicyError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'warning' } }));
  }
}

export function* deletePolicy(action) {
  try {
    yield call(api.policyTemplates.destroy.bind(api.policyTemplates), action.payload.id);

    yield put(deletePolicySuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deletePolicyError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}


export default function* PolicySaga() {
  yield takeLatest(GET_POLICY_BEGIN, getPolicy);
  yield takeLatest(GET_POLICIES_BEGIN, getPolicies);
  yield takeLatest(CREATE_POLICY_BEGIN, createPolicy);
  yield takeLatest(UPDATE_POLICY_BEGIN, updatePolicy);
  yield takeLatest(DELETE_POLICY_BEGIN, deletePolicy);
}
