import {
  login,
  ssoLogin,
  ssoLinkFind,
  logout,
  findEnterprise
}
from 'containers/Shared/App/saga';
import {
  loginSuccess,
  setUser,
  setUserPolicyGroup,
  loginError,
  logoutSuccess,
  logoutError,
  findEnterpriseSuccess,
  setEnterprise,
  findEnterpriseError
}
from 'containers/Shared/App/actions';
import { changePrimary, changeSecondary } from 'containers/Shared/ThemeProvider/actions';
import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.sessions.create = jest.fn();
api.sessions.destroy = jest.fn();
api.users.findEnterprise = jest.fn();
api.enterprises.getSsoLink = jest.fn();
api.policyGroups.get = jest.fn();
window.location.assign = jest.fn();

const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjEiLCJlbnRlcnByaXNlIjp7ImlkIjoxLCJuYW1lIjoiUGVwc2kgQ28iLCJ0aGVtZSI6bnVsbH0sImVtYWlsIjoiZGV2QGRpdmVyc3QuY29tIiwidXNlcl90b2tlbiI6IldERnMzWThXVnJhcEZ5LTFlY1hhIiwicm9sZSI6IlN1cGVyIEFkbWluIiwiY3JlYXRlZF9hdCI6IlN1biwgMDQgQXVnIDIwMTkgMTM6NTY6MDUgRURUIC0wNDowMCIsInRpbWUiOjEyMzQ1Njc4OTAsImp0aSI6IjJmMzY4Njc4LWY2ZjgtNDg1MC1hZWZiLWY1YjRhNDUzMjI4ZSIsImlhdCI6MTU2NjUxMDUxNSwiZXhwIjoxNTY2NTE0MTE1fQ.dhP8KyizA9cC46oB_F81lr3F742g7elyT386DkPSnys';
const user = {
  created_at: 'Sun, 04 Aug 2019 13:56:05 EDT -04:00',
  email: 'dev@diverst.com',
  enterprise: { id: 1, name: 'Pepsi Co', theme: null },
  exp: 1566514115,
  iat: 1566510515,
  id: '1',
  jti: '2f368678-f6f8-4850-aefb-f5b4a453228e',
  role: 'Super Admin',
  time: 1234567890,
  user_token: 'WDFs3Y8WVrapFy-1ecXa'
};
const policyGroup = {};

beforeEach(() => {
  jest.resetAllMocks();
});

