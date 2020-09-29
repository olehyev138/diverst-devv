import {
  getSession,
  createSession,
  deleteSession,
  acceptInvitation,
  declineInvitation,
  updateSession,
  getHostingSessions,
  getParticipatingSessions,
  getParticipatingUsers,
} from '../saga';

import {
  getSessionSuccess, getSessionError,
  createSessionSuccess, createSessionError,
  updateSessionSuccess, updateSessionError,
  deleteSessionSuccess, deleteSessionError,
  acceptInvitationSuccess, acceptInvitationError,
  declineInvitationError, declineInvitationSuccess,
  getHostingSessionsSuccess, getHostingSessionsError,
  getParticipatingSessionsSuccess, getParticipatingSessionsError,
  getParticipatingUsersSuccess, getParticipatingUsersError
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import messages from '../messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

api.mentoringSessions.get = jest.fn();
api.mentoringSessions.create = jest.fn();
api.mentoringSessions.all = jest.fn();
api.mentoringSessions.destroy = jest.fn();
api.mentorshipSessions.acceptInvite = jest.fn();
api.mentorshipSessions.declineInvite = jest.fn();
api.mentoringSessions.update = jest.fn();
api.mentorshipSessions.all = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

const session = {
  id: 5,
};

describe('Session Saga', () => {
  describe('getSession', () => {
    it('Should return session', async () => {
      api.mentoringSessions.get.mockImplementation(() => Promise.resolve({ data: { ...session } }));
      const results = [getSessionSuccess(session)];

      const initialAction = { payload: {
        ...session
      } };

      const dispatched = await recordSaga(
        getSession,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentoringSessions.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getSessionError(response), notified];
      const initialAction = { payload: { ...session } };
      const dispatched = await recordSaga(
        getSession,
        initialAction
      );

      expect(api.mentoringSessions.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.session, options: { variant: 'warning' } });
    });
  });

  describe('createSession', () => {
    it('Should create session', async () => {
      api.mentoringSessions.create.mockImplementation(() => Promise.resolve({ data: { page: { ...session } } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createSessionSuccess(), push(ROUTES.user.mentorship.sessions.hosting.path()), notified];

      const initialAction = { payload: {
        ...session
      } };

      const dispatched = await recordSaga(
        createSession,
        initialAction
      );
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.create, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentoringSessions.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createSessionError(response), notified];
      const initialAction = { payload: { groupId: 5, id: 2 } };
      const dispatched = await recordSaga(
        createSession,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.create, options: { variant: 'warning' } });
    });
  });

  describe('acceptInvitationSession', () => {
    it('Should acceptInvitation session', async () => {
      api.mentorshipSessions.acceptInvite.mockImplementation(() => Promise.resolve({ data: { ...session } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [acceptInvitationSuccess(), notified];

      const initialAction = { payload: {
        ...session
      } };

      const dispatched = await recordSaga(
        acceptInvitation,
        initialAction
      );
      expect(api.mentorshipSessions.acceptInvite).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.accept, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentorshipSessions.acceptInvite.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [acceptInvitationError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        acceptInvitation,
        initialAction
      );

      expect(api.mentorshipSessions.acceptInvite).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.accept, options: { variant: 'warning' } });
    });
  });

  describe('declineInvitationSession', () => {
    it('Should declineInvitation session', async () => {
      api.mentorshipSessions.declineInvite.mockImplementation(() => Promise.resolve({ data: { ...session } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [declineInvitationSuccess(), notified];

      const initialAction = { payload: {
        ...session
      } };

      const dispatched = await recordSaga(
        declineInvitation,
        initialAction
      );
      expect(api.mentorshipSessions.declineInvite).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.decline, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentorshipSessions.declineInvite.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [declineInvitationError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        declineInvitation,
        initialAction
      );

      expect(api.mentorshipSessions.declineInvite).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.decline, options: { variant: 'warning' } });
    });
  });

  describe('deleteSession', () => {
    it('Should deleteSession', async () => {
      api.mentoringSessions.destroy.mockImplementation(() => Promise.resolve({ data: { ...session } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteSessionSuccess(), notified];
      const initialAction = { payload: {
        ...session
      } };

      const dispatched = await recordSaga(
        deleteSession,
        initialAction
      );
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.delete, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentoringSessions.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteSessionError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        deleteSession,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } });
    });
  });

  describe('updateSession', () => {
    it('Should updateSession', async () => {
      api.mentoringSessions.update.mockImplementation(() => Promise.resolve({ data: { ...session } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateSessionSuccess(), push(ROUTES.user.mentorship.sessions.hosting.path()), notified];
      const initialAction = { payload: {
        ...session
      } };

      const dispatched = await recordSaga(
        updateSession,
        initialAction
      );
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.update, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentoringSessions.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateSessionError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        updateSession,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.update, options: { variant: 'warning' } });
    });
  });

  describe('getHostingSessions', () => {
    it('Should return session', async () => {
      api.mentoringSessions.all.mockImplementation(() => Promise.resolve({ data: { ...session } }));
      const results = [getHostingSessionsSuccess()];

      const initialAction = { payload: {
        ...session,
        userId: 6
      } };

      const dispatched = await recordSaga(
        getHostingSessions,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentoringSessions.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getHostingSessionsError(response), notified];
      const initialAction = { payload: { ...session } };
      const dispatched = await recordSaga(
        getHostingSessions,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.hosting, options: { variant: 'warning' } });
    });
  });

  describe('getParticipatingSessions', () => {
    it('Should return session', async () => {
      api.mentorshipSessions.all.mockImplementation(() => Promise.resolve({ data: { ...session } }));
      const results = [getParticipatingSessionsSuccess()];

      const initialAction = { payload: {
        ...session,
        userId: 6
      } };

      const dispatched = await recordSaga(
        getParticipatingSessions,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentorshipSessions.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getParticipatingSessionsError(response), notified];
      const initialAction = { payload: { ...session } };
      const dispatched = await recordSaga(
        getParticipatingSessions,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.participating, options: { variant: 'warning' } });
    });
  });

  describe('getParticipatingUsers', () => {
    it('Should return users', async () => {
      api.mentorshipSessions.all.mockImplementation(() => Promise.resolve({ data: { ...session } }));
      const results = [getParticipatingUsersSuccess()];

      const initialAction = { payload: {
        ...session,
        sessionId: 6
      } };

      const dispatched = await recordSaga(
        getParticipatingUsers,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentorshipSessions.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getParticipatingUsersError(response), notified];
      const initialAction = { payload: { ...session } };
      const dispatched = await recordSaga(
        getParticipatingUsers,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.participating_users, options: { variant: 'warning' } });
    });
  });
});
