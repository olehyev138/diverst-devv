import appReducer from '../reducer'
import {
  LOGIN_BEGIN, LOGIN_SUCCESS, LOGIN_ERROR,
  LOGOUT_BEGIN, LOGOUT_SUCCESS, LOGOUT_ERROR,
  FIND_ENTERPRISE_BEGIN, SET_ENTERPRISE, FIND_ENTERPRISE_ERROR,
  SET_USER
} from '../constants';


describe('appReducer', () => {
  it('returns the initial state', () => {
    const expected = {
      loading: false,
      user: null,
      enterprise: null,
      domain: null,
      token: null,
    };

    expect(appReducer(undefined, {})).toEqual(expected);
  });

//  it('handles LOGIN_BEGIN', () => {
//    const action = { type: LOGIN_BEGIN, payload: { payload: 'payload' } };
//
//    expect(appReducer(undefined, action)).toEqual({});
//  });
});
