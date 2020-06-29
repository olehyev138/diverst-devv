/**
 * Test sagas
 */

import {
  getGroupLeaders,
  getGroupLeader,
  createGroupLeader,
  updateGroupLeader,
  deleteGroupLeader
} from 'containers/Group/GroupManage/GroupLeaders/saga';

import {
  getGroupLeaderError,
  getGroupLeaderSuccess,
  getGroupLeadersError,
  getGroupLeadersSuccess,
  createGroupLeaderError,
  createGroupLeaderSuccess,
  updateGroupLeaderError,
  updateGroupLeaderSuccess,
  deleteGroupLeaderError,
  deleteGroupLeaderSuccess,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.groupLeaders.all = jest.fn();
api.groupLeaders.create = jest.fn();
api.groupLeaders.update = jest.fn();
api.groupLeaders.destroy = jest.fn();
api.groupLeaders.get = jest.fn();

const groupLeader = {
  id: 1,
  title: 'abc'
};

describe('Tests for groupLeaders saga', () => {
  describe('Get groupLeaders Saga', () => {
    it('Should return groupLeaderList', async () => {
      api.groupLeaders.all.mockImplementation(() => Promise.resolve({ data: { page: { ...groupLeader } } }));
      const results = [getGroupLeadersSuccess(groupLeader)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getGroupLeaders,
        initialAction
      );
      expect(api.groupLeaders.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupLeaders.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groupLeaders',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getGroupLeadersError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getGroupLeaders,
        initialAction
      );

      expect(api.groupLeaders.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get groupLeader Saga', () => {
    it('Should return a group', async () => {
      api.groupLeaders.get.mockImplementation(() => Promise.resolve({ data: { ...groupLeader } }));
      const results = [getGroupLeaderSuccess(groupLeader)];
      const initialAction = { payload: { id: groupLeader.id } };

      const dispatched = await recordSaga(
        getGroupLeader,
        initialAction
      );
      expect(api.groupLeaders.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupLeaders.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get groupLeader',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getGroupLeaderError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getGroupLeader,
        initialAction
      );

      expect(api.groupLeaders.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });


  describe('Create groupLeader', () => {
    it('Should create a groupLeader', async () => {
      api.groupLeaders.create.mockImplementation(() => Promise.resolve({ data: { groupLeader } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'groupLeader created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createGroupLeaderSuccess(), push(ROUTES.group.manage.leaders.index.path()), notified];
      const initialAction = { payload: {
        id: '',
      } };

      const dispatched = await recordSaga(
        createGroupLeader,
        initialAction
      );
      expect(api.groupLeaders.create).toHaveBeenCalledWith({ group_leader: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupLeaders.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create groupLeader',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createGroupLeaderError(response), notified];
      const initialAction = { payload: { group_leader: undefined } };
      const dispatched = await recordSaga(
        createGroupLeader,
        initialAction.payload
      );
      expect(api.groupLeaders.create).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should update a groupLeader', async () => {
      api.groupLeaders.update.mockImplementation(() => Promise.resolve({ data: { groupLeader } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'groupLeader updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updateGroupLeaderSuccess(), push(ROUTES.group.manage.leaders.index.path()), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updateGroupLeader,
        initialAction
      );
      expect(api.groupLeaders.update).toHaveBeenCalledWith(initialAction.payload.id, { group_leader: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupLeaders.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateGroupLeaderError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        updateGroupLeader,
        initialAction
      );

      expect(api.groupLeaders.update).toHaveBeenCalledWith(initialAction.payload.id, { group_leader: initialAction.payload });
      expect(dispatched).toEqual(results);
    });
  });


  describe('Delete groupLeader', () => {
    it('Should delete a groupLeader', async () => {
      api.groupLeaders.destroy.mockImplementation(() => Promise.resolve({ data: { groupLeader } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'groupLeader deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteGroupLeaderSuccess(), push(ROUTES.group.manage.leaders.index.path()), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deleteGroupLeader,
        initialAction
      );
      expect(api.groupLeaders.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupLeaders.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete groupLeader',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteGroupLeaderError(response), notified];
      const initialAction = { payload: { groupLeader: undefined } };
      const dispatched = await recordSaga(
        deleteGroupLeader,
        initialAction
      );
      expect(api.groupLeaders.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });
});
