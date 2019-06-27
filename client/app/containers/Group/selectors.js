import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Group/reducer';

const selectGroupsDomain = state => state.groups || initialState;

const selectPaginatedGroups = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groups
);

const selectGroupTotal = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groupTotal
);

const selectGroup = id => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groups[id]
);

export { selectPaginatedGroups, selectGroupTotal, selectGroup };
