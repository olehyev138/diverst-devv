/**
 * Test sagas
 */

import {
  getEvents, getEvent,
  createEvent, updateEvent,
  deleteEventComment, deleteEvent, createEventComment,
  archiveEvent, finalizeExpenses, joinEvent,
  leaveEvent, exportAttendees
} from 'containers/Event/saga';

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
  exportAttendeesSuccess, exportAttendeesError, leaveEventSuccess
} from 'containers/Event/actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.initiatives.all = jest.fn();
api.initiatives.get = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

const groupRequest = {
  count: 10,
  page: 0,
  order: 'asc',
  orderBy: 'start',
  group_id: 5,
  query_scopes: [
    'upcoming',
    'not_archived'
  ]
};

describe('Get Events Saga', () => {
  it('Should return eventlist', async () => {
    api.initiatives.all.mockImplementation(() => Promise.resolve({ data: { page: { ...groupRequest } } }));
    const results = [getEventsSuccess(groupRequest)];

    const initialAction = { payload: {
      ...groupRequest
    } };

    const dispatched = await recordSaga(
      getEvents,
      initialAction
    );
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiatives.all.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to load events',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getEventsError({ annualBudgetId: undefined }, response), notified];
    const initialAction = { payload: { ...groupRequest } };
    const dispatched = await recordSaga(
      getEvents,
      initialAction
    );

    expect(api.initiatives.all).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});

describe('Get Event Saga', () => {
  it('Should return an event', async () => {
    api.initiatives.get.mockImplementation(() => Promise.resolve({ data: { id: 4 } }));
    const results = [getEventSuccess({ id: 4 })];
    const initialAction = { payload: { id: 4 } };

    const dispatched = await recordSaga(
      getEvent,
      initialAction
    );
    expect(api.initiatives.get).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiatives.get.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to get event',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getEventError(response), notified];
    const initialAction = { payload: { id: 5 } };
    const dispatched = await recordSaga(
      getEvent,
      initialAction
    );

    expect(api.initiatives.get).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });
});
