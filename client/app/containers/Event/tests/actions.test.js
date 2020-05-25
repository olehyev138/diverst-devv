import {
  GET_EVENTS_BEGIN,
  GET_EVENTS_SUCCESS,
  GET_EVENTS_ERROR,
  CREATE_EVENT_BEGIN,
  CREATE_EVENT_SUCCESS,
  CREATE_EVENT_ERROR,
  DELETE_EVENT_BEGIN,
  DELETE_EVENT_SUCCESS,
  DELETE_EVENT_ERROR,
  GET_EVENT_BEGIN,
  GET_EVENT_SUCCESS,
  GET_EVENT_ERROR,
  UPDATE_EVENT_BEGIN,
  UPDATE_EVENT_SUCCESS,
  UPDATE_EVENT_ERROR,
  EVENTS_UNMOUNT,
  ARCHIVE_EVENT_BEGIN,
  ARCHIVE_EVENT_SUCCESS,
  ARCHIVE_EVENT_ERROR,
  CREATE_EVENT_COMMENT_BEGIN,
  CREATE_EVENT_COMMENT_SUCCESS,
  CREATE_EVENT_COMMENT_ERROR,
  DELETE_EVENT_COMMENT_BEGIN,
  DELETE_EVENT_COMMENT_ERROR,
  DELETE_EVENT_COMMENT_SUCCESS,
  FINALIZE_EXPENSES_BEGIN,
  FINALIZE_EXPENSES_SUCCESS,
  FINALIZE_EXPENSES_ERROR,
  JOIN_EVENT_ERROR,
  JOIN_EVENT_SUCCESS,
  JOIN_EVENT_BEGIN,
  LEAVE_EVENT_BEGIN,
  LEAVE_EVENT_ERROR,
  LEAVE_EVENT_SUCCESS,
  EXPORT_ATTENDEES_BEGIN,
  EXPORT_ATTENDEES_SUCCESS,
  EXPORT_ATTENDEES_ERROR,
} from 'containers/Event/constants';

import {
  getEventsBegin,
  getEventsSuccess,
  getEventsError,
  getEventBegin,
  getEventSuccess,
  getEventError,
  createEventBegin,
  createEventSuccess,
  createEventError,
  updateEventBegin,
  updateEventSuccess,
  updateEventError,
  deleteEventBegin,
  deleteEventSuccess,
  deleteEventError,
  eventsUnmount,
  archiveEventBegin,
  archiveEventError,
  archiveEventSuccess,
  createEventCommentBegin,
  createEventCommentSuccess,
  createEventCommentError,
} from 'containers/Event/actions';

