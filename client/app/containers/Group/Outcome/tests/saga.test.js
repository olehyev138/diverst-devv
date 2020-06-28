/**
 * Test sagas
 */

import {
  getOutcomes,
  getOutcome,
  createOutcome,
  updateOutcome,
  deleteOutcome
} from 'containers/Group/Outcome/saga';

import {
  getOutcomeError,
  getOutcomeSuccess,
  getOutcomesError,
  getOutcomesSuccess,
  createOutcomeError,
  createOutcomeSuccess,
  updateOutcomeError,
  updateOutcomeSuccess,
  deleteOutcomeError,
  deleteOutcomeSuccess,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.outcomes.all = jest.fn();
api.outcomes.create = jest.fn();
api.outcomes.update = jest.fn();
api.outcomes.destroy = jest.fn();
api.outcomes.get = jest.fn();

const outcome = {
  id: 1,
  title: 'abc',
  group_id: 2,
};

describe('Tests for outcomes saga', () => {
  describe('Get outcomes Saga', () => {
    it('Should return outcomeList', async () => {
      api.outcomes.all.mockImplementation(() => Promise.resolve({ data: { page: { ...outcome } } }));
      const results = [getOutcomesSuccess(outcome)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getOutcomes,
        initialAction
      );
      expect(api.outcomes.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.outcomes.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load outcomes',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getOutcomesError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getOutcomes,
        initialAction
      );

      expect(api.outcomes.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get outcome Saga', () => {
    it('Should return a group', async () => {
      api.outcomes.get.mockImplementation(() => Promise.resolve({ data: { ...outcome } }));
      const results = [getOutcomeSuccess(outcome)];
      const initialAction = { payload: { id: outcome.id } };

      const dispatched = await recordSaga(
        getOutcome,
        initialAction
      );
      expect(api.outcomes.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.outcomes.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get outcome',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getOutcomeError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getOutcome,
        initialAction
      );

      expect(api.outcomes.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });


  describe('Create outcome', () => {
    it('Should create a outcome', async () => {
      api.outcomes.create.mockImplementation(() => Promise.resolve({ data: { outcome } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'outcome created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createOutcomeSuccess(), push(ROUTES.group.plan.outcomes.index.path()), notified];
      const initialAction = { payload: {
        id: '',
      } };

      const dispatched = await recordSaga(
        createOutcome,
        initialAction
      );
      expect(api.outcomes.create).toHaveBeenCalledWith({ outcome: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.outcomes.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create outcome',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createOutcomeError(response), notified];
      const initialAction = { payload: { outcome: undefined } };
      const dispatched = await recordSaga(
        createOutcome,
        initialAction.payload
      );
      expect(api.outcomes.create).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should update a outcome', async () => {
      api.outcomes.update.mockImplementation(() => Promise.resolve({ data: { outcome } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'outcome updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updateOutcomeSuccess(), push(ROUTES.group.plan.outcomes.index.path()), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updateOutcome,
        initialAction
      );
      expect(api.outcomes.update).toHaveBeenCalledWith(initialAction.payload.id, { outcome: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.outcomes.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateOutcomeError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        updateOutcome,
        initialAction
      );

      expect(api.outcomes.update).toHaveBeenCalledWith(initialAction.payload.id, { outcome: initialAction.payload });
      expect(dispatched).toEqual(results);
    });
  });


  describe('Delete outcome', () => {
    it('Should delete a outcome', async () => {
      api.outcomes.destroy.mockImplementation(() => Promise.resolve({ data: { outcome } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'outcome deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteOutcomeSuccess(), push(ROUTES.group.plan.outcomes.index.path()), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deleteOutcome,
        initialAction
      );
      expect(api.outcomes.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.outcomes.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete outcome',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteOutcomeError(response), notified];
      const initialAction = { payload: { outcome: undefined } };
      const dispatched = await recordSaga(
        deleteOutcome,
        initialAction
      );
      expect(api.outcomes.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });
});
