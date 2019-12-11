import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import produce from 'immer';

const weekdays = [
  'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'
];

const selectEventDomain = state => state.mailEvents || initialState;

const selectPaginatedEvents = () => createSelector(
  selectEventDomain,
  eventState => eventState.eventList
);

const selectEventsTotal = () => createSelector(
  selectEventDomain,
  eventState => eventState.eventListTotal
);

const selectEvent = () => createSelector(
  selectEventDomain,
  eventState => eventState.currentEvent
);

const selectFormEvent = () => createSelector(
  selectEventDomain,
  (configurationState) => {
    const event = configurationState.currentEvent;

    if (event) {
      const timezoneArray = event.timezones;
      return produce(event, (draft) => {
        draft.timezones = timezoneArray.map((element) => {
          if (element[1] === event.tz)
            draft.tz = { label: element[1], value: element[0] };
          return { label: element[1], value: element[0] };
        });

        draft.day = { label: weekdays.indexOf(event.day), value: event.day || '' };
      });
    }

    return null;
  }
);

const selectIsFetchingEvents = () => createSelector(
  selectEventDomain,
  eventState => eventState.isFetchingEvents
);

const selectIsFetchingEvent = () => createSelector(
  selectEventDomain,
  eventState => eventState.isFetchingEvent
);

const selectIsCommitting = () => createSelector(
  selectEventDomain,
  eventState => eventState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectEventDomain,
  eventState => eventState.hasChanged
);

export {
  selectEventDomain,
  selectPaginatedEvents,
  selectEventsTotal,
  selectEvent,
  selectFormEvent,
  selectIsFetchingEvents,
  selectIsFetchingEvent,
  selectIsCommitting,
  selectHasChanged,
};
