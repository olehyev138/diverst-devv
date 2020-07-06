/**
 * Test sagas
 */

import {
  getUsers,
  getUser,
  createUser,
  updateUser,
  deleteUser,
  getUserPosts,
  getUserEvents,
  getUserDownloads,
  updateFieldData,
  exportUsers,
  getUserDownloadData,
  getUserPrototype
} from 'containers/User/saga';

import {
  getUsersSuccess, getUsersError,
  getUserSuccess, getUserError,
  createUserSuccess, createUserError,
  updateUserSuccess, updateUserError,
  deleteUserSuccess, deleteUserError,
  getUserPostsSuccess, getUserPostsError,
  getUserEventsSuccess, getUserEventsError,
  getUserDownloadsError, getUserDownloadsSuccess,
  updateFieldDataSuccess, updateFieldDataError,
  exportUsersSuccess, exportUsersError,
  getUserDownloadDataSuccess, getUserDownloadDataError,
  getUserPrototypeSuccess, getUserPrototypeError,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.users.all = jest.fn();
api.users.create = jest.fn();
api.users.update = jest.fn();
api.users.destroy = jest.fn();
api.users.get = jest.fn();
api.users.csvExport = jest.fn();
api.users.prototype = jest.fn();

api.user.getDownloads = jest.fn();
api.user.getDownloadData = jest.fn();
api.user.getPosts = jest.fn();

api.initiatives.all = jest.fn();

api.fieldData.updateFieldData = jest.fn();


const user = {
  id: 1,
  first_name: 'abc'
};

describe('saga tests for users', () => {
  describe('Get users Saga', () => {
    it('Should return userList', async () => {
      api.users.all.mockImplementation(() => Promise.resolve({ data: { page: { ...user } } }));
      const results = [getUsersSuccess(user)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getUsers,
        initialAction
      );
      expect(api.users.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.users.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load users',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getUsersError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getUsers,
        initialAction
      );

      expect(api.users.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get user Saga', () => {
    it('Should return a group', async () => {
      api.users.get.mockImplementation(() => Promise.resolve({ data: { ...user } }));
      const results = [getUserSuccess(user)];
      const initialAction = { payload: { id: user.id } };

      const dispatched = await recordSaga(
        getUser,
        initialAction
      );
      expect(api.users.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.users.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get user',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getUserError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getUser,
        initialAction
      );

      expect(api.users.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });


  describe('Create user', () => {
    it('Should create a user', async () => {
      api.users.create.mockImplementation(() => Promise.resolve({ data: { user } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'user created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createUserSuccess(), push(ROUTES.admin.system.users.index.path()), notified];
      const initialAction = { payload: {
        id: '',
      } };

      const dispatched = await recordSaga(
        createUser,
        initialAction
      );
      expect(api.users.create).toHaveBeenCalledWith({ user: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.users.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create user',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createUserError(response), notified];
      const initialAction = { payload: { user: undefined } };
      const dispatched = await recordSaga(
        createUser,
        initialAction.payload
      );
      expect(api.users.create).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should update a user', async () => {
      api.users.update.mockImplementation(() => Promise.resolve({ data: { user } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'user updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updateUserSuccess(), push(ROUTES.admin.system.users.index.path()), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updateUser,
        initialAction
      );
      expect(api.users.update).toHaveBeenCalledWith(initialAction.payload.id, { user: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.users.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateUserError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        updateUser,
        initialAction
      );

      expect(api.users.update).toHaveBeenCalledWith(initialAction.payload.id, { user: initialAction.payload });
      expect(dispatched).toEqual(results);
    });
  });


  describe('Delete user', () => {
    it('Should delete a user', async () => {
      api.users.destroy.mockImplementation(() => Promise.resolve({ data: { user } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'user deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteUserSuccess(), push(ROUTES.admin.system.users.index.path()), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deleteUser,
        initialAction
      );
      expect(api.users.destroy).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.users.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete user',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteUserError(response), notified];
      const initialAction = { payload: { user: undefined } };
      const dispatched = await recordSaga(
        deleteUser,
        initialAction
      );
      expect(api.users.destroy).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get user prototype', () => {
    it('Should get the user prototype', async () => {
      api.users.prototype.mockImplementation(() => Promise.resolve({ data: { ...user } }));

      const results = [getUserPrototypeSuccess(user)];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getUserPrototype,
        initialAction
      );
      expect(api.users.prototype).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.users.prototype.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete user',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getUserPrototypeError(response), notified];
      const initialAction = { payload: { user: undefined } };
      const dispatched = await recordSaga(
        getUserPrototype,
        initialAction
      );
      expect(api.users.prototype).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get user download data', () => {
    // TODO complete this test
    xit('Should get the user download data', async () => {
      api.user.getDownloadData.mockImplementation(() => Promise.resolve({ data: { ...user } }));

      const results = [getUserDownloadDataSuccess(user)];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getUserDownloadData,
        initialAction
      );
      expect(api.user.getDownloadData).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.user.getDownloadData.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete user',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getUserDownloadDataError(response), notified];
      const initialAction = { payload: { user: undefined } };
      const dispatched = await recordSaga(
        getUserDownloadData,
        initialAction
      );
      expect(api.user.getDownloadData).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get user posts', () => {
    it('Should get the user posts', async () => {
      api.user.getPosts.mockImplementation(() => Promise.resolve({ data: { page: { ...user } } }));

      const results = [getUserPostsSuccess(user)];

      const initialAction = { payload: {
        user
      } };

      const dispatched = await recordSaga(
        getUserPosts,
        initialAction
      );
      expect(api.user.getPosts).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.user.getPosts.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete user',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getUserPostsError(response), notified];
      const initialAction = { payload: { user: undefined } };
      const dispatched = await recordSaga(
        getUserPosts,
        initialAction
      );
      expect(api.user.getPosts).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get user events', () => {
    it('Should get the user events', async () => {
      api.initiatives.all.mockImplementation(() => Promise.resolve({ data: { page: { ...user } } }));

      const results = [getUserEventsSuccess(user)];

      const initialAction = { payload: {
        count: 10,
        page: 0,
        order: 'desc',
        orderBy: 'start',
        userId: 1,
        query_scopes: [
          'upcoming',
          'not_archived'
        ],
        participation: 'participation'
      } };

      const dispatched = await recordSaga(
        getUserEvents,
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
          message: 'Failed to delete user',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getUserEventsError(response), notified];
      const initialAction = { payload: {
        count: 10,
        page: 0,
        order: 'desc',
        orderBy: 'start',
        userId: 1,
        query_scopes: [
          'upcoming',
          'not_archived'
        ],
        participation: 'participation'
      } };
      const dispatched = await recordSaga(
        getUserEvents,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get user downloads', () => {
    it('Should get the user downloads', async () => {
      api.user.getDownloads.mockImplementation(() => Promise.resolve({ data: { page: { ...user } } }));

      const results = [getUserDownloadsSuccess(user)];

      const initialAction = { payload: {
        user
      } };

      const dispatched = await recordSaga(
        getUserDownloads,
        initialAction
      );
      expect(api.user.getDownloads).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.user.getDownloads.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete user',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getUserDownloadsError(response), notified];
      const initialAction = { payload: { user: undefined } };
      const dispatched = await recordSaga(
        getUserDownloads,
        initialAction
      );
      expect(api.user.getDownloads).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('should update field data', () => {
    it('Should update the field data', async () => {
      api.fieldData.updateFieldData.mockImplementation(() => Promise.resolve({ data: { user } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'user updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updateFieldDataSuccess(), notified];
      const initialAction = { payload: { id: 5, name: 'dragon', field_data: {} } };
      const dispatched = await recordSaga(
        updateFieldData,
        initialAction
      );
      expect(api.fieldData.updateFieldData).toHaveBeenCalledWith({ field_data: { field_data: {} } });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.fieldData.updateFieldData.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateFieldDataError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon', field_data: {} } };
      const dispatched = await recordSaga(
        updateFieldData,
        initialAction
      );

      expect(api.fieldData.updateFieldData).toHaveBeenCalledWith({ field_data: { field_data: {} } });
      expect(dispatched).toEqual(results);
    });
  });
});
