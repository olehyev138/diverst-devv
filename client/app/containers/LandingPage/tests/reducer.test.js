// import produce from 'immer';
import landingPageReducer from '../reducer';
// import { someAction } from '../actions';

/* eslint-disable default-case, no-param-reassign */
xdescribe('landingPageReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      // default state params here
    };
  });

  xit('returns the initial state', () => {
    const expectedResult = state;
    expect(landingPageReducer(undefined, {})).toEqual(expectedResult);
  });

  /**
   * Example state change comparison
   *
   * it('should handle the someAction action correctly', () => {
   *   const expectedResult = produce(state, draft => {
   *     draft.loading = true;
   *     draft.error = false;
   *     draft.userData.nested = false;
   *   });
   *
   *   expect(appReducer(state, someAction())).toEqual(expectedResult);
   * });
   */
});
