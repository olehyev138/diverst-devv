import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectResponseDomain = state => state.responses || initialState;

const selectPaginatedResponses = () => createSelector(
  selectResponseDomain,
  responseState => responseState.responseList.map(res => ({ ...res, respondent: res.user ? res.user.name : 'Anonymous' }))
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
