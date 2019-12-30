import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectUpdateDomain = state => state.updates || initialState;

const selectPaginatedUpdates = () => createSelector(
  selectUpdateDomain,
  kpiState => kpiState.updateList
);

const selectUpdateTotal = () => createSelector(
  selectUpdateDomain,
  kpiState => kpiState.updateListTotal
);

const selectUpdate = () => createSelector(
  selectUpdateDomain,
  kpiState => kpiState.currentUpdate
);

const selectIsFetchingUpdates = () => createSelector(
  selectUpdateDomain,
  kpiState => kpiState.isFetchingUpdates
);

const selectIsFetchingKpi = () => createSelector(
  selectUpdateDomain,
  kpiState => kpiState.isFetchingUpdate
);

const selectIsCommitting = () => createSelector(
  selectUpdateDomain,
  kpiState => kpiState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectUpdateDomain,
  kpiState => kpiState.hasChanged
);

export {
  selectUpdateDomain,
  selectPaginatedUpdates,
  selectUpdateTotal,
  selectUpdate,
  selectIsFetchingUpdates,
  selectIsFetchingKpi,
  selectIsCommitting,
  selectHasChanged,
};
