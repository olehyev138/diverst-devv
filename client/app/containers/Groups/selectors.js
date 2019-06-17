import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectGroupsDomain = state => state.groups || initialState;

const selectPaginatedGroups = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groups,
);

const selectGroupTotal = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groupTotal,
);

export { selectPaginatedGroups, selectGroupTotal };
