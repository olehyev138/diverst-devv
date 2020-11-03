/**
 * Test sagas
 */

import {
  getRegionLeaders,
  getRegionLeader,
  createRegionLeader,
  updateRegionLeader,
  deleteRegionLeader
} from 'containers/Region/RegionLeaders/saga';

import {
  getRegionLeaderError,
  getRegionLeaderSuccess,
  getRegionLeadersError,
  getRegionLeadersSuccess,
  createRegionLeaderError,
  createRegionLeaderSuccess,
  updateRegionLeaderError,
  updateRegionLeaderSuccess,
  deleteRegionLeaderError,
  deleteRegionLeaderSuccess,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from '../messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.regionLeaders.all = jest.fn();
api.regionLeaders.create = jest.fn();
api.regionLeaders.update = jest.fn();
api.regionLeaders.destroy = jest.fn();
api.regionLeaders.get = jest.fn();

const regionLeader = {
  id: 1,
  title: 'abc'
};

describe('Tests for regionLeaders saga', () => {
  describe('Get regionLeaders Saga', () => {
    it('Should return regionLeaderList', async () => {
      api.regionLeaders.all.mockImplementation(() => Promise.resolve({ data: { page: { ...regionLeader } } }));
      const results = [getRegionLeadersSuccess(regionLeader)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getRegionLeaders,
        initialAction
      );
      expect(api.regionLeaders.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.regionLeaders.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load regionLeaders',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getRegionLeadersError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getRegionLeaders,
        initialAction
      );

      expect(api.regionLeaders.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.errors.leaders);
    });
  });

  describe('Get regionLeader Saga', () => {
    it('Should return a region', async () => {
      api.regionLeaders.get.mockImplementation(() => Promise.resolve({ data: { ...regionLeader } }));
      const results = [getRegionLeaderSuccess(regionLeader)];
      const initialAction = { payload: { id: regionLeader.id } };

      const dispatched = await recordSaga(
        getRegionLeader,
        initialAction
      );
      expect(api.regionLeaders.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.regionLeaders.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get regionLeader',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getRegionLeaderError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getRegionLeader,
        initialAction
      );

      expect(api.regionLeaders.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.errors.leader);
    });
  });


  describe('Create regionLeader', () => {
    it('Should create a regionLeader', async () => {
      api.regionLeaders.create.mockImplementation(() => Promise.resolve({ data: { regionLeader } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'regionLeader created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createRegionLeaderSuccess(), push(ROUTES.region.leaders.index.path()), notified];
      const initialAction = { payload: {
        id: '',
      } };

      const dispatched = await recordSaga(
        createRegionLeader,
        initialAction
      );
      expect(api.regionLeaders.create).toHaveBeenCalledWith({ region_leader: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.success.create);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.regionLeaders.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create regionLeader',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createRegionLeaderError(response), notified];
      const initialAction = { payload: { region_leader: undefined } };
      const dispatched = await recordSaga(
        createRegionLeader,
        initialAction.payload
      );
      expect(api.regionLeaders.create).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.errors.create);
    });

    it('Should update a regionLeader', async () => {
      api.regionLeaders.update.mockImplementation(() => Promise.resolve({ data: { regionLeader } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'regionLeader updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updateRegionLeaderSuccess(), push(ROUTES.region.leaders.index.path()), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updateRegionLeader,
        initialAction
      );
      expect(api.regionLeaders.update).toHaveBeenCalledWith(initialAction.payload.id, { region_leader: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.success.update);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.regionLeaders.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update region',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateRegionLeaderError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        updateRegionLeader,
        initialAction
      );

      expect(api.regionLeaders.update).toHaveBeenCalledWith(initialAction.payload.id, { region_leader: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.errors.update);
    });
  });


  describe('Delete regionLeader', () => {
    it('Should delete a regionLeader', async () => {
      api.regionLeaders.destroy.mockImplementation(() => Promise.resolve({ data: { regionLeader } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'regionLeader deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteRegionLeaderSuccess(), push(ROUTES.region.leaders.index.path()), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deleteRegionLeader,
        initialAction
      );
      expect(api.regionLeaders.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.success.delete);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.regionLeaders.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete regionLeader',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteRegionLeaderError(response), notified];
      const initialAction = { payload: { regionLeader: undefined } };
      const dispatched = await recordSaga(
        deleteRegionLeader,
        initialAction
      );
      expect(api.regionLeaders.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.errors.delete);
    });
  });
});
