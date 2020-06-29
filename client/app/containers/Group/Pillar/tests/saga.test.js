/**
 * Test sagas
 */

import {
  getPillars,
  getPillar,
  createPillar,
  updatePillar,
  deletePillar
} from 'containers/Group/Pillar/saga';

import {
  getPillarError,
  getPillarSuccess,
  getPillarsError,
  getPillarsSuccess,
  createPillarError,
  createPillarSuccess,
  updatePillarError,
  updatePillarSuccess,
  deletePillarError,
  deletePillarSuccess,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.pillars.all = jest.fn();
api.pillars.create = jest.fn();
api.pillars.update = jest.fn();
api.pillars.destroy = jest.fn();
api.pillars.get = jest.fn();

const pillar = {
  id: 1,
  title: 'abc'
};

describe('Tests for pillars saga', () => {
  describe('Get pillars Saga', () => {
    it('Should return pillarList', async () => {
      api.pillars.all.mockImplementation(() => Promise.resolve({ data: { page: { ...pillar } } }));
      const results = [getPillarsSuccess(pillar)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getPillars,
        initialAction
      );
      expect(api.pillars.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.pillars.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load pillars',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getPillarsError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getPillars,
        initialAction
      );

      expect(api.pillars.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get pillar Saga', () => {
    it('Should return a group', async () => {
      api.pillars.get.mockImplementation(() => Promise.resolve({ data: { ...pillar } }));
      const results = [getPillarSuccess(pillar)];
      const initialAction = { payload: { id: pillar.id } };

      const dispatched = await recordSaga(
        getPillar,
        initialAction
      );
      expect(api.pillars.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.pillars.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get pillar',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getPillarError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getPillar,
        initialAction
      );

      expect(api.pillars.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });


  xdescribe('Create pillar', () => {
    it('Should create a pillar', async () => {
      api.pillars.create.mockImplementation(() => Promise.resolve({ data: { pillar } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'pillar created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createPillarSuccess(), notified];
      const initialAction = { payload: {
        id: '',
      } };

      const dispatched = await recordSaga(
        createPillar,
        initialAction
      );
      expect(api.pillars.create).toHaveBeenCalledWith({ pillar: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.pillars.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create pillar',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createPillarError(response), notified];
      const initialAction = { payload: { pillar: undefined } };
      const dispatched = await recordSaga(
        createPillar,
        initialAction.payload
      );
      expect(api.pillars.create).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should update a pillar', async () => {
      api.pillars.update.mockImplementation(() => Promise.resolve({ data: { pillar } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'pillar updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updatePillarSuccess(), push(ROUTES.admin.include.pillars.index.path()), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updatePillar,
        initialAction
      );
      expect(api.pillars.update).toHaveBeenCalledWith(initialAction.payload.id, { pillar: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.pillars.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updatePillarError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        updatePillar,
        initialAction
      );

      expect(api.pillars.update).toHaveBeenCalledWith(initialAction.payload.id, { pillar: initialAction.payload });
      expect(dispatched).toEqual(results);
    });
  });


  xdescribe('Delete pillar', () => {
    it('Should delete a pillar', async () => {
      api.pillars.destroy.mockImplementation(() => Promise.resolve({ data: { pillar } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'pillar deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deletePillarSuccess(), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deletePillar,
        initialAction
      );
      expect(api.pillars.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.pillars.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete pillar',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deletePillarError(response), notified];
      const initialAction = { payload: { pillar: undefined } };
      const dispatched = await recordSaga(
        deletePillar,
        initialAction
      );
      expect(api.pillars.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });
});
