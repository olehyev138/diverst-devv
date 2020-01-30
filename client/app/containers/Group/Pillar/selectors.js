import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectPillarDomain = state => state.pillars || initialState;

const selectPaginatedPillars = () => createSelector(
  selectPillarDomain,
  pillarState => pillarState.pillarList
);

const selectPaginatedSelectPillars = () => createSelector(
  selectPillarDomain,
  usersState => Object.values(usersState.pillarList).map(pillar => ({ label: pillar.name, value: pillar.id }))
);

const selectPillarsTotal = () => createSelector(
  selectPillarDomain,
  pillarState => pillarState.pillarListTotal
);

const selectPillar = () => createSelector(
  selectPillarDomain,
  pillarState => pillarState.currentPillar
);

const selectIsFetchingPillars = () => createSelector(
  selectPillarDomain,
  pillarState => pillarState.isFetchingPillars
);

const selectIsFetchingPillar = () => createSelector(
  selectPillarDomain,
  pillarState => pillarState.isFetchingPillar
);

const selectIsCommitting = () => createSelector(
  selectPillarDomain,
  pillarState => pillarState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectPillarDomain,
  pillarState => pillarState.hasChanged
);

export {
  selectPillarDomain,
  selectPaginatedPillars,
  selectPillarsTotal,
  selectPillar,
  selectIsFetchingPillars,
  selectIsFetchingPillar,
  selectIsCommitting,
  selectHasChanged,
};
