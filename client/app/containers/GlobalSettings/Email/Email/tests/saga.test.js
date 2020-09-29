/**
 * Test sagas
 */

import {
  getEmailError, getEmailSuccess,
  getEmailsError, getEmailsSuccess,
  updateEmailError, updateEmailSuccess,
} from '../actions';

import { getEmail, getEmails, updateEmail } from '../saga';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from '../messages';

api.emails.get = jest.fn();
api.emails.all = jest.fn();
api.emails.update = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

const email = {
  id: 1,
  name: 'abc123'
};

describe('Email saga', () => {
  describe('getEmail', () => {
    it('Should return email', async () => {
      api.emails.get.mockImplementation(() => Promise.resolve({ data: undefined }));

      const results = [getEmailSuccess()];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getEmail,
        initialAction
      );
      expect(api.emails.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.emails.get.mockImplementation(() => Promise.reject(response));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getEmailError(response), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getEmail,
        initialAction
      );

      expect(api.emails.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.email, options: { variant: 'warning' } });
    });
  });

  describe('getEmails', () => {
    it('Should return emaisl', async () => {
      api.emails.all.mockImplementation(() => Promise.resolve({ data: { page: { ...email } } }));

      const results = [getEmailsSuccess(email)];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getEmails,
        initialAction
      );
      expect(api.emails.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.emails.all.mockImplementation(() => Promise.reject(response));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getEmailsError(response), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getEmails,
        initialAction
      );

      expect(api.emails.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.emails, options: { variant: 'warning' } });
    });
  });

  describe('updateEmail', () => {
    it('Should update email', async () => {
      api.emails.update.mockImplementation(() => Promise.resolve({ data: { page: { ...email } } }));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateEmailSuccess(), notified];

      const initialAction = { payload: { ...email } };

      const dispatched = await recordSaga(
        updateEmail,
        initialAction
      );
      expect(api.emails.update).toHaveBeenCalledWith(initialAction.payload.id, { email: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(api.emails.update).toHaveBeenCalledWith(initialAction.payload.id, { email: initialAction.payload });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.emails.update.mockImplementation(() => Promise.reject(response));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateEmailError(response), notified];

      const initialAction = { payload: {
        id: 1
      } };

      const dispatched = await recordSaga(
        updateEmail,
        initialAction
      );

      expect(api.emails.update).toHaveBeenCalledWith(initialAction.payload.id, { email: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.update, options: { variant: 'warning' } });
    });
  });
});
