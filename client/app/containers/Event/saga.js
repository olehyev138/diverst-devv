import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_EVENTS_BEGIN, GET_EVENT_BEGIN,
  CREATE_EVENT_BEGIN, UPDATE_EVENT_BEGIN,
  DELETE_EVENT_BEGIN,
} from 'containers/Event/constants';

import {
  getEventsSuccess, getEventsError,
  getEventSuccess, getEventError,
  createEventSuccess, createEventError,
  updateEventSuccess, updateEventError,
  deleteEventError,
} from 'containers/Event/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

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

export function* getEvent(action) {
  try {
    const response = yield call(api.initiatives.get.bind(api.initiatives), action.payload.id);
    yield put(getEventSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getEventError(err));
    yield put(showSnackbar({
      message: 'Failed to get event',
      options: { variant: 'warning' }
    }));
  }
}

export function* createEvent(action) {
  try {
    const payload = { initiative: action.payload };

    const response = yield call(api.initiatives.create.bind(api.initiatives), payload);

    yield put(push(ROUTES.group.events.index.path(payload.initiative.group_id)));
    yield put(showSnackbar({
      message: 'Event created',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(createEventError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to create event',
      options: { variant: 'warning' }
    }));
  }
}

export function* updateEvent(action) {
  try {
    const payload = { initiative: action.payload };
    const response = yield call(api.initiatives.update.bind(api.initiatives), payload.initiative.id, payload);

    yield put(push(ROUTES.group.events.index.path(payload.initiative.owner_group_id)));
    yield put(showSnackbar({
      message: 'Event updated',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateEventError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to update event',
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteEvent(action) {
  try {
    yield call(api.initiatives.destroy.bind(api.initiatives), action.payload.id);
    yield put(push(ROUTES.group.events.index.path(action.payload.group_id)));
    yield put(showSnackbar({
      message: 'Event deleted',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(deleteEventError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to delete event',
      options: { variant: 'warning' }
    }));
  }
}

export default function* eventsSaga() {
  yield takeLatest(GET_EVENTS_BEGIN, getEvents);
  yield takeLatest(GET_EVENT_BEGIN, getEvent);
  yield takeLatest(CREATE_EVENT_BEGIN, createEvent);
  yield takeLatest(UPDATE_EVENT_BEGIN, updateEvent);
  yield takeLatest(DELETE_EVENT_BEGIN, deleteEvent);
}
