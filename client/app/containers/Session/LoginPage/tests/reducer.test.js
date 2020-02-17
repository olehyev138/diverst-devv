import produce from 'immer/dist/immer';

import loginPageReducer from 'containers/Session/LoginPage/reducer';
import { findEnterpriseError, loginError } from 'containers/Shared/App/actions';

/* eslint-disable default-case, no-param-reassign */
describe('loginPageReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      globalError: null,
      formErrors: {
        email: null,
        password: null,
      },
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(loginPageReducer(undefined, {})).toEqual(expected);
  });

  it('handles the findEnterpriseError action', () => {
    const expected = produce(state, (draft) => {
      draft.formErrors.email = 'error';
    });

    expect(loginPageReducer(state, findEnterpriseError({ response: { data: 'error' } })))
      .toEqual(expected);
  });

  // TODO
  xit('handles the loginBegin action', () => {
    const expected = produce(state, (draft) => {
      draft.formErrors.email = 'error';
    });

    expect(loginPageReducer(state, findEnterpriseError({ response: { data: 'error' } })))
      .toEqual(expected);
  });

  it('handles the loginError action', () => {
    const expected = produce(state, (draft) => {
      draft.formErrors.password = 'error';
    });

    expect(loginPageReducer(state, loginError({ response: { data: 'error' } })))
      .toEqual(expected);
  });
});
