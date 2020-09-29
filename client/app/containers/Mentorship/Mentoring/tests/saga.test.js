import {
  getMentors,
  getAvailableMentors,
  deleteMentorship,
  requestMentorship,
} from '../saga';

import {
  getMentorsSuccess, getMentorsError,
  getAvailableMentorsSuccess, getAvailableMentorsError,
  deleteMentorshipSuccess, deleteMentorshipError,
  requestsMentorshipSuccess, requestsMentorshipError,
} from 'containers/Mentorship/Mentoring/actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import messages from '../messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

api.mentorings.all = jest.fn();
api.users.all = jest.fn();
api.mentorings.removeMentorship = jest.fn();
api.mentoringRequests.create = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

const mentoring = {
  id: 5,
};

describe('Mentoring Saga', () => {
  describe('getMentors', () => {
    it('Should return budget', async () => {
      api.mentorings.all.mockImplementation(() => Promise.resolve({ data: { page: { ...mentoring } } }));
      const results = [getMentorsSuccess(mentoring)];

      const initialAction = { payload: {
        id: 7,
        type: 'mentors',
        userId: 1
      } };

      const dispatched = await recordSaga(
        getMentors,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentorings.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getMentorsError(response), notified];
      const initialAction = { payload: { ...mentoring } };
      const dispatched = await recordSaga(
        getMentors,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.mentors, options: { variant: 'warning' } });
    });
  });

  describe('getAvailableMentors', () => {
    it('Should return availableMentors', async () => {
      api.users.all.mockImplementation(() => Promise.resolve({ data: { page: { ...mentoring } } }));
      const results = [getAvailableMentorsSuccess(mentoring)];

      const initialAction = { payload: {
        id: 7,
        type: 'mentors',
        userId: 1
      } };

      const dispatched = await recordSaga(
        getAvailableMentors,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.users.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getAvailableMentorsError(response), notified];
      const initialAction = { payload: { ...mentoring } };
      const dispatched = await recordSaga(
        getAvailableMentors,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.available_mentors, options: { variant: 'warning' } });
    });
  });

  describe('deleteMentorship', () => {
    it('Should return deleteMentorship', async () => {
      api.mentorings.removeMentorship.mockImplementation(() => Promise.resolve({ data: { page: { ...mentoring } } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deleteMentorshipSuccess(), push(ROUTES.user.mentorship.mentors.path(1)), notified];

      const initialAction = { payload: {
        id: 7,
        type: 'mentors',
        userId: 1
      } };

      const dispatched = await recordSaga(
        deleteMentorship,
        initialAction
      );
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.delete, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentorings.removeMentorship.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteMentorshipError(response), notified];
      const initialAction = { payload: { ...mentoring } };
      const dispatched = await recordSaga(
        deleteMentorship,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } });
    });
  });
});
