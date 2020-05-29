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
  exportAttendeesSuccess, exportAttendeesError,
  leaveEventSuccess, leaveEventError
} from 'containers/Event/actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';


api.initiatives.all = jest.fn();
api.initiatives.get = jest.fn();
api.initiatives.create = jest.fn();
api.initiatives.update = jest.fn();
api.initiatives.destroy = jest.fn();
api.initiatives.finalizeExpenses = jest.fn();
api.initiativeComments.destroy = jest.fn();
api.initiativeComments.create = jest.fn();
api.initiatives.archive = jest.fn();
api.initiativeUsers.join = jest.fn();
api.initiativeUsers.leave = jest.fn();
api.initiativeUsers.csvExport = jest.fn();


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

const event = {
  id: '',
  name: 'Dummy event',
  description: 'whatever',
  picture: null,
  max_attendees: '',
  location: '123',
  budget_item_id: null,
  estimated_funding: '',
  currency: 'USD',
  finished_expenses: false,
  pillar_id: 2,
  owner_id: '',
  owner_group_id: 1
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

describe('Create event', () => {
  it('Should create an event', async () => {
    api.initiatives.create.mockImplementation(() => Promise.resolve({ data: { event } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'group created',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createEventSuccess(), push(ROUTES.group.events.index.path(event.owner_group_id)), notified];
    const initialAction = { payload: event };

    const dispatched = await recordSaga(
      createEvent,
      initialAction
    );

    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiatives.create.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to create group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createEventError(response), notified];
    const initialAction = { payload: { event: undefined } };
    const dispatched = await recordSaga(
      createEvent,
      initialAction.payload
    );
    expect(api.initiatives.create).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});

describe('Update event', () => {
  it('Should update an event', async () => {
    api.initiatives.update.mockImplementation(() => Promise.resolve({ data: { event } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'group updated',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const results = [updateEventSuccess(), push(ROUTES.group.events.show.path(event.owner_group_id, event.id)), notified];
    const initialAction = { payload: event };
    const dispatched = await recordSaga(
      updateEvent,
      initialAction
    );
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiatives.update.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to update group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateEventError(response), notified];
    const initialAction = { payload: { id: 5, name: 'dragon' } };
    const dispatched = await recordSaga(
      updateEvent,
      initialAction
    );

    expect(api.initiatives.update).toHaveBeenCalledWith(initialAction.payload.id, { initiative: initialAction.payload });
    expect(dispatched).toEqual(results);
  });
});

describe('Delete event', () => {
  it('Should delete an event', async () => {
    api.initiatives.destroy.mockImplementation(() => Promise.resolve({ data: { event } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'group deleted',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const results = [deleteEventSuccess(), push(ROUTES.group.events.index.path(event.group_id)), notified];

    const initialAction = { payload: {
      id: 1,
    } };

    const dispatched = await recordSaga(
      deleteEvent,
      initialAction
    );


    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiatives.destroy.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteEventError(response), notified];
    const initialAction = { payload: { group_id: undefined, id: undefined } };
    const dispatched = await recordSaga(
      deleteEvent,
      initialAction
    );
    expect(api.initiatives.destroy).toHaveBeenCalledWith(initialAction.payload.group_id);
    expect(dispatched).toEqual(results);
  });
});

describe('Delete comment', () => {
  it('Should delete a comment', async () => {
    api.initiativeComments.destroy.mockImplementation(() => Promise.resolve({ data: { event } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'group deleted',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const results = [deleteEventCommentSuccess(), getEventBegin({ id: 2 }), notified];

    const initialAction = { payload: {
      id: 1,
      initiative_id: 2
    } };

    const dispatched = await recordSaga(
      deleteEventComment,
      initialAction
    );

    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiativeComments.destroy.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteEventCommentError(response), notified];
    const initialAction = { payload: { id: undefined, initiative_id: undefined } };
    const dispatched = await recordSaga(
      deleteEventComment,
      initialAction
    );
    expect(api.initiativeComments.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });
});

describe('Create comment', () => {
  it('Should create a comment', async () => {
    api.initiativeComments.create.mockImplementation(() => Promise.resolve({ data: { event } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'group deleted',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const results = [createEventCommentSuccess(), getEventBegin({ id: 2 }), notified];

    const initialAction = { payload: { attributes: { id: 1, initiative_id: 2 } } };

    const dispatched = await recordSaga(
      createEventComment,
      initialAction
    );

    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiativeComments.create.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createEventCommentError(response), notified];
    const initialAction = { payload: { id: undefined, initiative_id: undefined } };
    const dispatched = await recordSaga(
      createEventComment,
      initialAction
    );
    expect(api.initiativeComments.create).toHaveBeenCalledWith({ initiative_comment: initialAction.payload.id });
    expect(dispatched).toEqual(results);
  });
});

describe('Archive event', () => {
  it('Should archive an event', async () => {
    api.initiatives.archive.mockImplementation(() => Promise.resolve({ data: { event } }));
    const results = [archiveEventSuccess(), push(ROUTES.group.events.index.path(event.group_id))];

    const initialAction = { payload: event };

    const dispatched = await recordSaga(
      archiveEvent,
      initialAction
    );

    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiatives.archive.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [archiveEventError(response), notified];
    const initialAction = { payload: event };
    const dispatched = await recordSaga(
      archiveEvent,
      initialAction
    );
    expect(api.initiatives.archive).toHaveBeenCalledWith(event.id, { initiative: event });
    expect(dispatched).toEqual(results);
  });
});

describe('Join event', () => {
  it('Should join an event', async () => {
    api.initiativeUsers.join.mockImplementation(() => Promise.resolve({ data: { event } }));
    const results = [joinEventSuccess({ initiative_user: { initiative_id: 22 } })];

    const initialAction = { payload: { initiative_id: 22 } };

    const dispatched = await recordSaga(
      joinEvent,
      initialAction
    );

    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiativeUsers.join.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [joinEventError(response), notified];
    const initialAction = { payload: event };
    const dispatched = await recordSaga(
      joinEvent,
      initialAction
    );
    expect(api.initiativeUsers.join).toHaveBeenCalledWith({ initiative_user: event });
    expect(dispatched).toEqual(results);
  });
});

describe('Leave event', () => {
  it('Should leave an event', async () => {
    api.initiativeUsers.leave.mockImplementation(() => Promise.resolve({ data: { event } }));
    const results = [leaveEventSuccess({ initiative_user: { initiative_id: 22 } })];

    const initialAction = { payload: { initiative_id: 22 } };

    const dispatched = await recordSaga(
      leaveEvent,
      initialAction
    );

    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiativeUsers.leave.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [leaveEventError(response), notified];
    const initialAction = { payload: undefined };
    const dispatched = await recordSaga(
      leaveEvent,
      initialAction
    );
    expect(api.initiativeUsers.leave).toHaveBeenCalledWith({ initiative_user: undefined });
    expect(dispatched).toEqual(results);
  });
});
// TODO
describe('finalize expenses', () => {
  xit('Should finalize an expense', async () => {
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    api.initiatives.finalizeExpenses.mockImplementation(() => Promise.resolve({ data: { event } }));
    const results = [finalizeExpensesSuccess({ event }), notified];

    const initialAction = { payload: { initiative_id: 22 } };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const dispatched = await recordSaga(
      finalizeExpenses,
      initialAction
    );

    expect(dispatched).toEqual(results);
  });

  xit('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiativeUsers.leave.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [finalizeExpensesError(response), notified];
    const initialAction = { payload: { id: 5 } };
    const dispatched = await recordSaga(
      finalizeExpenses,
      initialAction
    );
    expect(api.initiatives.finalizeExpenses).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });
});

// TODO
describe('Export event attendees', () => {
  xit('Should export attendees', async () => {
    api.initiativeUsers.exportCsv.mockImplementation(() => Promise.resolve({ data: { event } }));
    const results = [exportAttendeesSuccess()];

    const initialAction = { payload: { initiative_id: 22 } };

    const dispatched = await recordSaga(
      exportAttendees,
      initialAction
    );

    expect(dispatched).toEqual(results);
  });

  xit('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.initiativeUsers.leave.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [leaveEventError(response), notified];
    const initialAction = { payload: undefined };
    const dispatched = await recordSaga(
      leaveEvent,
      initialAction
    );
    expect(api.initiativeUsers.leave).toHaveBeenCalledWith({ initiative_user: undefined });
    expect(dispatched).toEqual(results);
  });
});
