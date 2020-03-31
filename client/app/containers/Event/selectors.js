import { createSelector } from 'reselect';
import { initialState } from './reducer';
import produce from 'immer/dist/immer';

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

const selectFormEvent = () => createSelector(
  selectEventsDomain,
  eventsState => produce(eventsState.currentEvent, (draft) => {
    if (draft) {
      if (draft.pillar)
        draft.pillar = { label: draft.pillar.name, value: draft.pillar.id };
      if (draft.budget_item)
        draft.budget_item = { label: draft.budget_item.title_with_amount, value: draft.budget_item.id, available: draft.available };
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

export { selectEventsDomain, selectPaginatedEvents, selectEventsTotal, selectEvent, selectIsLoading, selectIsFormLoading, selectIsCommitting, selectFormEvent, selectHasChanged };
