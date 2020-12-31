import produce from 'immer';
import {
  getEnterpriseBegin, getEnterpriseError,
  getEnterpriseSuccess, updateEnterpriseBegin,
  updateEnterpriseSuccess, updateEnterpriseError,
  configurationUnmount, updateBrandingBegin, updateBrandingError,
  updateBrandingSuccess } from 'containers/GlobalSettings/EnterpriseConfiguration/actions';
import enterpriseReducer from '../reducer';


describe('enterpriseReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isLoading: true,
      isCommitting: false,
      currentEnterprise: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(enterpriseReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getEnterpriseBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isLoading = true;
    });

    expect(
      enterpriseReducer(
        state,
        getEnterpriseBegin({
          isLoading: true
        })
      )
    ).toEqual(expected);
  });

  it('handles the getEnterpriseSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentEnterprise = { id: 2, name: 'enterprise' };
      draft.isLoading = false;
    });

    expect(
      enterpriseReducer(
        state,
        getEnterpriseSuccess({
          enterprise: { id: 2, name: 'enterprise' },
          isLoading: false
        })
      )
    ).toEqual(expected);
  });

  it('handles the getEnterpriseError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isLoading = false;
    });

    expect(
      enterpriseReducer(
        state,
        getEnterpriseError({
          isLoading: false
        })
      )
    ).toEqual(expected);
  });

  [updateEnterpriseBegin, updateBrandingBegin].forEach((action) => {
    it(`handles the ${action.name} action correctly`, () => {
      const expected = produce(state, (draft) => {
        draft.isCommitting = true;
      });

      expect(
        enterpriseReducer(
          state,
          updateEnterpriseBegin({
            isCommitting: true
          })
        )
      ).toEqual(expected);
    });
  });

  [updateEnterpriseSuccess, updateEnterpriseError, updateBrandingSuccess, updateBrandingError].forEach((action) => {
    it(`handles the ${action.name} action correctly`, () => {
      const expected = produce(state, (draft) => {
        draft.isCommitting = false;
      });

      expect(
        enterpriseReducer(
          state,
          action({
            isCommitting: false
          })
        )
      ).toEqual(expected);

      expect(
        enterpriseReducer(
          state,
          updateEnterpriseError({
            isCommitting: false
          })
        )
      ).toEqual(expected);
    });
  });

  it('handles the configurationUnmount action correctly', () => {
    const expected = state;

    expect(
      enterpriseReducer(
        state,
        configurationUnmount()
      )
    ).toEqual(expected);
  });
});
