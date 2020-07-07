import { createSelector } from 'reselect';
import { initialState } from 'containers/Group/Outcome/reducer';

const selectOutcomesDomain = state => state.outcomes || initialState;

const selectPaginatedOutcomes = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.outcomes
);

const selectOutcomesTotal = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.outcomesTotal
);

const selectOutcome = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.currentOutcome
);

const selectIsLoading = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.isLoading
);

const selectIsFormLoading = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.isFormLoading
);

const selectIsCommitting = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.isCommitting
);

export { selectPaginatedOutcomes, selectOutcomesTotal, selectOutcome, selectIsLoading, selectIsCommitting, selectIsFormLoading, selectOutcomesDomain };
