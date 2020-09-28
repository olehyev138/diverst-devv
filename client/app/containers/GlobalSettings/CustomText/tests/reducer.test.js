import produce from 'immer';
import customTextReducer from 'containers/GlobalSettings/CustomText/reducer';
import {
  updateCustomTextSuccess,
  updateCustomTextBegin,
  updateCustomTextError
} from '../actions';

/* eslint-disable default-case, no-param-reassign */
describe('customTextReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isCommitting: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(customTextReducer(undefined, {})).toEqual(expected);
  });

  it('handles the updateCustomTextSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });

    expect(
      customTextReducer(
        state,
        updateCustomTextSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the updateCustomTextError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });

    expect(
      customTextReducer(
        state,
        updateCustomTextError({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the updateCustomTextBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = true;
    });

    expect(
      customTextReducer(
        state,
        updateCustomTextBegin({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });
});
