import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_EVENTS_BEGIN,
  GET_EVENT_BEGIN,
  CREATE_EVENT_BEGIN,
  UPDATE_EVENT_BEGIN,
  DELETE_EVENT_BEGIN,
  CREATE_EVENT_COMMENT_BEGIN,
  DELETE_EVENT_COMMENT_BEGIN,
  FINALIZE_EXPENSES_BEGIN,
  ARCHIVE_EVENT_BEGIN,
  JOIN_EVENT_BEGIN,
  LEAVE_EVENT_BEGIN,
  EXPORT_ATTENDEES_BEGIN
} from './constants';


import {
  getEventBegin,
  getEventsSuccess, getEventsError,
  getEventSuccess, getEventError,
  createEventSuccess, createEventError,
  updateEventSuccess, updateEventError,
  deleteEventSuccess, deleteEventError,
  deleteEventCommentError, deleteEventCommentSuccess,
  createEventCommentError, createEventCommentSuccess,
  finalizeExpensesSuccess, finalizeExpensesError,
  archiveEventError, archiveEventSuccess,
  joinEventError, joinEventSuccess,
  exportAttendeesSuccess, exportAttendeesError, leaveEventSuccess, leaveEventError
} from './actions';


export function* getEvents(action) {
  try {
    const { annualBudgetId, ...payload } = action.payload;
    const response = yield call(api.initiatives.all.bind(api.initiatives), payload);

    yield put(getEventsSuccess({ annualBudgetId, ...response.data.page }));
  } catch (err) {
    const { annualBudgetId } = action.payload;
    yield put(getEventsError({ annualBudgetId }));

    yield put(showSnackbar({
      message: err.response.status === 401 ? intl.formatMessage(messages.snackbars.errors.load_events_no_permission) : intl.formatMessage(messages.snackbars.errors.load_events),
      options: { variant: 'warning' }
    }));
  }
}

export function* getEvent(action) {
  try {
    const { id, ...payload } = action.payload;
    const response = yield call(api.initiatives.get.bind(api.initiatives), action.payload.id, payload);
    yield put(getEventSuccess(response.data));
  } catch (err) {
    yield put(getEventError(err));

    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.load_event),
      options: { variant: 'warning' }
    }));
  }
}

export function* createEvent(action) {
  try {
    const payload = { initiative: action.payload };

    const response = yield call(api.initiatives.create.bind(api.initiatives), payload);

    yield put(createEventSuccess());
    yield put(push(ROUTES.group.events.show.path(payload.initiative.owner_group_id, response.data.initiative.id)));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.success.create_event),
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(createEventError(err));

    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.create_event),
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
      message: intl.formatMessage(messages.snackbars.success.update_event),
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateEventError(err));

    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.update_event),
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
      message: intl.formatMessage(messages.snackbars.success.delete_event),
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(deleteEventError(err));

    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.delete_event),
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
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete_event_comment), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteEventCommentError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete_event_comment), options: { variant: 'warning' } }));
  }
}

export function* createEventComment(action) {
  // create comment & re-fetch event from server

  try {
    const payload = { initiative_comment: action.payload.attributes };
    const response = yield call(api.initiativeComments.create.bind(api.initiativeComments), payload);
    yield put(createEventCommentSuccess());
    yield put(getEventBegin({ id: payload.initiative_comment.initiative_id }));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create_event_comment), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createEventCommentError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create_event_comment), options: { variant: 'warning' } }));
  }
}


export function* archiveEvent(action) {
  try {
    const payload = { initiative: action.payload };

    const response = yield call(api.initiatives.archive.bind(api.initiatives), payload.initiative.id, payload);
    yield put(archiveEventSuccess());
    yield put(push(ROUTES.group.events.index.path(payload.initiative.group_id)));
  } catch (err) {
    yield put(archiveEventError(err));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.archive),
      options: { variant: 'warning' }
    }));
  }
}

export function* finalizeExpenses(action) {
  try {
    const response = yield call(api.initiatives.finalizeExpenses.bind(api.initiatives), action.payload.id);
    yield put(finalizeExpensesSuccess(response.data));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.finalize_expense), options: { variant: 'success' } }));
  } catch (err) {
    yield put(finalizeExpensesError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.finalize_expense), options: { variant: 'warning' } }));
  }
}

export function* joinEvent(action) {
  const payload = { initiative_user: action.payload };
  try {
    const response = yield call(api.initiativeUsers.join.bind(api.initiativeUsers), payload);
    yield put(joinEventSuccess(payload));
  } catch (err) {
    yield put(joinEventError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.join), options: { variant: 'warning' } }));
  }
}

export function* leaveEvent(action) {
  const payload = { initiative_user: action.payload };
  try {
    const response = yield call(api.initiativeUsers.leave.bind(api.initiativeUsers), payload);
    yield put(leaveEventSuccess(payload));
  } catch (err) {
    yield put(leaveEventError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.leave), options: { variant: 'warning' } }));
  }
}

export function* exportAttendees(action) {
  try {
    const response = yield call(api.initiativeUsers.csvExport.bind(api.initiativeUsers), action.payload);

    yield put(exportAttendeesSuccess({}));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.export_attendees), options: { variant: 'success' } }));
  } catch (err) {
    yield put(exportAttendeesError(err));

    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.export_attendees), options: { variant: 'warning' } }));
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
  yield takeLatest(ARCHIVE_EVENT_BEGIN, archiveEvent);
  yield takeLatest(FINALIZE_EXPENSES_BEGIN, finalizeExpenses);
  yield takeLatest(JOIN_EVENT_BEGIN, joinEvent);
  yield takeLatest(LEAVE_EVENT_BEGIN, leaveEvent);
  yield takeLatest(EXPORT_ATTENDEES_BEGIN, exportAttendees);
}
