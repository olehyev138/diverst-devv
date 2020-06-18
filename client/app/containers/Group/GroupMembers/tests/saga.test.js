/**
 * Test sagas
 */

import {
  getMembers,
  createMembers,
  deleteMembers,
  exportMembers
} from 'containers/Group/GroupMembers/saga';

import {
  getMembersError,
  getMembersSuccess,
  deleteMemberError,
  deleteMemberSuccess,
  createMembersSuccess,
  createMembersError,
  exportMembersSuccess,
  exportMembersError,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.userGroups.all = jest.fn();
api.groupMembers.addMembers = jest.fn();
api.groupMembers.removeMembers = jest.fn();
api.userGroups.csvExport = jest.fn();

const member = {
  id: 1,
  title: 'abc',
  group_id: 2,
};

describe('Tests for members saga', () => {
  describe('Get members Saga', () => {
    it('Should return memberList', async () => {
      api.userGroups.all.mockImplementation(() => Promise.resolve({ data: { page: { ...member } } }));
      const results = [getMembersSuccess(member)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getMembers,
        initialAction
      );
      expect(api.userGroups.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.userGroups.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load members',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getMembersError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getMembers,
        initialAction
      );

      expect(api.userGroups.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Create member', () => {
    it('Should create a member', async () => {
      api.groupMembers.addMembers.mockImplementation(() => Promise.resolve({ data: { member } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'member created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createMembersSuccess(), push(ROUTES.group.members.index.path(6)), notified];
      const initialAction = { payload: { groupId: 6, attributes: { member_ids: 6, group_id: 6 } } };

      const dispatched = await recordSaga(
        createMembers,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupMembers.addMembers.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create member',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createMembersError(response), notified];
      const initialAction = { payload: { groupId: 6, attributes: { member_ids: 6 } } };
      const dispatched = await recordSaga(
        createMembers,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });
  });

  describe('Delete member', () => {
    it('Should delete a member', async () => {
      api.groupMembers.removeMembers.mockImplementation(() => Promise.resolve({ data: { member } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'member deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteMemberSuccess(), push(ROUTES.group.members.index.path()), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deleteMembers,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupMembers.removeMembers.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete member',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteMemberError(response), notified];
      const initialAction = { payload: { member: undefined } };
      const dispatched = await recordSaga(
        deleteMembers,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });
  });

  // TODO : Complete
  xdescribe('Delete member', () => {
    it('Should export a member', async () => {
      api.groupMembers.removeMembers.mockImplementation(() => Promise.resolve({ data: { member } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'member exportd',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [exportMembersSuccess(), push(ROUTES.group.members.index.path()), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        exportMembers,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupMembers.removeMembers.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to export member',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [exportMembersError(response), notified];
      const initialAction = { payload: { member: undefined } };
      const dispatched = await recordSaga(
        exportMembers,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });
  });
});