describe('Event actions', () => {
  describe('Event list actions', () => {
    describe('getEventsBegin', () => {
      it('has a type of GET_EVENTS_BEGIN', () => {
        const expected = {
          type: GET_EVENTS_BEGIN,
        };

        expect(getEventsBegin()).toEqual(expected);
      });
    });

    describe('getEventSeccess', () => {
      it('has a type of GET_EVENTS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_EVENTS_SUCCESS,
          payload: { items: {} }
        };

        expect(getEventsSuccess({ items: { } })).toEqual(expected);
      });
    });

    describe('getEventsError', () => {
      it('has a type of GET_EVENTS_ERROR and sets a given error', () => {
        const expected = {
          type: GET_EVENTS_ERROR,
          error: 'error'
        };

        expect(getEventsError('error')).toEqual(expected);
      });
    });
  });

  describe('Event getting actions', () => {
    describe('getEventBegin', () => {
      it('has a type of GET_EVENT_BEGIN', () => {
        const expected = {
          type: GET_EVENT_BEGIN,
        };

        expect(getEventBegin()).toEqual(expected);
      });
    });

    describe('getEventSuccess', () => {
      it('has a type of GET_EVENT_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_EVENT_SUCCESS,
          payload: {}
        };

        expect(getEventSuccess({})).toEqual(expected);
      });
    });

    describe('getEventError', () => {
      it('has a type of GET_EVENT_ERROR and sets a given error', () => {
        const expected = {
          type: GET_EVENT_ERROR,
          error: 'error'
        };

        expect(getEventError('error')).toEqual(expected);
      });
    });
  });

  describe('Event creating actions', () => {
    describe('createEventBegin', () => {
      it('has a type of CREATE_EVENT_BEGIN', () => {
        const expected = {
          type: CREATE_EVENT_BEGIN,
        };

        expect(createEventBegin()).toEqual(expected);
      });
    });

    describe('createEventSuccess', () => {
      it('has a type of CREATE_EVENTS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: CREATE_EVENT_SUCCESS,
          payload: {}
        };

        expect(createEventSuccess({})).toEqual(expected);
      });
    });

    describe('createEventError', () => {
      it('has a type of CREATE_EVENT_ERROR and sets a given error', () => {
        const expected = {
          type: CREATE_EVENT_ERROR,
          error: 'error'
        };

        expect(createEventError('error')).toEqual(expected);
      });
    });
  });

  describe('Event updating actions', () => {
    describe('updateEventBegin', () => {
      it('has a type of UPDATE_EVENT_BEGIN', () => {
        const expected = {
          type: UPDATE_EVENT_BEGIN,
        };

        expect(updateEventBegin()).toEqual(expected);
      });
    });

    describe('updateEventSuccess', () => {
      it('has a type of UPDATE_EVENTS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_EVENT_SUCCESS,
          payload: {}
        };

        expect(updateEventSuccess({})).toEqual(expected);
      });
    });

    describe('updateEventError', () => {
      it('has a type of UPDATE_EVENT_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_EVENT_ERROR,
          error: 'error'
        };

        expect(updateEventError('error')).toEqual(expected);
      });
    });
  });

  describe('Event updating actions', () => {
    describe('deleteEventBegin', () => {
      it('has a type of DELETE_EVENT_BEGIN', () => {
        const expected = {
          type: DELETE_EVENT_BEGIN,
        };

        expect(deleteEventBegin()).toEqual(expected);
      });
    });

    describe('deleteEventSuccess', () => {
      it('has a type of DELETE_EVENTS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: DELETE_EVENT_SUCCESS,
          payload: {}
        };

        expect(deleteEventSuccess({})).toEqual(expected);
      });
    });

    describe('deleteEventError', () => {
      it('has a type of DELETE_EVENT_ERROR and sets a given error', () => {
        const expected = {
          type: DELETE_EVENT_ERROR,
          error: 'error'
        };

        expect(deleteEventError('error')).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('eventsUnmount', () => {
      it('has a type of EVENTS_UNMOUNT', () => {
        const expected = {
          type: EVENTS_UNMOUNT
        };

        expect(eventsUnmount()).toEqual(expected);
      });
    });
  });

  describe('Archiving actions', () => {
    describe('ArchiveEventBegin', () => {
      it('has a type of ARCHIVE_EVENT_BEGIN', () => {
        const expected = {
          type: ARCHIVE_EVENT_BEGIN,
        };

        expect(archiveEventBegin()).toEqual(expected);
      });
    });

    describe('archiveEventSuccess', () => {
      it('has a type of ARCHIVE_EVENT_SUCCESS and sets a given payload', () => {
        const expected = {
          type: ARCHIVE_EVENT_SUCCESS,
          payload: {}
        };

        expect(archiveEventSuccess({})).toEqual(expected);
      });
    });

    describe('archiveEventError', () => {
      it('has a type of ARCHIVE_EVENT_ERROR and sets a given error', () => {
        const expected = {
          type: ARCHIVE_EVENT_ERROR,
          error: 'error'
        };

        expect(archiveEventError('error')).toEqual(expected);
      });
    });
  });

  describe('Creating event comments actions', () => {
    describe('CreateEventCommentBegin', () => {
      it('has a type of CREATE_EVENT_COMMENT_BEGIN', () => {
        const expected = {
          type: CREATE_EVENT_COMMENT_BEGIN,
        };

        expect(createEventCommentBegin()).toEqual(expected);
      });
    });

    describe('CreateEventCommentSuccess', () => {
      it('has a type of CREATE_EVENT_COMMENT_SUCCESS and sets a given payload', () => {
        const expected = {
          type: CREATE_EVENT_COMMENT_SUCCESS,
          payload: {}
        };

        expect(createEventCommentSuccess({})).toEqual(expected);
      });
    });

    describe('createEventCommentError', () => {
      it('has a type of CREATE_EVENT_COMMENT_ERROR and sets a given error', () => {
        const expected = {
          type: CREATE_EVENT_COMMENT_ERROR,
          error: 'error'
        };

        expect(createEventCommentError('error')).toEqual(expected);
      });
    });
  });
});
