/**
 * Test sagas
 */

import {
  getFoldersSuccess, getFoldersError,
  getFolderSuccess, getFolderError,
  createFolderSuccess, createFolderError,
  updateFolderSuccess, updateFolderError,
  deleteFolderError,
  getResourcesSuccess, getResourcesError,
  getResourceSuccess, getResourceError,
  createResourceSuccess, createResourceError,
  updateResourceSuccess, updateResourceError,
  deleteResourceError,
  validateFolderPasswordSuccess, validateFolderPasswordError,
  deleteFolderSuccess, deleteResourceSuccess,
  archiveResourceError, archiveResourceSuccess,
  getFileDataSuccess, getFileDataError,
} from 'containers/Resource/actions';

import {
  getFolders,
  getFolder,
  createFolder,
  updateFolder,
  deleteFolder,
  getResources,
  getResource,
  createResource,
  updateResource,
  deleteResource,
  validateFolderPassword,
  archiveResource,
  getResourceFileData,
} from 'containers/Resource/saga';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.folders.all = jest.fn();
api.folders.create = jest.fn();
api.folders.update = jest.fn();
api.folders.destroy = jest.fn();
api.folders.get = jest.fn();

api.folders.validatePassword = jest.fn();

api.resources.all = jest.fn();
api.resources.create = jest.fn();
api.resources.update = jest.fn();
api.resources.destroy = jest.fn();
api.resources.get = jest.fn();

api.resources.archive = jest.fn();
api.resources.getFileData = jest.fn();

const folder = {
  id: 1,
  title: 'abc'
};

const resource = {
  id: 5,
  name: 'xyz',
  file_content_type: 'av'
};

