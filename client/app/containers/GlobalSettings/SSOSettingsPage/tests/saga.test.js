/**
 * Test sagas
 */

import {
  updateSsoSettingsBegin,
  updateSsoSettingsSuccess, updateSsoSettingsError
} from '../actions';

import { updateSsoSettings } from '../saga';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from '../../EnterpriseConfiguration/messages';

import { setUserData } from 'containers/Shared/App/actions';

api.enterprises.updateSSO = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

const enterprise = {
  id: 1,
  name: 'abc123'
};

describe('SSO saga', () => {
  describe('updateSSO', () => {
    it('Should update sso settings', async () => {
      api.enterprises.updateSSO.mockImplementation(() => Promise.resolve({ data: { page: { ...enterprise } } }));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateSsoSettingsSuccess({}), notified];

      const initialAction = { payload: { ...enterprise } };

      const dispatched = await recordSaga(
        updateSsoSettings,
        initialAction
      );
      expect(api.enterprises.updateSSO).toHaveBeenCalledWith({ enterprise: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.success.update);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.enterprises.updateSSO.mockImplementation(() => Promise.reject(response));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateSsoSettingsError(response), notified];

      const initialAction = { payload: {
        id: 1
      } };

      const dispatched = await recordSaga(
        updateSsoSettings,
        initialAction
      );

      expect(api.enterprises.updateSSO).toHaveBeenCalledWith({ enterprise: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.errors.update);
    });
  });
});
