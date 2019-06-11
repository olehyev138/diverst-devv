import produce from 'immer';

import loginPageReducer from '../reducer';
import { setEnterprise, findEnterpriseError, loginError } from 'containers/App/actions';

/* eslint-disable default-case, no-param-reassign */
describe('loginPageReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      email: {
        error: null,
      },
      password: {
        error: null,
      }
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(loginPageReducer(undefined, {})).toEqual(expected);
  });

  it('handles the setEnterprise action', () => {
    const errorState = produce(state, (draft) => {
      draft.email.error = 'error';
    });

    expect(loginPageReducer(state, setEnterprise).email.error).toBeNull();
  });

  it('handles the findEnterpriseError action', () => {
    const expected = produce(state, (draft) => {
      draft.email.error = 'error';
    });

    expect(loginPageReducer(state, findEnterpriseError({ response: { data: 'error' } })))
      .toEqual(expected);
  });

  // TODO
  xit('handles the loginBegin action', () => {
    const expected = produce(state, (draft) => {
      draft.email.error = 'error';
    });

    expect(loginPageReducer(state, findEnterpriseError({ response: { data: 'error' } })))
      .toEqual(expected);
  });

  it('handles the loginError action', () => {
    const expected = produce(state, (draft) => {
      draft.password.error = 'error';
    });

    expect(loginPageReducer(state, loginError({ response: { data: 'error' } })))
      .toEqual(expected);
  });
});