describe('Login Saga', () => {
  it('should get token from API', async() => {
    api.sessions.create.mockImplementation(() => Promise.resolve({ data: { token, policy_group: policyGroup } }));
    const results = [loginSuccess(token), setUser(user), setUserPolicyGroup({ policy_group: policyGroup }), push(ROUTES.user.home.path())];
    const initialAction = { payload: { email: 'test@gmail.com', password: 'password' } };
    const dispatched = await recordSaga(
      login,
      initialAction
    );

    expect(api.sessions.create).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });

  it('should return error from API', async() => {
    const response = { data: { message: 'ERROR!' } };
    api.sessions.create.mockImplementation(() => Promise.reject(response));
    const results = [loginError(response)];
    const initialAction = { payload: { email: 'test@gmail.com', password: 'password' } };
    const dispatched = await recordSaga(
      login,
      initialAction
    );

    expect(api.sessions.create).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});

describe('ssoLogin Saga', () => {
  it('should get token from API', async() => {
    api.policyGroups.get.mockImplementation(() => Promise.resolve({ data: { policy_group: policyGroup } }));
    const results = [loginSuccess(token), setUser(user), setUserPolicyGroup({ policy_group: policyGroup }), push(ROUTES.user.home.path())];
    const initialAction = { payload: { userToken: token, policyGroupId: 1 } };
    const dispatched = await recordSaga(
      ssoLogin,
      initialAction
    );

    expect(api.policyGroups.get).toHaveBeenCalledWith(initialAction.payload.policyGroupId);
    expect(dispatched).toEqual(results);
  });

  it('should return error from API', async() => {
    const response = { response: { data: 'ERROR!' } };
    const notified = {
      notification: {
        key: 1566515890484,
        message: 'ERROR!',
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    api.policyGroups.get.mockImplementation(() => Promise.reject(response));
    const results = [loginError(response), notified];
    const initialAction = { payload: { userToken: token, policyGroupId: 1 } };
    const dispatched = await recordSaga(
      ssoLogin,
      initialAction
    );

    expect(api.policyGroups.get).toHaveBeenCalledWith(initialAction.payload.policyGroupId);
    expect(dispatched).toEqual(results);
  });
});

describe('ssoLinkFind Saga', () => {
  it('should get sso redirect link from API', async() => {
    api.enterprises.getSsoLink.mockImplementation(() => Promise.resolve({ data: 'https://www.diverst.com' }));
    const results = [];
    const initialAction = { payload: { enterpriseId: 1, relayState: 'groups' } };
    const dispatched = await recordSaga(
      ssoLinkFind,
      initialAction
    );

    expect(api.enterprises.getSsoLink).toHaveBeenCalledWith(initialAction.payload.enterpriseId, { relay_state: 'groups' });
    expect(window.location.assign).toHaveBeenCalledWith('https://www.diverst.com');
    expect(dispatched).toEqual(results);
  });

  it('should return error from API', async() => {
    const response = { response: { data: 'ERROR!' } };
    const notified = {
      notification: {
        key: 1566515890484,
        message: 'ERROR!',
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    api.enterprises.getSsoLink.mockImplementation(() => Promise.reject(response));
    const results = [loginError(response), notified];
    const initialAction = { payload: { enterpriseId: 1, relayState: 'groups' } };
    const dispatched = await recordSaga(
      ssoLinkFind,
      initialAction
    );

    expect(api.enterprises.getSsoLink).toHaveBeenCalledWith(initialAction.payload.enterpriseId, { relay_state: 'groups' });
    expect(dispatched).toEqual(results);
  });
});

describe('logout Saga', () => {
  it('logs user out and sends user to home page', async() => {
    api.sessions.destroy.mockImplementation(() => Promise.resolve({ data: {} }));
    const notified = {
      notification: {
        key: 1566515890484,
        message: 'You have been logged out',
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [setUser(null), setUserPolicyGroup({ policy_group: null }), logoutSuccess(), push(ROUTES.session.login.path()), notified];
    const initialAction = { token: 'WDFs3Y8WVrapFy-1ecXa' };
    const dispatched = await recordSaga(
      logout,
      initialAction
    );

    expect(api.sessions.destroy).toHaveBeenCalledWith(initialAction.token);
    expect(window.location.assign).not.toHaveBeenCalled();
    expect(dispatched).toEqual(results);
  });

  it('logs user out and redirects to sso login page', async() => {
    api.sessions.destroy.mockImplementation(() => Promise.resolve({ data: { logout_link: 'www.diverst.com' } }));
    const notified = {
      notification: {
        key: 1566515890484,
        message: 'You have been logged out',
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [setUser(null), setUserPolicyGroup({ policy_group: null }), logoutSuccess()];
    const initialAction = { token: 'WDFs3Y8WVrapFy-1ecXa' };
    const dispatched = await recordSaga(
      logout,
      initialAction
    );

    expect(api.sessions.destroy).toHaveBeenCalledWith(initialAction.token);
    expect(window.location.assign).toHaveBeenCalledWith('www.diverst.com');
    expect(dispatched).toEqual(results);
  });

  it('should return error from API', async() => {
    const response = { response: { data: 'ERROR!' } };
    api.sessions.destroy.mockImplementation(() => Promise.reject(response));
    const results = [setUser(null), setUserPolicyGroup({ policy_group: null }), logoutError(response), push(ROUTES.session.login.path())];
    const initialAction = { token: 'WDFs3Y8WVrapFy-1ecXa' };
    const dispatched = await recordSaga(
      logout,
      initialAction
    );

    expect(api.sessions.destroy).toHaveBeenCalledWith(initialAction.token);
    expect(dispatched).toEqual(results);
  });
});

describe('findEnterprise Saga', () => {
  it('should get sso redirect link from API', async() => {
    const response = { data: { enterprise: { id: 1, theme: { primary_color: '', secondary_color: '' } } } };
    api.users.findEnterprise.mockImplementation(() => Promise.resolve(response));
    const results = [findEnterpriseSuccess(), setEnterprise(response.data.enterprise), changePrimary(response.data.enterprise.theme.primary_color), changeSecondary(response.data.enterprise.theme.secondary_color)];
    const initialAction = { payload: { email: 'dev@diverst.com' } };
    const dispatched = await recordSaga(
      findEnterprise,
      initialAction
    );

    expect(api.users.findEnterprise).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });

  it('should return error from API', async() => {
    const response = { response: { data: 'ERROR!' } };
    api.users.findEnterprise.mockImplementation(() => Promise.reject(response));
    const results = [findEnterpriseError(response)];
    const initialAction = { payload: { email: 'dev@diverst.com' } };
    const dispatched = await recordSaga(
      findEnterprise,
      initialAction
    );

    expect(api.users.findEnterprise).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});
