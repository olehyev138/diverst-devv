import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectUpdateDomain = state => state.updates || initialState;

const selectPaginatedUpdates = () => createSelector(
  selectUpdateDomain,
  updateState => updateState.updateList
);

const selectUpdatesTotal = () => createSelector(
  selectUpdateDomain,
  updateState => updateState.updateListTotal
);

const selectUpdate = () => createSelector(
  selectUpdateDomain,
  updateState => updateState.currentUpdate
);

const selectIsFetchingUpdates = () => createSelector(
  selectUpdateDomain,
  updateState => updateState.isFetchingUpdates
);

const selectIsFetchingUpdate = () => createSelector(
  selectUpdateDomain,
  updateState => updateState.isFetchingUpdate
);

const selectIsCommitting = () => createSelector(
  selectUpdateDomain,
  updateState => updateState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectUpdateDomain,
  updateState => updateState.hasChanged
);

export {
  selectUpdateDomain,
  selectPaginatedUpdates,
  selectUpdatesTotal,
  selectUpdate,
  selectIsFetchingUpdates,
  selectIsFetchingUpdate,
  selectIsCommitting,
  selectHasChanged,
};
