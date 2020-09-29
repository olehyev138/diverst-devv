/**
 * Test sagas
 */

import {
  getEventError, getEventSuccess,
  getEventsError, getEventsSuccess,
  updateEventError, updateEventSuccess,
} from '../actions';

import { getEvent, getEvents, updateEvent } from '../saga';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from '../messages';

api.emailEvents.get = jest.fn();
api.emailEvents.all = jest.fn();
api.emailEvents.update = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

const event = {
  id: 1,
  name: 'abc123'
};

describe('Event saga', () => {
  describe('getEvent', () => {
    it('Should return event', async () => {
      api.emailEvents.get.mockImplementation(() => Promise.resolve({ data: undefined }));

      const results = [getEventSuccess()];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getEvent,
        initialAction
      );
      expect(api.emailEvents.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.emailEvents.get.mockImplementation(() => Promise.reject(response));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getEventError(response), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getEvent,
        initialAction
      );

      expect(api.emailEvents.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.errors.email);
    });
  });

  describe('getEvents', () => {
    it('Should return emaisl', async () => {
      api.emailEvents.all.mockImplementation(() => Promise.resolve({ data: { page: { ...event } } }));

      const results = [getEventsSuccess(event)];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getEvents,
        initialAction
      );
      expect(api.emailEvents.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.emailEvents.all.mockImplementation(() => Promise.reject(response));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getEventsError(response), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        getEvents,
        initialAction
      );

      expect(api.emailEvents.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.errors.emails);
    });
  });

  describe('updateEvent', () => {
    it('Should update event', async () => {
      api.emailEvents.update.mockImplementation(() => Promise.resolve({ data: { page: { ...event } } }));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateEventSuccess(), push(ROUTES.admin.system.globalSettings.emails.events.index.path()), notified];

      const initialAction = { payload: { ...event } };

      const dispatched = await recordSaga(
        updateEvent,
        initialAction
      );
      expect(api.emailEvents.update).toHaveBeenCalledWith(initialAction.payload.id, { clockwork_database_event: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.success.update);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.emailEvents.update.mockImplementation(() => Promise.reject(response));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateEventError(response), notified];

      const initialAction = { payload: {
        id: 1
      } };

      const dispatched = await recordSaga(
        updateEvent,
        initialAction
      );

      expect(api.emailEvents.update).toHaveBeenCalledWith(initialAction.payload.id, { clockwork_database_event: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(intl.formatMessage).toHaveBeenCalledWith(messages.snackbars.errors.update);
    });
  });
});
