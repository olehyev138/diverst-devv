import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Group/Groups/reducer';

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
