import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_EVENT_BEGIN,
  GET_EVENTS_BEGIN,
  CREATE_EVENT_BEGIN,
  UPDATE_EVENT_BEGIN,
  DELETE_EVENT_BEGIN,
} from './constants';

import {
  getEventSuccess, getEventError,
  getEventsSuccess, getEventsError,
  createEventSuccess, createEventError,
  updateEventSuccess, updateEventError,
  deleteEventSuccess, deleteEventError,
} from './actions';

export function* getEvent(action) {
  try {
    const response = yield call(api.emailEvents.get.bind(api.emailEvents), action.payload.id);

    yield put(getEventSuccess(response.data));
  } catch (err) {
    yield put(getEventError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get mailing event', options: { variant: 'warning' } }));
  }
}

export function* getEvents(action) {
  try {
    const response = yield call(api.emailEvents.all.bind(api.emailEvents), action.payload);

    yield put(getEventsSuccess(response.data.page));
  } catch (err) {
    yield put(getEventsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get mailing events', options: { variant: 'warning' } }));
  }
}

export function* createEvent(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createEventSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created mailing event', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createEventError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create mailing event', options: { variant: 'warning' } }));
  }
}

export function* updateEvent(action) {
  try {
    const payload = { clockwork_database_event: action.payload };
    const response = yield call(api.emailEvents.update.bind(api.emailEvents), payload.clockwork_database_event.id, payload);

    yield put(updateEventSuccess({}));
    yield put(push(ROUTES.admin.system.globalSettings.mailEvents.index.path()));
    yield put(showSnackbar({ message: 'Successfully updated mailing event', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateEventError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update mailing event', options: { variant: 'warning' } }));
  }
}

export function* deleteEvent(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deleteEventSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted mailing event', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteEventError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete mailing event', options: { variant: 'warning' } }));
  }
}


export default function* EventSaga() {
  yield takeLatest(GET_EVENT_BEGIN, getEvent);
  yield takeLatest(GET_EVENTS_BEGIN, getEvents);
  yield takeLatest(CREATE_EVENT_BEGIN, createEvent);
  yield takeLatest(UPDATE_EVENT_BEGIN, updateEvent);
  yield takeLatest(DELETE_EVENT_BEGIN, deleteEvent);
}
