import {
  LOGIN_BEGIN,
  LOGIN_SUCCESS,
  LOGIN_ERROR,
  LOGOUT_BEGIN,
  LOGOUT_SUCCESS,
  LOGOUT_ERROR,
  FIND_ENTERPRISE_BEGIN,
  FIND_ENTERPRISE_ERROR,
  SSO_LINK_BEGIN,
  SSO_LOGIN_BEGIN,
  FIND_ENTERPRISE_SUCCESS,
  SET_USER_DATA,
  TOGGLE_ADMIN_DRAWER,
}
  from 'containers/Shared/App/constants';

import {
  loginBegin,
  loginSuccess,
  loginError,
  logoutBegin,
  logoutSuccess,
  logoutError,
  findEnterpriseBegin,
  findEnterpriseError,
  ssoLinkBegin,
  ssoLoginBegin,
  findEnterpriseSuccess,
  setUserData,
  toggleAdminDrawer,
}
  from 'containers/Shared/App/actions';

describe('App actions', () => {
  describe('loginBegin', () => {
    it('it has a type of LOGIN_BEGIN and sets a given payload', () => {
      const expected = {
        type: LOGIN_BEGIN,
        payload: { payload: 'payload' }
      };

      expect(loginBegin({ payload: 'payload' })).toEqual(expected);
    });
  });

  describe('ssoLinkBegin', () => {
    it('it has a type of SSO_LINK_BEGIN and sets a given payload', () => {
      const expected = {
        type: SSO_LINK_BEGIN,
        payload: { payload: 'payload' }
      };

      expect(ssoLinkBegin({ payload: 'payload' })).toEqual(expected);
    });
  });

  describe('ssoLoginBegin', () => {
    it('it has a type of SSO_LOGIN_BEGIN and sets a given payload', () => {
      const expected = {
        type: SSO_LOGIN_BEGIN,
        payload: { payload: 'payload' }
      };

      expect(ssoLoginBegin({ payload: 'payload' })).toEqual(expected);
    });
  });

  describe('loginBegin', () => {
    it('it has a type of LOGIN_BEGIN and sets a given payload', () => {
      const expected = {
        type: LOGIN_BEGIN,
        payload: { payload: 'payload' }
      };

      expect(loginBegin({ payload: 'payload' })).toEqual(expected);
    });
  });

  describe('loginSuccess', () => {
    it('it has a type of LOGIN_SUCCESS and sets a given token', () => {
      const expected = {
        type: LOGIN_SUCCESS,
        token: 'token'
      };

      expect(loginSuccess('token')).toEqual(expected);
    });
  });

  describe('loginError', () => {
    it('it has a type of LOGIN_ERROR and sets a given error', () => {
      const expected = {
        type: LOGIN_ERROR,
        error: 'error'
      };

      expect(loginError('error')).toEqual(expected);
    });
  });

  describe('logoutBegin', () => {
    it('it has a type of LOGOUT_BEGIN', () => {
      const expected = {
        type: LOGOUT_BEGIN,
      };

      expect(logoutBegin()).toEqual(expected);
    });
  });

  describe('logoutSuccess', () => {
    it('it has a type of LOGOUT_SUCCESS', () => {
      const expected = {
        type: LOGOUT_SUCCESS,
      };

      expect(logoutSuccess()).toEqual(expected);
    });
  });

  describe('logoutError', () => {
    it('it has a type of LOGOUT_ERROR and sets a given error', () => {
      const expected = {
        type: LOGOUT_ERROR,
        error: 'error'
      };

      expect(logoutError('error')).toEqual(expected);
    });
  });

  describe('findEnterpriseBegin', () => {
    it('it has a type of FIND_ENTERPRISE_BEGIN and sets a given payload', () => {
      const expected = {
        type: FIND_ENTERPRISE_BEGIN,
        payload: { payload: 'payload' }
      };

      expect(findEnterpriseBegin({ payload: 'payload' })).toEqual(expected);
    });
  });

  describe('findEnterpriseSuccess', () => {
    it('it has a type of FIND_ENTERPRISE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: FIND_ENTERPRISE_SUCCESS
      };

      expect(findEnterpriseSuccess({ payload: 'payload' })).toEqual(expected);
    });
  });

  describe('findEnterpriseError', () => {
    it('it has a type of FIND_ENTERPRISE_ERROR and sets a given error', () => {
      const expected = {
        type: FIND_ENTERPRISE_ERROR,
        error: 'error'
      };

      expect(findEnterpriseError('error')).toEqual(expected);
    });
  });

  describe('setUserData', () => {
    it('it has a type of SET_USER_DATA and sets the data', () => {
      const expected = {
        type: SET_USER_DATA,
        payload: { foo: 'bar' },
        append: false,
      };

      expect(setUserData({ foo: 'bar' })).toEqual(expected);
    });

    it('it has a type of SET_USER_DATA and sets the data with append', () => {
      const expected = {
        type: SET_USER_DATA,
        payload: { foo: 'bar' },
        append: true,
      };

      expect(setUserData({ foo: 'bar' }, true)).toEqual(expected);
    });
  });

  describe('toggleAdminDrawer', () => {
    it('it has a type of TOGGLE_ADMIN_DRAWER and setTo is undefined with no argument', () => {
      const expected = {
        type: TOGGLE_ADMIN_DRAWER,
        setTo: undefined,
      };

      expect(toggleAdminDrawer()).toEqual(expected);
    });

    it('it has a type of TOGGLE_ADMIN_DRAWER and setTo is equal to the passed argument', () => {
      const expected = {
        type: TOGGLE_ADMIN_DRAWER,
        setTo: false,
      };

      expect(toggleAdminDrawer(false)).toEqual(expected);
    });
  });
});
