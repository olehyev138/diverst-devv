import {
  getCurrentAnnualBudget, getAnnualBudget,
  getAnnualBudgets,
  updateAnnualBudget
} from '../saga';

import {
  getAnnualBudgetSuccess, getAnnualBudgetError,
  getAnnualBudgetsError, getAnnualBudgetsSuccess,
  updateAnnualBudgetSuccess, updateAnnualBudgetError,
  getCurrentAnnualBudgetError, getCurrentAnnualBudgetSuccess
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import messages from '../messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

api.annualBudgets.get = jest.fn();
api.groups.currentAnnualBudget = jest.fn();
api.annualBudgets.all = jest.fn();
api.annualBudgets.update = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

const annualBudget = {
  id: 5,
  amount: 2,
};

describe('AnnualBudget Saga', () => {
  describe('getCurrentAnnualBudget', () => {
    it('Should return currentAnnualBudget', async () => {
      api.groups.currentAnnualBudget.mockImplementation(() => Promise.resolve({ data: { ...annualBudget } }));
      const results = [getCurrentAnnualBudgetSuccess(annualBudget)];

      const initialAction = { payload: {
        ...annualBudget
      } };

      const dispatched = await recordSaga(
        getCurrentAnnualBudget,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.groups.currentAnnualBudget.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getCurrentAnnualBudgetError(response), notified];
      const initialAction = { payload: { groupId: {} } };
      const dispatched = await recordSaga(
        getCurrentAnnualBudget,
        initialAction
      );

      expect(api.groups.currentAnnualBudget).toHaveBeenCalledWith(initialAction.payload.groupId, {});
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.currentAnnualBudget, options: { variant: 'warning' } });
    });
  });

  describe('getAnnualBudget', () => {
    it('Should return annualBudget', async () => {
      api.annualBudgets.get.mockImplementation(() => Promise.resolve({ data: { ...annualBudget } }));
      const results = [getAnnualBudgetSuccess(annualBudget)];

      const initialAction = { payload: {
        ...annualBudget
      } };

      const dispatched = await recordSaga(
        getAnnualBudget,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.annualBudgets.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getAnnualBudgetError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        getAnnualBudget,
        initialAction
      );

      expect(api.annualBudgets.get).toHaveBeenCalledWith(initialAction.payload.id, {});
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.annualBudget, options: { variant: 'warning' } });
    });
  });

  describe('getAnnualBudgets', () => {
    it('Should return annualBudgets', async () => {
      api.annualBudgets.all.mockImplementation(() => Promise.resolve({ data: { page: { ...annualBudget } } }));
      const results = [getAnnualBudgetsSuccess(annualBudget)];

      const initialAction = { payload: {
        ...annualBudget
      } };

      const dispatched = await recordSaga(
        getAnnualBudgets,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.annualBudgets.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getAnnualBudgetsError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        getAnnualBudgets,
        initialAction
      );

      expect(api.annualBudgets.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.annualBudgets, options: { variant: 'warning' } });
    });
  });

  describe('updateAnnualBudget', () => {
    it('Should return updateAnnualBudget', async () => {
      api.annualBudgets.update.mockImplementation(() => Promise.resolve({ data: { ...annualBudget } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateAnnualBudgetSuccess(), notified];

      const initialAction = { payload: { annual_budget: { id: 2 } } };

      const dispatched = await recordSaga(
        updateAnnualBudget,
        initialAction
      );
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.update, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.annualBudgets.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateAnnualBudgetError(response), notified];
      const initialAction = { payload: { annual_budget: { id: 2 } } };
      const dispatched = await recordSaga(
        updateAnnualBudget,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.update, options: { variant: 'warning' } });
    });
  });
});
