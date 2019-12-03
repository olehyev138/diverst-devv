import {
  GET_SESSION_BEGIN,
  GET_SESSION_SUCCESS,
  GET_SESSION_ERROR,
  GET_HOSTING_SESSIONS_BEGIN,
  GET_HOSTING_SESSIONS_SUCCESS,
  GET_HOSTING_SESSIONS_ERROR,
  GET_PARTICIPATING_SESSIONS_BEGIN,
  GET_PARTICIPATING_SESSIONS_SUCCESS,
  GET_PARTICIPATING_SESSIONS_ERROR,
  GET_PARTICIPATING_USERS_BEGIN,
  GET_PARTICIPATING_USERS_SUCCESS,
  GET_PARTICIPATING_USERS_ERROR,
  CREATE_SESSION_BEGIN,
  CREATE_SESSION_SUCCESS,
  CREATE_SESSION_ERROR,
  UPDATE_SESSION_BEGIN,
  UPDATE_SESSION_SUCCESS,
  UPDATE_SESSION_ERROR,
  DELETE_SESSION_BEGIN,
  DELETE_SESSION_SUCCESS,
  DELETE_SESSION_ERROR,
  ACCEPT_INVITATION_BEGIN,
  ACCEPT_INVITATION_SUCCESS,
  ACCEPT_INVITATION_ERROR,
  DECLINE_INVITATION_BEGIN,
  DECLINE_INVITATION_SUCCESS,
  DECLINE_INVITATION_ERROR,
  SESSIONS_UNMOUNT,
  SESSION_USERS_UNMOUNT,
} from '../constants';

import {
  getSessionBegin,
  getSessionSuccess,
  getSessionError,
  getHostingSessionsBegin,
  getHostingSessionsSuccess,
  getHostingSessionsError,
  getParticipatingSessionsBegin,
  getParticipatingSessionsSuccess,
  getParticipatingSessionsError,
  getParticipatingUsersBegin,
  getParticipatingUsersSuccess,
  getParticipatingUsersError,
  createSessionBegin,
  createSessionSuccess,
  createSessionError,
  updateSessionBegin,
  updateSessionSuccess,
  updateSessionError,
  deleteSessionBegin,
  deleteSessionSuccess,
  deleteSessionError,
  acceptInvitationBegin,
  acceptInvitationSuccess,
  acceptInvitationError,
  declineInvitationBegin,
  declineInvitationSuccess,
  declineInvitationError,
  sessionsUnmount,
  sessionUsersUnmount,
} from '../actions';

