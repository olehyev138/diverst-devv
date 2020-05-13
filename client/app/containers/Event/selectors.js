import { createSelector } from 'reselect';
import { initialState } from './reducer';
import produce from 'immer/dist/immer';
import { mapFieldNames } from 'utils/selectorHelpers';

const selectEventsDomain = state => state.events || initialState;

const selectPaginatedEvents = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.events
);

const selectCalendarEvents = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.events.map(event => mapFieldNames(event,
    {
      id: 'id',
      groupId: 'group.id',
      start: 'start',
      end: 'end',
      title: 'name',
      color: 'group.calendar_color',
    }))
);

const selectEventsTotal = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.eventsTotal
);

const selectEvent = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.currentEvent
);

const selectFormEvent = () => createSelector(
  selectEventsDomain,
  eventsState => produce(eventsState.currentEvent, (draft) => {
    if (draft) {
      if (draft.pillar)
        draft.pillar = {
          label: eventsState.currentEvent.pillar.name,
          value: eventsState.currentEvent.pillar.id
        };
      if (draft.budget_item)
        draft.budget_item = {
          label: eventsState.currentEvent.budget_item.title_with_amount,
          value: eventsState.currentEvent.budget_item.id,
          available: eventsState.currentEvent.budget_item.available_amount
        };
    }
  })
);

const selectIsLoading = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.isLoading
);

const selectIsFormLoading = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.isFormLoading
);

const selectIsCommitting = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectEventsDomain,
  eventsState => eventsState.hasChanged
);

export { selectEventsDomain, selectPaginatedEvents, selectCalendarEvents, selectEventsTotal, selectEvent, selectIsLoading, selectIsFormLoading, selectIsCommitting, selectFormEvent, selectHasChanged };
