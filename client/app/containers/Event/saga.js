import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_EVENTS_BEGIN, GET_EVENT_BEGIN,
  CREATE_EVENT_BEGIN, UPDATE_EVENT_BEGIN,
  DELETE_EVENT_BEGIN,
  CREATE_EVENT_COMMENT_BEGIN,
  CREATE_EVENT_COMMENT_SUCCESS,
  CREATE_EVENT_COMMENT_ERROR,
  DELETE_EVENT_COMMENT_BEGIN,
  DELETE_EVENT_COMMENT_ERROR,
  DELETE_EVENT_COMMENT_SUCCESS
} from 'containers/Event/constants';

import {
  getEventBegin, getEventsSuccess, getEventsError,
  getEventSuccess, getEventError,
  createEventSuccess, createEventError,
  updateEventSuccess, updateEventError,
  deleteEventError, deleteEventSuccess,
  deleteEventCommentBegin, deleteEventCommentError, deleteEventCommentSuccess,
  createEventCommentBegin, createEventCommentError, createEventCommentSuccess
} from 'containers/Event/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';


export function* getEvents(action) {
  try {
    const { payload } = action;
    let response;
    if (payload.group_id) {
      // eslint-disable-next-line camelcase
      const { group_id, ...rest } = payload;
      response = yield call(api.groups.initiatives.bind(api.groups), group_id, action.payload);
    } else
      response = yield call(api.initiatives.all.bind(api.initiatives), action.payload);


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

    yield put(createEventSuccess());
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

    yield put(updateEventSuccess());
    yield put(push(ROUTES.group.events.show.path(payload.initiative.owner_group_id, payload.initiative.id)));
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
    yield put(deleteEventSuccess());
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

/* event comment */
export function* deleteEventComment(action) {
  try {
    yield call(api.initiativeComments.destroy.bind(api.initiativeComments), action.payload.id);
    yield put(deleteEventCommentSuccess());
    yield put(getEventBegin({ id: action.payload.initiative_id }));
    yield put(showSnackbar({ message: 'event comment deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteEventCommentError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove event comment', options: { variant: 'warning' } }));
  }
}

export function* createEventComment(action) {
  // create comment & re-fetch event from server

  try {
    const payload = { initiative_comment: action.payload.attributes };
    const response = yield call(api.initiativeComments.create.bind(api.initiativeComments), payload);

    yield put(createEventCommentSuccess());
    yield put(getEventBegin({ id: payload.initiative_comment.initiative_id }));
    yield put(showSnackbar({ message: 'Event comment created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createEventCommentError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create event comment', options: { variant: 'warning' } }));
  }
}


export default function* eventsSaga() {
  yield takeLatest(GET_EVENTS_BEGIN, getEvents);
  yield takeLatest(GET_EVENT_BEGIN, getEvent);
  yield takeLatest(CREATE_EVENT_BEGIN, createEvent);
  yield takeLatest(UPDATE_EVENT_BEGIN, updateEvent);
  yield takeLatest(DELETE_EVENT_BEGIN, deleteEvent);
  yield takeLatest(CREATE_EVENT_COMMENT_BEGIN, createEventComment);
  yield takeLatest(DELETE_EVENT_COMMENT_BEGIN, deleteEventComment);
}
