import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectPollDomain = state => state.polls || initialState;

const selectPaginatedPolls = () => createSelector(
  selectPollDomain,
  pollState => pollState.pollList
);

const selectPollsTotal = () => createSelector(
  selectPollDomain,
  pollState => pollState.pollListTotal
);

const selectPoll = () => createSelector(
  selectPollDomain,
  pollState => pollState.currentPoll
);

const selectIsFetchingPolls = () => createSelector(
  selectPollDomain,
  pollState => pollState.isFetchingPolls
);

const selectIsFetchingPoll = () => createSelector(
  selectPollDomain,
  pollState => pollState.isFetchingPoll
);

const selectIsCommitting = () => createSelector(
  selectPollDomain,
  pollState => pollState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectPollDomain,
  pollState => pollState.hasChanged
);

export {
  selectPollDomain,
  selectPaginatedPolls,
  selectPollsTotal,
  selectPoll,
  selectIsFetchingPolls,
  selectIsFetchingPoll,
  selectIsCommitting,
  selectHasChanged,
};
