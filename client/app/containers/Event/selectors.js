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

export { selectPaginatedEvents, selectEventsTotal, selectEvent };
