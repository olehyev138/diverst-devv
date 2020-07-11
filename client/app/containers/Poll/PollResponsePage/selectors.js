import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import produce from 'immer';
import { mapFieldData } from 'utils/customFieldHelpers';

const selectPollResponseDomain = state => state.pollResponse || initialState;

const selectToken = () => createSelector(
  selectPollResponseDomain,
  responseState => responseState.token
);

const selectResponse = () => createSelector(
  selectPollResponseDomain,
  (responseState) => {
    const { response } = responseState;
    if (response)
      return produce(response, (draft) => {
        draft.field_data = mapFieldData(response.field_data);
      });

    return null;
  }
);

const selectIsLoading = () => createSelector(
  selectPollResponseDomain,
  responseState => responseState.isLoading
);

const selectIsCommitting = () => createSelector(
  selectPollResponseDomain,
  responseState => responseState.isCommitting
);

const selectFormErrors = () => createSelector(
  selectPollResponseDomain,
  responseState => responseState.errors
);

export {
  selectPollResponseDomain, selectToken,
  selectIsLoading, selectResponse, selectFormErrors,
  selectIsCommitting,
};
