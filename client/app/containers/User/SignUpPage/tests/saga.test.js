/**
 * Test sagas
 */

import {
  getUserByToken,
  submitPassword
} from 'containers/User/SignUpPage/saga';

import {
  getUserByTokenBegin,
  getUserByTokenSuccess,
  getUserByTokenError,
  submitPasswordBegin,
  submitPasswordSuccess,
  submitPasswordError,
  signUpUnmount
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

describe('Tests for signup saga', () => {
  xdescribe('Get signup Saga', () => {
    it('Should return a user', async () => {
      api.users.getInvitedUser.mockImplementation(() => Promise.resolve({ data: { page: { ...user } } }));
      const results = [getUserByTokenSuccess(user)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getUserByToken,
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
      const results = [getUserByTokenError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getUserByToken,
        initialAction
      );

      expect(api.users.getInvitedUser).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  // TODO
  describe('Get signup Saga', () => {
    xit('Should submit the password', async () => {
      api.users.signUpUser.mockImplementation(() => Promise.resolve({ data: { ...user } }));
      const results = [submitPasswordSuccess(user)];
      const initialAction = { payload: { id: user.id } };

      const dispatched = await recordSaga(
        submitPassword,
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
      const results = [submitPasswordError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        submitPassword,
        initialAction
      );

      expect(api.users.signUpUser).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });
});
