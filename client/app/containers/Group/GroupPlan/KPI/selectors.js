import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectKpiDomain = state => state.kpi || initialState;

const selectPaginatedUpdates = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.updateList
);

const selectUpdatesTotal = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.updateListTotal
);

const selectUpdate = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.currentUpdate
);

const selectIsFetchingUpdates = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.isFetchingUpdates
);

const selectIsFetchingUpdate = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.isFetchingUpdate
);

const selectIsCommittingUpdate = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.isCommittingUpdate
);

const selectHasChangedUpdate = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.hasChangedUpdate
);

const selectPaginatedFields = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.fieldList
);

const selectFieldsTotal = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.fieldListTotal
);

const selectField = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.currentField
);

const selectIsFetchingFields = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.isFetchingFields
);

const selectIsFetchingField = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.isFetchingField
);

const selectIsCommittingField = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.isCommittingField
);

const selectHasChangedField = () => createSelector(
  selectKpiDomain,
  kpiState => kpiState.hasChangedField
);

export {
  selectKpiDomain,
  selectPaginatedUpdates,
  selectUpdatesTotal,
  selectUpdate,
  selectIsFetchingUpdates,
  selectIsFetchingUpdate,
  selectIsCommittingUpdate,
  selectHasChangedUpdate,
  selectPaginatedFields,
  selectFieldsTotal,
  selectField,
  selectIsFetchingFields,
  selectIsFetchingField,
  selectIsCommittingField,
  selectHasChangedField,
};
