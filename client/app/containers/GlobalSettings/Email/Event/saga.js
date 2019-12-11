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
    console.log(err);
    yield put(getEventError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get event', options: { variant: 'warning' } }));
  }
}

export function* getEvents(action) {
  try {
    const response = yield call(api.emailEvents.all.bind(api.emailEvents), action.payload);

    yield put(getEventsSuccess(response.data.page));
  } catch (err) {
    yield put(getEventsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get events', options: { variant: 'warning' } }));
  }
}

export function* createEvent(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createEventSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created event', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createEventError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create event', options: { variant: 'warning' } }));
  }
}

export function* updateEvent(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(updateEventSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated event', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateEventError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update event', options: { variant: 'warning' } }));
  }
}

export function* deleteEvent(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deleteEventSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted event', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteEventError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete event', options: { variant: 'warning' } }));
  }
}


export default function* EventSaga() {
  yield takeLatest(GET_EVENT_BEGIN, getEvent);
  yield takeLatest(GET_EVENTS_BEGIN, getEvents);
  yield takeLatest(CREATE_EVENT_BEGIN, createEvent);
  yield takeLatest(UPDATE_EVENT_BEGIN, updateEvent);
  yield takeLatest(DELETE_EVENT_BEGIN, deleteEvent);
}
