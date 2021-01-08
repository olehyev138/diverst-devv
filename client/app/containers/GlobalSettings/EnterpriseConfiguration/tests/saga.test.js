/**
 * Test sagas
 */

import {
  getEnterpriseBegin, getEnterpriseError,
  getEnterpriseSuccess, updateEnterpriseBegin,
  updateEnterpriseSuccess, updateEnterpriseError, updateBrandingSuccess, updateBrandingError
} from '../actions';

import { getEnterprise, updateBranding, updateEnterprise } from '../saga';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from '../messages';

import { setUserData } from 'containers/Shared/App/actions';

api.enterprises.getEnterprise = jest.fn();
api.enterprises.updateEnterprise = jest.fn();
api.enterprises.updateBranding = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

const enterprise = {
  id: 1,
  name: 'abc123'
};

describe('EnterpriseConfiguration saga', () => {
  describe('getEnterprise', () => {
    it('Should return enterprise', async () => {
      api.enterprises.getEnterprise.mockImplementation(() => Promise.resolve({ data: { enterprise: {} } }));

      const results = [getEnterpriseSuccess({ enterprise: {} }), setUserData({ enterprise: {} }, true)];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getEnterprise,
        initialAction
      );
      expect(api.enterprises.getEnterprise).toHaveBeenCalledWith();
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.enterprises.getEnterprise.mockImplementation(() => Promise.reject(response));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getEnterpriseError(response), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getEnterprise,
        initialAction
      );

      expect(api.enterprises.getEnterprise).toHaveBeenCalledWith();
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.load, options: { variant: 'warning' } });
    });
  });

  describe('updateEvent', () => {
    it('Should update event', async () => {
      api.enterprises.updateEnterprise.mockImplementation(() => Promise.resolve({ data: { page: { ...enterprise } } }));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateEnterpriseSuccess(), setUserData({ enterprise: undefined }, true), notified];

      const initialAction = { payload: { ...enterprise } };

      const dispatched = await recordSaga(
        updateEnterprise,
        initialAction
      );
      expect(api.enterprises.updateEnterprise).toHaveBeenCalledWith({ enterprise: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.update, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.enterprises.updateEnterprise.mockImplementation(() => Promise.reject(response));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateEnterpriseError(response), notified];

      const initialAction = { payload: {
        id: 1
      } };

      const dispatched = await recordSaga(
        updateEnterprise,
        initialAction
      );

      expect(api.enterprises.updateEnterprise).toHaveBeenCalledWith({ enterprise: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.update, options: { variant: 'warning' } });
    });
  });

  describe('updateBranding', () => {
    it('Should update branding', async () => {
      api.enterprises.updateBranding.mockImplementation(() => Promise.resolve({ data: { enterprise } }));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateBrandingSuccess(), setUserData({ enterprise }, true), notified];

      const initialAction = { payload: { ...enterprise } };

      const dispatched = await recordSaga(
        updateBranding,
        initialAction
      );
      expect(api.enterprises.updateBranding).toHaveBeenCalledWith({ enterprise: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.update, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.enterprises.updateBranding.mockImplementation(() => Promise.reject(response));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateBrandingError(response), notified];

      const initialAction = { payload: {
        id: 1
      } };

      const dispatched = await recordSaga(
        updateBranding,
        initialAction
      );

      expect(api.enterprises.updateBranding).toHaveBeenCalledWith({ enterprise: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.update, options: { variant: 'warning' } });
    });
  });
});