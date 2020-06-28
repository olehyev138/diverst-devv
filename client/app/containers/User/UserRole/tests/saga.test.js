/**
 * Test sagas
 */

import {
  getUserRoles,
  getUserRole,
  createUserRole,
  updateUserRole,
  deleteUserRole
} from 'containers/User/UserRole/saga';

import {
  getUserRoleError,
  getUserRoleSuccess,
  getUserRolesError,
  getUserRolesSuccess,
  createUserRoleError,
  createUserRoleSuccess,
  updateUserRoleError,
  updateUserRoleSuccess,
  deleteUserRoleError,
  deleteUserRoleSuccess,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.userRoles.all = jest.fn();
api.userRoles.create = jest.fn();
api.userRoles.update = jest.fn();
api.userRoles.destroy = jest.fn();
api.userRoles.get = jest.fn();

// eslint-disable-next-line camelcase
const user_role = {
  id: 1,
  role_name: 'abc'
};

describe('tests for userRole saga', () => {
  describe('Get userRoles Saga', () => {
    it('Should return userRoleList', async () => {
      // eslint-disable-next-line camelcase
      api.userRoles.all.mockImplementation(() => Promise.resolve({ data: { page: { ...user_role } } }));
      const results = [getUserRolesSuccess(user_role)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getUserRoles,
        initialAction
      );
      expect(api.userRoles.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.userRoles.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load userRoles',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getUserRolesError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getUserRoles,
        initialAction
      );

      expect(api.userRoles.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get userRole Saga', () => {
    it('Should return a group', async () => {
      // eslint-disable-next-line camelcase
      api.userRoles.get.mockImplementation(() => Promise.resolve({ data: { ...user_role } }));
      const results = [getUserRoleSuccess(user_role)];
      const initialAction = { payload: { id: user_role.id } };

      const dispatched = await recordSaga(
        getUserRole,
        initialAction
      );
      expect(api.userRoles.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.userRoles.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get userRole',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getUserRoleError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getUserRole,
        initialAction
      );

      expect(api.userRoles.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });


  describe('Create userRole', () => {
    it('Should create a userRole', async () => {
      api.userRoles.create.mockImplementation(() => Promise.resolve({ data: { userRole: user_role } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'userRole created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createUserRoleSuccess(), push(ROUTES.admin.system.users.roles.index.path()), notified];
      const initialAction = { payload: {
        id: '',
      } };

      const dispatched = await recordSaga(
        createUserRole,
        initialAction
      );
      expect(api.userRoles.create).toHaveBeenCalledWith({ user_role: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.userRoles.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create userRole',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createUserRoleError(response), notified];
      const initialAction = { payload: { user_role: undefined } };
      const dispatched = await recordSaga(
        createUserRole,
        initialAction.payload
      );
      expect(api.userRoles.create).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('update userRole', () => {
    it('Should update a userRole', async () => {
      api.userRoles.update.mockImplementation(() => Promise.resolve({ data: { userRole: user_role } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'userRole updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updateUserRoleSuccess(), push(ROUTES.admin.system.users.roles.index.path()), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updateUserRole,
        initialAction
      );
      expect(api.userRoles.update).toHaveBeenCalledWith(initialAction.payload.id, { user_role: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.userRoles.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateUserRoleError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        updateUserRole,
        initialAction
      );

      expect(api.userRoles.update).toHaveBeenCalledWith(initialAction.payload.id, { user_role: initialAction.payload });
      expect(dispatched).toEqual(results);
    });
  });


  describe('Delete userRole', () => {
    it('Should delete a userRole', async () => {
      api.userRoles.destroy.mockImplementation(() => Promise.resolve({ data: { userRole: user_role } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'userRole deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteUserRoleSuccess(), push(ROUTES.admin.system.users.roles.index.path()), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deleteUserRole,
        initialAction
      );
      expect(api.userRoles.destroy).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.userRoles.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete userRole',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteUserRoleError(response), notified];
      const initialAction = { payload: { userRole: undefined } };
      const dispatched = await recordSaga(
        deleteUserRole,
        initialAction
      );
      expect(api.userRoles.destroy).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });
});
