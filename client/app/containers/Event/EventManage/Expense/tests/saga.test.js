/**
 * Test sagas
 */

import {
  getExpenses,
  getExpense,
  createExpense,
  updateExpense,
  deleteExpense
} from 'containers/Event/EventManage/Expense/saga';

import {
  getExpenseError,
  getExpenseSuccess,
  getExpensesError,
  getExpensesSuccess,
  createExpenseError,
  createExpenseSuccess,
  updateExpenseError,
  updateExpenseSuccess,
  deleteExpenseError,
  deleteExpenseSuccess,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.initiativeExpenses.all = jest.fn();
api.initiativeExpenses.create = jest.fn();
api.initiativeExpenses.update = jest.fn();
api.initiativeExpenses.destroy = jest.fn();
api.initiativeExpenses.get = jest.fn();

const expense = {
  id: 1,
  title: 'abc'
};

describe('Tests for expenses saga', () => {
  describe('Get expenses Saga', () => {
    it('Should return expenseList', async () => {
      api.initiativeExpenses.all.mockImplementation(() => Promise.resolve({ data: { page: { ...expense } } }));
      const results = [getExpensesSuccess(expense)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getExpenses,
        initialAction
      );
      expect(api.initiativeExpenses.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.initiativeExpenses.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load expenses',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getExpensesError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getExpenses,
        initialAction
      );

      expect(api.initiativeExpenses.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get expense Saga', () => {
    it('Should return a group', async () => {
      api.initiativeExpenses.get.mockImplementation(() => Promise.resolve({ data: { ...expense } }));
      const results = [getExpenseSuccess(expense)];
      const initialAction = { payload: { id: expense.id } };

      const dispatched = await recordSaga(
        getExpense,
        initialAction
      );
      expect(api.initiativeExpenses.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.initiativeExpenses.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get expense',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getExpenseError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getExpense,
        initialAction
      );

      expect(api.initiativeExpenses.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });


  describe('Create expense', () => {
    it('Should create a expense', async () => {
      api.initiativeExpenses.create.mockImplementation(() => Promise.resolve({ data: { expense } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'expense created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createExpenseSuccess({ expense }), push(undefined), notified];
      const initialAction = { payload: {
        undefined
      } };

      const dispatched = await recordSaga(
        createExpense,
        initialAction
      );
      expect(api.initiativeExpenses.create).toHaveBeenCalledWith({ initiative_expense: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.initiativeExpenses.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create expense',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createExpenseError(response), notified];
      const initialAction = { payload: { expense: {}, path: 'abc' } };
      const dispatched = await recordSaga(
        createExpense,
        initialAction
      );
      expect(api.initiativeExpenses.create).toHaveBeenCalledWith({ initiative_expense: { expense: {} } });
      expect(dispatched).toEqual(results);
    });

    it('Should update a expense', async () => {
      api.initiativeExpenses.update.mockImplementation(() => Promise.resolve({ data: { expense } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'expense updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updateExpenseSuccess(), push(undefined), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updateExpense,
        initialAction
      );
      expect(api.initiativeExpenses.update).toHaveBeenCalledWith(initialAction.payload.id, { initiative_expense: {} });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.initiativeExpenses.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateExpenseError(response), notified];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updateExpense,
        initialAction
      );
      expect(api.initiativeExpenses.update).toHaveBeenCalledWith(initialAction.payload.id, { initiative_expense: {} });
      expect(dispatched).toEqual(results);
    });
  });


  describe('Delete expense', () => {
    it('Should delete a expense', async () => {
      api.initiativeExpenses.destroy.mockImplementation(() => Promise.resolve({ data: { expense } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'expense deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteExpenseSuccess(), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deleteExpense,
        initialAction
      );
      expect(api.initiativeExpenses.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.initiativeExpenses.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete expense',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteExpenseError(response), notified];
      const initialAction = { payload: { expense: undefined } };
      const dispatched = await recordSaga(
        deleteExpense,
        initialAction
      );
      expect(api.initiativeExpenses.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });
});
