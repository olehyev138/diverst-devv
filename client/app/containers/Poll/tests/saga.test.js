/**
 * Test sagas
 */

import {
  getPolls,
  getPoll,
  createPoll,
  updatePoll,
  deletePoll
} from 'containers/Poll/saga';

import {
  getPollError,
  getPollSuccess,
  getPollsError,
  getPollsSuccess,
  createPollError,
  createPollSuccess,
  updatePollError,
  updatePollSuccess,
  deletePollError,
  deletePollSuccess,
  pollsUnmount
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.polls.all = jest.fn();
api.polls.create = jest.fn();
api.polls.update = jest.fn();
api.polls.destroy = jest.fn();
api.polls.get = jest.fn();

const poll = {
  id: 1,
  title: 'abc'
};

describe('Get polls Saga', () => {
  it('Should return pollList', async () => {
    api.polls.all.mockImplementation(() => Promise.resolve({ data: { page: { ...poll } } }));
    const results = [getPollsSuccess(poll)];

    const initialAction = { payload: {
      count: 5,
    } };

    const dispatched = await recordSaga(
      getPolls,
      initialAction
    );
    expect(api.polls.all).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.polls.all.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to load polls',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getPollsError(response), notified];
    const initialAction = { payload: undefined };
    const dispatched = await recordSaga(
      getPolls,
      initialAction
    );

    expect(api.polls.all).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});

describe('Get poll Saga', () => {
  it('Should return a group', async () => {
    api.polls.get.mockImplementation(() => Promise.resolve({ data: { ...poll } }));
    const results = [getPollSuccess(poll)];
    const initialAction = { payload: { id: poll.id } };

    const dispatched = await recordSaga(
      getPoll,
      initialAction
    );
    expect(api.polls.get).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.polls.get.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to get poll',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getPollError(response), notified];
    const initialAction = { payload: { id: 5 } };
    const dispatched = await recordSaga(
      getPoll,
      initialAction
    );

    expect(api.polls.get).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });
});


describe('Create poll', () => {
  it('Should create a poll', async () => {
    api.polls.create.mockImplementation(() => Promise.resolve({ data: { poll } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'poll created',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createPollSuccess(), push(ROUTES.admin.include.polls.index.path()), notified];
    const initialAction = { payload: {
      id: '',
    } };

    const dispatched = await recordSaga(
      createPoll,
      initialAction
    );
    expect(api.polls.create).toHaveBeenCalledWith({ poll: initialAction.payload });
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.polls.create.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to create poll',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createPollError(response), notified];
    const initialAction = { payload: { poll: undefined } };
    const dispatched = await recordSaga(
      createPoll,
      initialAction.payload
    );
    expect(api.polls.create).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });

  it('Should update a poll', async () => {
    api.polls.update.mockImplementation(() => Promise.resolve({ data: { poll } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'poll updated',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const results = [updatePollSuccess(), push(ROUTES.admin.include.polls.index.path()), notified];
    const initialAction = { payload: {
      id: 1,
    } };
    const dispatched = await recordSaga(
      updatePoll,
      initialAction
    );
    expect(api.polls.update).toHaveBeenCalledWith(initialAction.payload.id, { poll: initialAction.payload });
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.polls.update.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to update group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updatePollError(response), notified];
    const initialAction = { payload: { id: 5, name: 'dragon' } };
    const dispatched = await recordSaga(
      updatePoll,
      initialAction
    );

    expect(api.polls.update).toHaveBeenCalledWith(initialAction.payload.id, { poll: initialAction.payload });
    expect(dispatched).toEqual(results);
  });
});


describe('Delete poll', () => {
  it('Should delete a poll', async () => {
    api.polls.destroy.mockImplementation(() => Promise.resolve({ data: { poll } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'poll deleted',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const results = [deletePollSuccess(), notified];

    const initialAction = { payload: {
      id: 1,
    } };

    const dispatched = await recordSaga(
      deletePoll,
      initialAction
    );
    expect(api.polls.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.polls.destroy.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete poll',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deletePollError(response), notified];
    const initialAction = { payload: { poll: undefined } };
    const dispatched = await recordSaga(
      deletePoll,
      initialAction
    );
    expect(api.polls.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });
});
