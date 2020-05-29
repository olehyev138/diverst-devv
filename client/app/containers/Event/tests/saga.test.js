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

beforeEach(() => {
  jest.resetAllMocks();
});

describe('Get Events Saga', () => {
  it('Should return eventlist', async () => {
    api.groups.all.mockImplementation(() => Promise.resolve({ data: { page: { ...group } } }));
    const results = [getEventsSuccess(group)];

    const initialAction = { payload: {
      count: 5,
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
        message: 'Failed to load groups',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getEventsError(response), notified];
    const initialAction = { payload: undefined };
    const dispatched = await recordSaga(
      getEvents,
      initialAction
    );

    expect(api.initiatives.all).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});
