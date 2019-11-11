import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectRequestDomain = state => state.request || initialState;

const selectPaginatedRequests = () => createSelector(
  selectRequestDomain,
  requestState => requestState.requestList
);

const selectRequestsTotal = () => createSelector(
  selectRequestDomain,
  requestState => requestState.requestListTotal
);

const selectRequest = () => createSelector(
  selectRequestDomain,
  requestState => requestState.currentRequest
);

const selectIsFetchingRequests = () => createSelector(
  selectRequestDomain,
  requestState => requestState.isFetchingRequests
);

const selectSuccessfulChange = () => createSelector(
  selectRequestDomain,
  requestState => requestState.successfulChange
);

export {
  selectPaginatedRequests,
  selectRequestsTotal,
  selectRequest,
  selectIsFetchingRequests,
  selectSuccessfulChange,
};
