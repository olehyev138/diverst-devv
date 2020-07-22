/**
 * Test sagas
 */

import {
  getQuestionnaireByToken,
  submitResponse
} from '../saga';

import {
  getQuestionnaireByTokenBegin,
  getQuestionnaireByTokenSuccess,
  getQuestionnaireByTokenError,
  submitResponseBegin,
  submitResponseSuccess,
  submitResponseError,
  pollResponseUnmount
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.users.getInvitedUser = jest.fn();
api.users.signUpUser = jest.fn();

const user = {
  id: 1,
  title: 'abc'
};

describe('Tests for poll response saga', () => {
  xdescribe('Get questionnaire Saga', () => {
    it('Should return a poll response', async () => {
      api.users.getInvitedUser.mockImplementation(() => Promise.resolve({ data: { page: { ...user } } }));
      const results = [getQuestionnaireByTokenSuccess(user)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getQuestionnaireByToken,
        initialAction
      );
      expect(api.users.getInvitedUser).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.users.getInvitedUser.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load polls',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getQuestionnaireByTokenError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getQuestionnaireByToken,
        initialAction
      );

      expect(api.users.getInvitedUser).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  // TODO
  describe('submit response Saga', () => {
    xit('Should submit the response', async () => {
      api.users.signUpUser.mockImplementation(() => Promise.resolve({ data: { ...user } }));
      const results = [submitResponseSuccess(user)];
      const initialAction = { payload: { id: user.id } };

      const dispatched = await recordSaga(
        submitResponse,
        initialAction
      );
      expect(api.users.signUpUser).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    xit('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.users.signUpUser.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get poll',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [submitResponseError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        submitResponse,
        initialAction
      );

      expect(api.users.signUpUser).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });
});