describe('session actions', () => {
  describe('session getting actions', () => {
    describe('getSessionBegin', () => {
      it('has a type of GET_SESSION_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_SESSION_BEGIN,
          payload: { value: 616 }
        };

        expect(getSessionBegin({ value: 616 })).toEqual(expected);
      });
    });

    describe('getSessionSuccess', () => {
      it('has a type of GET_SESSION_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_SESSION_SUCCESS,
          payload: { value: 960 }
        };

        expect(getSessionSuccess({ value: 960 })).toEqual(expected);
      });
    });

    describe('getSessionError', () => {
      it('has a type of GET_SESSION_ERROR and sets a given error', () => {
        const expected = {
          type: GET_SESSION_ERROR,
          error: { value: 564 }
        };

        expect(getSessionError({ value: 564 })).toEqual(expected);
      });
    });
  });

  describe('hosting session list actions', () => {
    describe('getHostingSessionsBegin', () => {
      it('has a type of GET_HOSTING_SESSIONS_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_HOSTING_SESSIONS_BEGIN,
          payload: { value: 634 }
        };

        expect(getHostingSessionsBegin({ value: 634 })).toEqual(expected);
      });
    });

    describe('getHostingSessionsSuccess', () => {
      it('has a type of GET_HOSTING_SESSIONS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_HOSTING_SESSIONS_SUCCESS,
          payload: { value: 52 }
        };

        expect(getHostingSessionsSuccess({ value: 52 })).toEqual(expected);
      });
    });

    describe('getHostingSessionsError', () => {
      it('has a type of GET_HOSTING_SESSIONS_ERROR and sets a given error', () => {
        const expected = {
          type: GET_HOSTING_SESSIONS_ERROR,
          error: { value: 495 }
        };

        expect(getHostingSessionsError({ value: 495 })).toEqual(expected);
      });
    });
  });

  describe('participating session list actions', () => {
    describe('getParticipatingSessionsBegin', () => {
      it('has a type of GET_PARTICIPATING_SESSIONS_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_PARTICIPATING_SESSIONS_BEGIN,
          payload: { value: 784 }
        };

        expect(getParticipatingSessionsBegin({ value: 784 })).toEqual(expected);
      });
    });

    describe('getParticipatingSessionsSuccess', () => {
      it('has a type of GET_PARTICIPATING_SESSIONS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_PARTICIPATING_SESSIONS_SUCCESS,
          payload: { value: 248 }
        };

        expect(getParticipatingSessionsSuccess({ value: 248 })).toEqual(expected);
      });
    });

    describe('getParticipatingSessionsError', () => {
      it('has a type of GET_PARTICIPATING_SESSIONS_ERROR and sets a given error', () => {
        const expected = {
          type: GET_PARTICIPATING_SESSIONS_ERROR,
          error: { value: 802 }
        };

        expect(getParticipatingSessionsError({ value: 802 })).toEqual(expected);
      });
    });
  });

  describe('participating user list actions', () => {
    describe('getParticipatingUsersBegin', () => {
      it('has a type of GET_PARTICIPATING_USERS_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_PARTICIPATING_USERS_BEGIN,
          payload: { value: 467 }
        };

        expect(getParticipatingUsersBegin({ value: 467 })).toEqual(expected);
      });
    });

    describe('getParticipatingUsersSuccess', () => {
      it('has a type of GET_PARTICIPATING_USERS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_PARTICIPATING_USERS_SUCCESS,
          payload: { value: 377 }
        };

        expect(getParticipatingUsersSuccess({ value: 377 })).toEqual(expected);
      });
    });

    describe('getParticipatingUsersError', () => {
      it('has a type of GET_PARTICIPATING_USERS_ERROR and sets a given error', () => {
        const expected = {
          type: GET_PARTICIPATING_USERS_ERROR,
          error: { value: 681 }
        };

        expect(getParticipatingUsersError({ value: 681 })).toEqual(expected);
      });
    });
  });

  describe('session creating actions', () => {
    describe('createSessionBegin', () => {
      it('has a type of CREATE_SESSION_BEGIN and sets a given payload', () => {
        const expected = {
          type: CREATE_SESSION_BEGIN,
          payload: { value: 566 }
        };

        expect(createSessionBegin({ value: 566 })).toEqual(expected);
      });
    });

    describe('createSessionSuccess', () => {
      it('has a type of CREATE_SESSION_SUCCESS and sets a given payload', () => {
        const expected = {
          type: CREATE_SESSION_SUCCESS,
          payload: { value: 588 }
        };

        expect(createSessionSuccess({ value: 588 })).toEqual(expected);
      });
    });

    describe('createSessionError', () => {
      it('has a type of CREATE_SESSION_ERROR and sets a given error', () => {
        const expected = {
          type: CREATE_SESSION_ERROR,
          error: { value: 799 }
        };

        expect(createSessionError({ value: 799 })).toEqual(expected);
      });
    });
  });

  describe('session updating actions', () => {
    describe('updateSessionBegin', () => {
      it('has a type of UPDATE_SESSION_BEGIN and sets a given payload', () => {
        const expected = {
          type: UPDATE_SESSION_BEGIN,
          payload: { value: 332 }
        };

        expect(updateSessionBegin({ value: 332 })).toEqual(expected);
      });
    });

    describe('updateSessionSuccess', () => {
      it('has a type of UPDATE_SESSION_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_SESSION_SUCCESS,
          payload: { value: 373 }
        };

        expect(updateSessionSuccess({ value: 373 })).toEqual(expected);
      });
    });

    describe('updateSessionError', () => {
      it('has a type of UPDATE_SESSION_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_SESSION_ERROR,
          error: { value: 326 }
        };

        expect(updateSessionError({ value: 326 })).toEqual(expected);
      });
    });
  });

  describe('session deleting actions', () => {
    describe('deleteSessionBegin', () => {
      it('has a type of DELETE_SESSION_BEGIN and sets a given payload', () => {
        const expected = {
          type: DELETE_SESSION_BEGIN,
          payload: { value: 766 }
        };

        expect(deleteSessionBegin({ value: 766 })).toEqual(expected);
      });
    });

    describe('deleteSessionSuccess', () => {
      it('has a type of DELETE_SESSION_SUCCESS and sets a given payload', () => {
        const expected = {
          type: DELETE_SESSION_SUCCESS,
          payload: { value: 942 }
        };

        expect(deleteSessionSuccess({ value: 942 })).toEqual(expected);
      });
    });

    describe('deleteSessionError', () => {
      it('has a type of DELETE_SESSION_ERROR and sets a given error', () => {
        const expected = {
          type: DELETE_SESSION_ERROR,
          error: { value: 831 }
        };

        expect(deleteSessionError({ value: 831 })).toEqual(expected);
      });
    });
  });

  describe('invitation accepting actions', () => {
    describe('acceptInvitationBegin', () => {
      it('has a type of ACCEPT_INVITATION_BEGIN and sets a given payload', () => {
        const expected = {
          type: ACCEPT_INVITATION_BEGIN,
          payload: { value: 561 }
        };

        expect(acceptInvitationBegin({ value: 561 })).toEqual(expected);
      });
    });

    describe('acceptInvitationSuccess', () => {
      it('has a type of ACCEPT_INVITATION_SUCCESS and sets a given payload', () => {
        const expected = {
          type: ACCEPT_INVITATION_SUCCESS,
          payload: { value: 952 }
        };

        expect(acceptInvitationSuccess({ value: 952 })).toEqual(expected);
      });
    });

    describe('acceptInvitationError', () => {
      it('has a type of ACCEPT_INVITATION_ERROR and sets a given error', () => {
        const expected = {
          type: ACCEPT_INVITATION_ERROR,
          error: { value: 980 }
        };

        expect(acceptInvitationError({ value: 980 })).toEqual(expected);
      });
    });
  });

  describe('invitation declining actions', () => {
    describe('declineInvitationBegin', () => {
      it('has a type of DECLINE_INVITATION_BEGIN and sets a given payload', () => {
        const expected = {
          type: DECLINE_INVITATION_BEGIN,
          payload: { value: 984 }
        };

        expect(declineInvitationBegin({ value: 984 })).toEqual(expected);
      });
    });

    describe('declineInvitationSuccess', () => {
      it('has a type of DECLINE_INVITATION_SUCCESS and sets a given payload', () => {
        const expected = {
          type: DECLINE_INVITATION_SUCCESS,
          payload: { value: 636 }
        };

        expect(declineInvitationSuccess({ value: 636 })).toEqual(expected);
      });
    });

    describe('declineInvitationError', () => {
      it('has a type of DECLINE_INVITATION_ERROR and sets a given error', () => {
        const expected = {
          type: DECLINE_INVITATION_ERROR,
          error: { value: 667 }
        };

        expect(declineInvitationError({ value: 667 })).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('sessionsUnmount', () => {
      it('has a type of SESSIONS_UNMOUNT', () => {
        const expected = {
          type: SESSIONS_UNMOUNT,
        };

        expect(sessionsUnmount()).toEqual(expected);
      });
    });

    describe('sessionUsersUnmount', () => {
      it('has a type of SESSION_USERS_UNMOUNT', () => {
        const expected = {
          type: SESSION_USERS_UNMOUNT,
        };

        expect(sessionUsersUnmount()).toEqual(expected);
      });
    });
  });
});
