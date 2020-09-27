import produce from 'immer';
import {
  updateSsoSettingsBegin,
  updateSsoSettingsSuccess,
  updateSsoSettingsError,
} from '../actions';

import SSOSettingsReducer from '../reducer';


describe('SSOSettingsReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isCommitting: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(SSOSettingsReducer(undefined, {})).toEqual(expected);
  });

  it('handles the updateSsoSettingsBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = true;
    });

    expect(
      SSOSettingsReducer(
        state,
        updateSsoSettingsBegin({
          isCommitting: true
        })
      )
    ).toEqual(expected);
  });

  it('handles the updateSsoSettingsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });

    expect(
      SSOSettingsReducer(
        state,
        updateSsoSettingsSuccess({
          isCommitting: false
        })
      )
    ).toEqual(expected);
  });

  it('handles the updateSsoSettingsError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });

    expect(
      SSOSettingsReducer(
        state,
        updateSsoSettingsError({
          isCommitting: false
        })
      )
    ).toEqual(expected);
  });
});
