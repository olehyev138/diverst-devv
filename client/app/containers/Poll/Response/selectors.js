import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import { mapFieldData, mapSelectField, timezoneMap } from 'utils/selectorHelpers';

const selectResponseDomain = state => state.responses || initialState;

const mapResponse = response => ({
  ...response,
  respondent: response.user ? response.user.name : 'Anonymous',
  field_data: mapFieldData(response.field_data),
});

const selectPaginatedResponses = () => createSelector(
  selectResponseDomain,
  responseState => responseState.responseList.map(mapResponse)
);

const selectResponsesTotal = () => createSelector(
  selectResponseDomain,
  responseState => responseState.responseListTotal
);

const selectResponse = () => createSelector(
  selectResponseDomain,
  responseState => responseState.currentResponse
);

const selectIsFetchingResponses = () => createSelector(
  selectResponseDomain,
  responseState => responseState.isFetchingResponses
);

const selectIsFetchingResponse = () => createSelector(
  selectResponseDomain,
  responseState => responseState.isFetchingResponse
);

const selectIsCommitting = () => createSelector(
  selectResponseDomain,
  responseState => responseState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectResponseDomain,
  responseState => responseState.hasChanged
);

export {
  selectResponseDomain,
  selectPaginatedResponses,
  selectResponsesTotal,
  selectResponse,
  selectIsFetchingResponses,
  selectIsFetchingResponse,
  selectIsCommitting,
  selectHasChanged,
};