describe('Tests for folders', () => {
  describe('Get folders Saga', () => {
    it('Should return folders', async () => {
      api.folders.all.mockImplementation(() => Promise.resolve({ data: { page: { ...folder } } }));
      const results = [getFoldersSuccess(folder)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getFolders,
        initialAction
      );
      expect(api.folders.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.folders.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load folders',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getFoldersError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getFolders,
        initialAction
      );

      expect(api.folders.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get folders Saga', () => {
    it('Should return a folder', async () => {
      api.folders.get.mockImplementation(() => Promise.resolve({ data: { ...folder } }));
      const results = [getFolderSuccess(folder)];
      const initialAction = { payload: { id: folder.id } };

      const dispatched = await recordSaga(
        getFolder,
        initialAction
      );
      expect(api.folders.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.folders.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get folder',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getFolderError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getFolder,
        initialAction
      );

      expect(api.folders.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });


  describe('Create folder', () => {
    it('Should create a folder', async () => {
      api.folders.create.mockImplementation(() => Promise.resolve({ data: { folder } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'folder created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createFolderSuccess(), push(null), notified];
      const initialAction = { payload: {
        id: '',
      } };

      const dispatched = await recordSaga(
        createFolder,
        initialAction
      );
      expect(api.folders.create).toHaveBeenCalledWith({ folder: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.folders.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create folder',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createFolderError(response), notified];
      const initialAction = { payload: { id: '', group_id: 2 } };
      const dispatched = await recordSaga(
        createFolder,
        initialAction
      );
      expect(api.folders.create).toHaveBeenCalledWith({ folder: initialAction.payload, group_id: 2 });
      expect(dispatched).toEqual(results);
    });
  });

  describe('update folder', () => {
    it('Should update a folder', async () => {
      api.folders.update.mockImplementation(() => Promise.resolve({ data: { folder } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'folder updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updateFolderSuccess(), push(null), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updateFolder,
        initialAction
      );
      expect(api.folders.update).toHaveBeenCalledWith(initialAction.payload.id, { folder: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.folders.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update folder',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateFolderError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        updateFolder,
        initialAction
      );

      expect(api.folders.update).toHaveBeenCalledWith(initialAction.payload.id, { folder: initialAction.payload });
      expect(dispatched).toEqual(results);
    });
  });

  describe('Delete folder', () => {
    it('Should delete a folder', async () => {
      api.folders.destroy.mockImplementation(() => Promise.resolve({ data: { folder } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'folder deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteFolderSuccess(), push(null), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deleteFolder,
        initialAction
      );
      expect(api.folders.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.folders.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete folder',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteFolderError(response), notified];
      const initialAction = { payload: { folder: undefined } };
      const dispatched = await recordSaga(
        deleteFolder,
        initialAction
      );
      expect(api.folders.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Validate password for a folder', () => {
    it('Should validate the password for a folder', async () => {
      api.folders.validatePassword.mockImplementation(() => Promise.resolve({ data: { folder } }));

      const results = [validateFolderPasswordSuccess({ folder })];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        validateFolderPassword,
        initialAction
      );
      expect(api.folders.validatePassword).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.folders.validatePassword.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete folder',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [validateFolderPasswordError(response), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        validateFolderPassword,
        initialAction
      );
      expect(api.folders.validatePassword).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });
});

/*  Resources test   */
describe('Tests for resources', () => {
  describe('Get resources Saga', () => {
    it('Should return resources', async () => {
      api.resources.all.mockImplementation(() => Promise.resolve({ data: { page: { ...resource } } }));
      const results = [getResourcesSuccess(resource)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getResources,
        initialAction
      );
      expect(api.resources.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.resources.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load resources',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getResourcesError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getResources,
        initialAction
      );

      expect(api.resources.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get resource Saga', () => {
    it('Should return a resource', async () => {
      api.resources.get.mockImplementation(() => Promise.resolve({ data: { ...resource } }));
      const results = [getResourceSuccess(resource)];
      const initialAction = { payload: { id: resource.id } };

      const dispatched = await recordSaga(
        getResource,
        initialAction
      );
      expect(api.resources.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.resources.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get resource',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getResourceError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getResource,
        initialAction
      );

      expect(api.resources.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });


  describe('Create resource', () => {
    it('Should create a resource', async () => {
      api.resources.create.mockImplementation(() => Promise.resolve({ data: { resource } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'resource created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createResourceSuccess(), push(null), notified];
      const initialAction = { payload: {
        id: '',
      } };

      const dispatched = await recordSaga(
        createResource,
        initialAction
      );
      expect(api.resources.create).toHaveBeenCalledWith({ resource: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.resources.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create resource',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createResourceError(response), notified];
      const initialAction = { payload: { id: '', group_id: 2 } };
      const dispatched = await recordSaga(
        createResource,
        initialAction
      );
      expect(api.resources.create).toHaveBeenCalledWith({ resource: initialAction.payload, group_id: 2 });
      expect(dispatched).toEqual(results);
    });
  });

  describe('update resource', () => {
    it('Should update a resource', async () => {
      api.resources.update.mockImplementation(() => Promise.resolve({ data: { resource } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'resource updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updateResourceSuccess(), push(null), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updateResource,
        initialAction
      );
      expect(api.resources.update).toHaveBeenCalledWith(initialAction.payload.id, { resource: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.resources.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update resource',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateResourceError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        updateResource,
        initialAction
      );

      expect(api.resources.update).toHaveBeenCalledWith(initialAction.payload.id, { resource: initialAction.payload });
      expect(dispatched).toEqual(results);
    });
  });

  describe('Delete resource', () => {
    it('Should delete a resource', async () => {
      api.resources.destroy.mockImplementation(() => Promise.resolve({ data: { resource } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'resource deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteResourceSuccess(), push(null), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deleteResource,
        initialAction
      );
      expect(api.resources.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.resources.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete resource',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteResourceError(response), notified];
      const initialAction = { payload: { resource: undefined } };
      const dispatched = await recordSaga(
        deleteResource,
        initialAction
      );
      expect(api.resources.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Archive resource', () => {
    it('Should archive an resource', async () => {
      api.resources.archive.mockImplementation(() => Promise.resolve({ data: { resource } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [archiveResourceSuccess(), notified];

      const initialAction = { payload: resource };

      const dispatched = await recordSaga(
        archiveResource,
        initialAction
      );

      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.resources.archive.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [archiveResourceError(response), notified];
      const initialAction = { payload: resource };
      const dispatched = await recordSaga(
        archiveResource,
        initialAction
      );
      expect(api.resources.archive).toHaveBeenCalledWith(resource.id, { resource });
      expect(dispatched).toEqual(results);
    });
  });

  describe('getResource file data', () => {
    // TODO complete this test
    xit('Should get the file  data for the resource', async () => {
      api.resources.getFileData.mockImplementation(() => Promise.resolve({ data: { folder } }));

      const results = [getFileDataSuccess({ folder })];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getResourceFileData,
        initialAction
      );
      expect(api.resources.getFileData).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.resources.getFileData.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete folder',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getFileDataError(response), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        getResourceFileData,
        initialAction
      );
      expect(api.resources.getFileData).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });
});
