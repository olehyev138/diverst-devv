/**
 * Test sagas
 */

import {
  getResponses,
  getResponse,
  createResponse,
  updateResponse,
  deleteResponse
} from 'containers/Poll/Response/saga';

import {
  getResponseError,
  getResponseSuccess,
  getResponsesError,
  getResponsesSuccess,
  createResponseError,
  createResponseSuccess,
  updateResponseError,
  updateResponseSuccess,
  deleteResponseError,
  deleteResponseSuccess,
  responsesUnmount
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

it('Temporary test', async () => {
  expect(true).toEqual(true);
});
// Uncomment when api calls are completed
/*
api.responses.all = jest.fn();
api.responses.create = jest.fn();
api.responses.update = jest.fn();
api.responses.destroy = jest.fn();
api.responses.get = jest.fn();

const response = {
  id: 1,
  title: 'abc'
};

describe('Tests for responses saga', () => {
  describe('Get responses Saga', () => {
    it('Should return responseList', async () => {
      api.responses.all.mockImplementation(() => Promise.resolve({ data: { page: { ...response } } }));
      const results = [getResponsesSuccess(response)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getResponses,
        initialAction
      );
      expect(api.responses.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.responses.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load responses',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getResponsesError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getResponses,
        initialAction
      );

      expect(api.responses.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get response Saga', () => {
    it('Should return a group', async () => {
      api.responses.get.mockImplementation(() => Promise.resolve({ data: { ...response } }));
      const results = [getResponseSuccess(response)];
      const initialAction = { payload: { id: response.id } };

      const dispatched = await recordSaga(
        getResponse,
        initialAction
      );
      expect(api.responses.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.responses.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get response',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getResponseError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getResponse,
        initialAction
      );

      expect(api.responses.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });


  describe('Create response', () => {
    it('Should create a response', async () => {
      api.responses.create.mockImplementation(() => Promise.resolve({ data: { response } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'response created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createResponseSuccess(), push(ROUTES.admin.include.responses.index.path()), notified];
      const initialAction = { payload: {
        id: '',
      } };

      const dispatched = await recordSaga(
        createResponse,
        initialAction
      );
      expect(api.responses.create).toHaveBeenCalledWith({ response: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.responses.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create response',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createResponseError(response), notified];
      const initialAction = { payload: { response: undefined } };
      const dispatched = await recordSaga(
        createResponse,
        initialAction.payload
      );
      expect(api.responses.create).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should update a response', async () => {
      api.responses.update.mockImplementation(() => Promise.resolve({ data: { response } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'response updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updateResponseSuccess(), push(ROUTES.admin.include.responses.index.path()), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updateResponse,
        initialAction
      );
      expect(api.responses.update).toHaveBeenCalledWith(initialAction.payload.id, { response: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.responses.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateResponseError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        updateResponse,
        initialAction
      );

      expect(api.responses.update).toHaveBeenCalledWith(initialAction.payload.id, { response: initialAction.payload });
      expect(dispatched).toEqual(results);
    });
  });


  describe('Delete response', () => {
    it('Should delete a response', async () => {
      api.responses.destroy.mockImplementation(() => Promise.resolve({ data: { response } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'response deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteResponseSuccess(), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deleteResponse,
        initialAction
      );
      expect(api.responses.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.responses.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete response',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteResponseError(response), notified];
      const initialAction = { payload: { response: undefined } };
      const dispatched = await recordSaga(
        deleteResponse,
        initialAction
      );
      expect(api.responses.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });
});
*/
