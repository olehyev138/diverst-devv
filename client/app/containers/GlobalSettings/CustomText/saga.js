import { call, put, takeLatest, select } from 'redux-saga/effects';
import api from 'api/api';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  UPDATE_CUSTOM_TEXT_BEGIN,
} from 'containers/GlobalSettings/CustomText/constants';

import {
  updateCustomTextSuccess, updateCustomTextError,
} from 'containers/GlobalSettings/CustomText/actions';

import { setUserData } from 'containers/Shared/App/actions';
import { selectEnterprise } from 'containers/Shared/App/selectors';


export function* updateCustomText(action) {
  try {
    const { callback } = action.payload;

    const payload = { custom_text: action.payload };
    const response = yield call(api.customText.update.bind(api.customText), payload.custom_text.id, payload);

    yield put(updateCustomTextSuccess());

    // Replace `custom_text` property in local enterprise object with updated custom text response
    const enterprise = yield select(selectEnterprise());
    yield put(setUserData({ enterprise: { ...enterprise, custom_text: response.data.custom_text } }, true));

    yield put(showSnackbar({ message: 'Custom text updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateCustomTextError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update custom text', options: { variant: 'warning' } }));
  }
}

export default function* customTextSaga() {
  yield takeLatest(UPDATE_CUSTOM_TEXT_BEGIN, updateCustomText);
}
