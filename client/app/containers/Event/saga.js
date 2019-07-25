import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { GET_EVENTS_BEGIN } from 'containers/Event/constants';

import { getEventsError, getEventsSuccess } from 'containers/Event/actions';

export function* getEvents(action) {
  try {
    const response = yield call(api.initiatives.all.bind(api.initiatives), action.payload);
    yield (put(getEventsSuccess(response.data.page)));
  } catch (err) {
    yield put(getEventsError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to load events',
      options: { variant: 'warning' }
    }));
  }
}

export default function* eventsSaga() {
  yield takeLatest(GET_EVENTS_BEGIN, getEvents);
}
