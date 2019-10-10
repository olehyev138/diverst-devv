import { delay, call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  UPDATE_CUSTOM_TEXT_BEGIN,
} from 'containers/GlobalSettings/CustomText/constants';

import {
  updateCustomTextSuccess, updateCustomTextError,
} from 'containers/GlobalSettings/CustomText/actions';

export function* updateCustomText(action) {
  try {
    const payload = { custom_text: action.payload };
    const response = yield call(api.customText.update.bind(api.customText), payload.custom_text.id, payload);

    yield put(push(ROUTES.admin.system.globalSettings.customText));
    yield put(updateCustomTextSuccess(response.data));
    yield put(showSnackbar({ message: 'Custom text updated', options: { variant: 'success' } }));
    yield put(showSnackbar({ message: 'Changes will only be applied next time you login', options: { variant: 'info' } }));
  } catch (err) {
    yield put(updateCustomTextError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update custom text', options: { variant: 'warning' } }));
  }
}

export default function* customTextSaga() {
  yield takeLatest(UPDATE_CUSTOM_TEXT_BEGIN, updateCustomText);
}
