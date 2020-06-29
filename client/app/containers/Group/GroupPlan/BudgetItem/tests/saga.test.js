/**
 * Test sagas
 */

import {
  getBudgetItems,
  getBudgetItem,
  closeBudgetItems
} from 'containers/Group/GroupPlan/BudgetItem/saga';

import {
  getBudgetItemError,
  getBudgetItemSuccess,
  getBudgetItemsError,
  getBudgetItemsSuccess,
  closeBudgetItemsError,
  closeBudgetItemsSuccess
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.budgetItems.all = jest.fn();
api.budgetItems.get = jest.fn();
api.budgetItems.closeBudget = jest.fn();


const budgetItem = {
  id: 1,
  title: 'abc',
  group_id: 2,
};

describe('Tests for budgetItems saga', () => {
  describe('Get budgetItems Saga', () => {
    it('Should return budgetItemList', async () => {
      api.budgetItems.all.mockImplementation(() => Promise.resolve({ data: { page: { ...budgetItem } } }));
      const results = [getBudgetItemsSuccess(budgetItem)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getBudgetItems,
        initialAction
      );
      expect(api.budgetItems.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.budgetItems.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load budgetItems',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getBudgetItemsError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getBudgetItems,
        initialAction
      );

      expect(api.budgetItems.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get budgetItem Saga', () => {
    it('Should return a group', async () => {
      api.budgetItems.get.mockImplementation(() => Promise.resolve({ data: { ...budgetItem } }));
      const results = [getBudgetItemSuccess(budgetItem)];
      const initialAction = { payload: { id: budgetItem.id } };

      const dispatched = await recordSaga(
        getBudgetItem,
        initialAction
      );
      expect(api.budgetItems.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.budgetItems.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get budgetItem',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getBudgetItemError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getBudgetItem,
        initialAction
      );

      expect(api.budgetItems.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });
  describe('close budget', () => {
    it('Should close a budgetItem', async () => {
      api.budgetItems.closeBudget.mockImplementation(() => Promise.resolve({ data: { budgetItem } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'budgetItem updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [closeBudgetItemsSuccess(), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        closeBudgetItems,
        initialAction
      );
      expect(api.budgetItems.closeBudget).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.budgetItems.closeBudget.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [closeBudgetItemsError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        closeBudgetItems,
        initialAction
      );

      expect(api.budgetItems.closeBudget).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });
});
