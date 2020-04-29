import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Log/reducer';

const selectLogsDomain = state => state.logs || initialState;

const selectPaginatedLogs = () => createSelector(
  selectLogsDomain,
  logsState => logsState.logList
);

const selectLogTotal = () => createSelector(
  selectLogsDomain,
  logsState => logsState.logTotal
);

const selectIsLoading = () => createSelector(
  selectLogsDomain,
  logsState => logsState.isLoading
);

export {
  selectPaginatedLogs, selectLogTotal, selectIsLoading,
};
