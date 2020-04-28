import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import produce from 'immer';
import { mapSelectField } from 'utils/selectorHelpers';
import dig from 'object-dig';

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

const selectFormPoll = () => createSelector(
  selectPollDomain,
  pollState => produce(pollState.currentPoll, (draft) => {
    if (pollState.currentPoll) {
      draft.groups = dig(pollState, 'currentPoll', 'groups', val => val.map(group => mapSelectField(group)));
      draft.segments = dig(pollState, 'currentPoll', 'segments', val => val.map(segment => mapSelectField(segment)));
    }
  })
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
  selectFormPoll,
  selectIsFetchingPolls,
  selectIsFetchingPoll,
  selectIsCommitting,
  selectHasChanged,
};
