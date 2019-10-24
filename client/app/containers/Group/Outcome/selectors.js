import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Group/Outcome/reducer';

const selectOutcomesDomain = state => state.outcomes || initialState;

const selectPaginatedOutcomes = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.outcomes
);

const selectOutcomeTotal = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.outcomeTotal
);

const selectOutcome = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.currentOutcome
);

const selectIsLoading = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.isLoading
);

const selectIsCommitting = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.isCommitting
);

export { selectPaginatedOutcomes, selectOutcomeTotal, selectOutcome, selectIsLoading, selectIsCommitting };
