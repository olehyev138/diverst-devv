import produce from 'immer';
import customTextReducer from 'containers/GlobalSettings/CustomText/reducer';
import {
  getCustomTextSuccess, customTextUnmount
} from 'containers/GlobalSettings/CustomText/actions';

describe('customTextReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      currentCustomText: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(customTextReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getCustomTextSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentCustomText = { id: 67 };
    });

    expect(
      customTextReducer(
        state,
        getCustomTextSuccess({
          custom_text: { id: 67 }
        })
      )
    ).toEqual(expected);
  });

  it('handles the customTextUnmount action correctly', () => {
    const expected = state;

    expect(customTextReducer(state, customTextUnmount())).toEqual(expected);
  });
});
