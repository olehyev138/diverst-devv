import {
  getBudget,
  getBudgets,
  createBudgetRequest,
  deleteBudget,
  approveBudget,
  declineBudget
} from '../saga';

import {
  getBudgetSuccess, getBudgetError,
  getBudgetsSuccess, getBudgetsError,
  createBudgetRequestSuccess, createBudgetRequestError,
  approveBudgetSuccess, approveBudgetError,
  declineBudgetSuccess, declineBudgetError,
  deleteBudgetSuccess, deleteBudgetError,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import messages from '../messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

api.budgets.get = jest.fn();
api.budgets.create = jest.fn();
api.budgets.all = jest.fn();
api.budgets.approve = jest.fn();
api.budgets.reject = jest.fn();
api.budgets.destroy = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

const budget = {
  id: 5,
};

describe('Budget Saga', () => {
  describe('getBudget', () => {
    it('Should return budget', async () => {
      api.budgets.get.mockImplementation(() => Promise.resolve({ data: { ...budget } }));
      const results = [getBudgetSuccess(budget)];

      const initialAction = { payload: {
        ...budget
      } };

      const dispatched = await recordSaga(
        getBudget,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.budgets.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getBudgetError(response), notified];
      const initialAction = { payload: { ...budget } };
      const dispatched = await recordSaga(
        getBudget,
        initialAction
      );

      expect(api.budgets.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.budget, options: { variant: 'warning' } });
    });
  });

  describe('getBudgets', () => {
    it('Should return budget', async () => {
      api.budgets.all.mockImplementation(() => Promise.resolve({ data: { page: { ...budget } } }));
      const results = [getBudgetsSuccess(budget)];

      const initialAction = { payload: {
        ...budget
      } };

      const dispatched = await recordSaga(
        getBudgets,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.budgets.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getBudgetsError(response), notified];
      const initialAction = { payload: { ...budget } };
      const dispatched = await recordSaga(
        getBudgets,
        initialAction
      );

      expect(api.budgets.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.budgets, options: { variant: 'warning' } });
    });
  });

  describe('createBudgetRequest', () => {
    it('Should create budget', async () => {
      api.budgets.create.mockImplementation(() => Promise.resolve({ data: { page: { ...budget } } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createBudgetRequestSuccess(), push(undefined), notified];

      const initialAction = { payload: {
        ...budget
      } };

      const dispatched = await recordSaga(
        createBudgetRequest,
        initialAction
      );
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.budget_request, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.budgets.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createBudgetRequestError(response), notified];
      const initialAction = { payload: { groupId: 5, id: 2 } };
      const dispatched = await recordSaga(
        createBudgetRequest,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.budget_request, options: { variant: 'warning' } });
    });
  });

  describe('approveBudget', () => {
    it('Should approve budget', async () => {
      api.budgets.approve.mockImplementation(() => Promise.resolve({ data: { ...budget } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [approveBudgetSuccess(budget), notified];

      const initialAction = { payload: {
        ...budget
      } };

      const dispatched = await recordSaga(
        approveBudget,
        initialAction
      );
      expect(api.budgets.approve).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.approve, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.budgets.approve.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [approveBudgetError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        approveBudget,
        initialAction
      );

      expect(api.budgets.approve).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.approve, options: { variant: 'warning' } });
    });
  });

  describe('declineBudget', () => {
    it('Should decline budget', async () => {
      api.budgets.reject.mockImplementation(() => Promise.resolve({ data: { ...budget } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [declineBudgetSuccess(budget), notified];
      const initialAction = { payload: {
        ...budget
      } };

      const dispatched = await recordSaga(
        declineBudget,
        initialAction
      );
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.decline, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.budgets.reject.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [declineBudgetError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        declineBudget,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.decline, options: { variant: 'warning' } });
    });
  });

  describe('deleteBudget', () => {
    it('Should deleteBudget', async () => {
      api.budgets.destroy.mockImplementation(() => Promise.resolve({ data: { ...budget } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteBudgetSuccess(), notified];
      const initialAction = { payload: {
        ...budget
      } };

      const dispatched = await recordSaga(
        deleteBudget,
        initialAction
      );
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.delete, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.budgets.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteBudgetError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        deleteBudget,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } });
    });
  });
});
