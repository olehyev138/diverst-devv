/**
 * Test sagas
 */

import {
  requestPasswordReset, getUserByToken, submitPassword
} from 'containers/User/PasswordResetPage/saga';

import {
  getUserByTokenError,
  getUserByTokenSuccess,
  requestPasswordResetError,
  requestPasswordResetSuccess, submitPasswordError, submitPasswordSuccess
} from 'containers/User/PasswordResetPage/actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';


api.users.requestPasswordReset = jest.fn();
api.users.getPasswordToken = jest.fn();
api.users.passwordReset = jest.fn();


beforeEach(() => {
  jest.resetAllMocks();
});

const token = 'Hello World';

const user = {
  id: 51,
  name: 'Tech Admin'
};

const formToken = 'Hello World 2';

describe('Request Password Reset', () => {
  it('Should return nothing', async () => {
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'User already asked for password reset',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };


    api.users.requestPasswordReset.mockImplementation(() => Promise.resolve());
    const results = [requestPasswordResetSuccess({}), notified];

    const initialAction = { payload: {} };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const dispatched = await recordSaga(
      requestPasswordReset,
      initialAction
    );
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.users.requestPasswordReset.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'User already asked for password reset',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [requestPasswordResetError(response), notified];
    const initialAction = { payload: {} };
    const dispatched = await recordSaga(
      requestPasswordReset,
      initialAction
    );

    expect(api.users.requestPasswordReset).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});

describe('Get User By Token', () => {
  it('Should return user and new token', async () => {
    api.users.getPasswordToken.mockImplementation(() => Promise.resolve({ data: { user, token: formToken } }));
    const results = [getUserByTokenSuccess({ user, token: formToken })];

    const initialAction = { payload: { token } };

    const dispatched = await recordSaga(
      getUserByToken,
      initialAction
    );
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.users.getPasswordToken.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Invalid Token',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getUserByTokenError(response), notified, push(ROUTES.session.login.path())];
    const initialAction = { payload: { payload: { token } } };
    const dispatched = await recordSaga(
      getUserByToken,
      initialAction
    );

    expect(api.users.getPasswordToken).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});

describe('Submit Password', () => {
  it('Should return nothing', async () => {
    api.users.passwordReset.mockImplementation(() => Promise.resolve());
    const notified = {
      notification: {
        key: 1595962255857,
        message: 'Successfully changed password',
        options: { variant: 'success' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const results = [submitPasswordSuccess({}), notified, push(ROUTES.session.login.path())];
    const initialAction = { payload: { token: formToken, password: 'pp', password_confirmation: 'pp' } };

    const dispatched = await recordSaga(
      submitPassword,
      initialAction
    );
    expect(dispatched).toEqual(results);
  });

  [400, 401].forEach((errorCode) => {
    it(`Should return error from the API with error code ${errorCode}`, async () => {
      const response = { response: { data: 'ERROR!', status: errorCode } };
      api.users.passwordReset.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'User already asked for password reset',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [submitPasswordError(response), notified, ...(errorCode === 400 ? [push(ROUTES.session.login.path())] : [])];
      const initialAction = { payload: { token: formToken, password: 'pp', password_confirmation: 'pp' } };
      const dispatched = await recordSaga(
        submitPassword,
        initialAction
      );

      expect(api.users.passwordReset).toHaveBeenCalledWith({
        token: initialAction.payload.token,
        user: { password: 'pp', password_confirmation: 'pp' }
      });
      expect(dispatched).toEqual(results);
    });
  });
});
