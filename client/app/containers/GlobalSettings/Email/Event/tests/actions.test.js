import {
  GET_EVENT_BEGIN,
  GET_EVENT_SUCCESS,
  GET_EVENT_ERROR,
  GET_EVENTS_BEGIN,
  GET_EVENTS_SUCCESS,
  GET_EVENTS_ERROR,
  UPDATE_EVENT_BEGIN,
  UPDATE_EVENT_SUCCESS,
  UPDATE_EVENT_ERROR,
  EVENTS_UNMOUNT,
} from '../constants';

import {
  getEventBegin,
  getEventSuccess,
  getEventError,
  getEventsBegin,
  getEventsSuccess,
  getEventsError,
  updateEventBegin,
  updateEventSuccess,
  updateEventError,
  eventsUnmount,
} from '../actions';

describe('event actions', () => {
  describe('event getting actions', () => {
    describe('getEventBegin', () => {
      it('has a type of GET_EVENT_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_EVENT_BEGIN,
          payload: { value: 101 }
        };

        expect(getEventBegin({ value: 101 })).toEqual(expected);
      });
    });

    describe('getEventSuccess', () => {
      it('has a type of GET_EVENT_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_EVENT_SUCCESS,
          payload: { value: 656 }
        };

        expect(getEventSuccess({ value: 656 })).toEqual(expected);
      });
    });

    describe('getEventError', () => {
      it('has a type of GET_EVENT_ERROR and sets a given error', () => {
        const expected = {
          type: GET_EVENT_ERROR,
          error: { value: 249 }
        };

        expect(getEventError({ value: 249 })).toEqual(expected);
      });
    });
  });

  describe('event list actions', () => {
    describe('getEventsBegin', () => {
      it('has a type of GET_EVENTS_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_EVENTS_BEGIN,
          payload: { value: 491 }
        };

        expect(getEventsBegin({ value: 491 })).toEqual(expected);
      });
    });

    describe('getEventsSuccess', () => {
      it('has a type of GET_EVENTS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_EVENTS_SUCCESS,
          payload: { value: 992 }
        };

        expect(getEventsSuccess({ value: 992 })).toEqual(expected);
      });
    });

    describe('getEventsError', () => {
      it('has a type of GET_EVENTS_ERROR and sets a given error', () => {
        const expected = {
          type: GET_EVENTS_ERROR,
          error: { value: 685 }
        };

        expect(getEventsError({ value: 685 })).toEqual(expected);
      });
    });
  });

  describe('event updating actions', () => {
    describe('updateEventBegin', () => {
      it('has a type of UPDATE_EVENT_BEGIN and sets a given payload', () => {
        const expected = {
          type: UPDATE_EVENT_BEGIN,
          payload: { value: 272 }
        };

        expect(updateEventBegin({ value: 272 })).toEqual(expected);
      });
    });

    describe('updateEventSuccess', () => {
      it('has a type of UPDATE_EVENT_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_EVENT_SUCCESS,
          payload: { value: 339 }
        };

        expect(updateEventSuccess({ value: 339 })).toEqual(expected);
      });
    });

    describe('updateEventError', () => {
      it('has a type of UPDATE_EVENT_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_EVENT_ERROR,
          error: { value: 138 }
        };

        expect(updateEventError({ value: 138 })).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('eventsUnmount', () => {
      it('has a type of EVENTS_UNMOUNT', () => {
        const expected = {
          type: EVENTS_UNMOUNT,
        };

        expect(eventsUnmount()).toEqual(expected);
      });
    });
  });
});
