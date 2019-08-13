import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Group/Outcome/reducer';

const selectOutcomesDomain = state => state.outcomes || initialState;

const selectOutcomes = () => createSelector(
  selectOutcomesDomain,
  outcomesState => outcomesState.outcomes
);

export { selectOutcomes };
