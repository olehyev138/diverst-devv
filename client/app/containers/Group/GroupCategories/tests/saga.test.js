/**
 * Test sagas
 */

import {
  getGroupCategories,
  getGroupCategory,
  createGroupCategories,
  updateGroupCategories,
  deleteGroupCategories
} from 'containers/Group/GroupCategories/saga';

import {
  getGroupCategoryError,
  getGroupCategorySuccess,
  getGroupCategoriesError,
  getGroupCategoriesSuccess,
  createGroupCategoriesError,
  createGroupCategoriesSuccess,
  updateGroupCategoriesError,
  updateGroupCategoriesSuccess,
  deleteGroupCategoriesError,
  deleteGroupCategoriesSuccess,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.groupCategoryTypes.all = jest.fn();
api.groupCategoryTypes.create = jest.fn();
api.groupCategoryTypes.update = jest.fn();
api.groupCategoryTypes.destroy = jest.fn();
api.groupCategoryTypes.get = jest.fn();

const groupCategory = {
  id: 1,
  title: 'abc'
};

describe('Tests for groupCategories saga', () => {
  describe('Get groupCategories Saga', () => {
    it('Should return groupCategoryList', async () => {
      api.groupCategoryTypes.all.mockImplementation(() => Promise.resolve({ data: { page: { ...groupCategory } } }));
      const results = [getGroupCategoriesSuccess(groupCategory)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getGroupCategories,
        initialAction
      );
      expect(api.groupCategoryTypes.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupCategoryTypes.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groupCategories',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getGroupCategoriesError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getGroupCategories,
        initialAction
      );

      expect(api.groupCategoryTypes.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get groupCategory Saga', () => {
    it('Should return a group', async () => {
      api.groupCategoryTypes.get.mockImplementation(() => Promise.resolve({ data: { ...groupCategory } }));
      const results = [getGroupCategorySuccess(groupCategory)];
      const initialAction = { payload: { id: groupCategory.id } };

      const dispatched = await recordSaga(
        getGroupCategory,
        initialAction
      );
      expect(api.groupCategoryTypes.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupCategoryTypes.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get groupCategory',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getGroupCategoryError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getGroupCategory,
        initialAction
      );

      expect(api.groupCategoryTypes.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });


  describe('Create groupCategory', () => {
    it('Should create a groupCategory', async () => {
      api.groupCategoryTypes.create.mockImplementation(() => Promise.resolve({ data: { groupCategory } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'groupCategory created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createGroupCategoriesSuccess(), push(ROUTES.admin.manage.groups.categories.index.path()), notified];
      const initialAction = { payload: {
        id: '',
      } };

      const dispatched = await recordSaga(
        createGroupCategories,
        initialAction
      );
      expect(api.groupCategoryTypes.create).toHaveBeenCalledWith({ group_category_type: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupCategoryTypes.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create groupCategory',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createGroupCategoriesError(response), notified];
      const initialAction = { payload: { group_category_type: undefined } };
      const dispatched = await recordSaga(
        createGroupCategories,
        initialAction.payload
      );
      expect(api.groupCategoryTypes.create).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should update a groupCategory', async () => {
      api.groupCategoryTypes.update.mockImplementation(() => Promise.resolve({ data: { groupCategory } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'groupCategory updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updateGroupCategoriesSuccess(), push(ROUTES.admin.manage.groups.categories.index.path()), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updateGroupCategories,
        initialAction
      );
      expect(api.groupCategoryTypes.update).toHaveBeenCalledWith(initialAction.payload.id, { group_category_type: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupCategoryTypes.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateGroupCategoriesError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        updateGroupCategories,
        initialAction
      );

      expect(api.groupCategoryTypes.update).toHaveBeenCalledWith(initialAction.payload.id, { group_category_type: initialAction.payload });
      expect(dispatched).toEqual(results);
    });
  });


  describe('Delete groupCategory', () => {
    it('Should delete a groupCategory', async () => {
      api.groupCategoryTypes.destroy.mockImplementation(() => Promise.resolve({ data: { groupCategory } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'groupCategory deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteGroupCategoriesSuccess(), push(ROUTES.admin.manage.groups.categories.index.path()), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deleteGroupCategories,
        initialAction
      );
      expect(api.groupCategoryTypes.destroy).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groupCategoryTypes.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete groupCategory',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteGroupCategoriesError(response), notified];
      const initialAction = { payload: { groupCategory: undefined } };
      const dispatched = await recordSaga(
        deleteGroupCategories,
        initialAction
      );
      expect(api.groupCategoryTypes.destroy).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });
});
