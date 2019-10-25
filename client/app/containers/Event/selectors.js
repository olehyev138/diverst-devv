import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectEventsDomain = state => state.events || initialState;

const selectPaginatedEvents = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.events
);

const selectEventsTotal = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.eventsTotal
);

const selectEvent = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.currentEvent
);

const selectIsLoading = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.isLoading
);

const selectIsCommitting = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.isCommitting
);

export { selectEventsDomain, selectPaginatedEvents, selectEventsTotal, selectEvent, selectIsLoading, selectIsCommitting };
