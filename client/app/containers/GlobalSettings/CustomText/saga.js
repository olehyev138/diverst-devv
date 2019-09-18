import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_CUSTOM_TEXT_BEGIN,
  UPDATE_CUSTOM_TEXT_BEGIN,
} from 'containers/GlobalSettings/CustomText/constants';

import {
  getCustomTextSuccess, getCustomTextError,
  updateCustomTextSuccess, updateCustomTextError,
} from 'containers/GlobalSettings/CustomText/actions';

export function* getCustomText(action) {
  try {
    const response = yield call(api.customText.get.bind(api.customText), action.payload.id);
    yield (put(getCustomTextSuccess(response.data)));
  } catch (err) {
    yield put(getCustomTextError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load custom text', options: { variant: 'warning' } }));
  }
}

export function* updateCustomText(action) {
  console.log('Hello M\'Fucker');
  try {
    console.log('Hello M\'Fucker 2');
    const payload = { custom_text: action.payload };
    console.log('Hello M\'Fucker 3');
    const response = yield call(api.customText.update.bind(api.customText), payload.custom_text.id, payload);
    console.log('Hello M\'Fucker 4');

    yield put(push(ROUTES.admin.system.globalSettings.customText));
    yield put(showSnackbar({ message: 'Custom text updated', options: { variant: 'success' } }));
  } catch (err) {
    console.log(err);
    yield put(updateCustomTextError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update custom text', options: { variant: 'warning' } }));
  }
}

export default function* customTextSaga() {
  yield takeLatest(GET_CUSTOM_TEXT_BEGIN, getCustomText);
  yield takeLatest(UPDATE_CUSTOM_TEXT_BEGIN, updateCustomText);
}
