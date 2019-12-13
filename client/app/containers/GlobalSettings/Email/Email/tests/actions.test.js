import {
  GET_EMAIL_BEGIN,
  GET_EMAIL_SUCCESS,
  GET_EMAIL_ERROR,
  GET_EMAILS_BEGIN,
  GET_EMAILS_SUCCESS,
  GET_EMAILS_ERROR,
  UPDATE_EMAIL_BEGIN,
  UPDATE_EMAIL_SUCCESS,
  UPDATE_EMAIL_ERROR,
  EMAILS_UNMOUNT,
} from '../constants';

import {
  getEmailBegin,
  getEmailSuccess,
  getEmailError,
  getEmailsBegin,
  getEmailsSuccess,
  getEmailsError,
  updateEmailBegin,
  updateEmailSuccess,
  updateEmailError,
  emailsUnmount,
} from '../actions';

describe('email actions', () => {
  describe('email getting actions', () => {
    describe('getEmailBegin', () => {
      it('has a type of GET_EMAIL_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_EMAIL_BEGIN,
          payload: { value: 803 }
        };

        expect(getEmailBegin({ value: 803 })).toEqual(expected);
      });
    });

    describe('getEmailSuccess', () => {
      it('has a type of GET_EMAIL_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_EMAIL_SUCCESS,
          payload: { value: 341 }
        };

        expect(getEmailSuccess({ value: 341 })).toEqual(expected);
      });
    });

    describe('getEmailError', () => {
      it('has a type of GET_EMAIL_ERROR and sets a given error', () => {
        const expected = {
          type: GET_EMAIL_ERROR,
          error: { value: 785 }
        };

        expect(getEmailError({ value: 785 })).toEqual(expected);
      });
    });
  });

  describe('email list actions', () => {
    describe('getEmailsBegin', () => {
      it('has a type of GET_EMAILS_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_EMAILS_BEGIN,
          payload: { value: 10 }
        };

        expect(getEmailsBegin({ value: 10 })).toEqual(expected);
      });
    });

    describe('getEmailsSuccess', () => {
      it('has a type of GET_EMAILS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_EMAILS_SUCCESS,
          payload: { value: 150 }
        };

        expect(getEmailsSuccess({ value: 150 })).toEqual(expected);
      });
    });

    describe('getEmailsError', () => {
      it('has a type of GET_EMAILS_ERROR and sets a given error', () => {
        const expected = {
          type: GET_EMAILS_ERROR,
          error: { value: 117 }
        };

        expect(getEmailsError({ value: 117 })).toEqual(expected);
      });
    });
  });

  describe('email updating actions', () => {
    describe('updateEmailBegin', () => {
      it('has a type of UPDATE_EMAIL_BEGIN and sets a given payload', () => {
        const expected = {
          type: UPDATE_EMAIL_BEGIN,
          payload: { value: 556 }
        };

        expect(updateEmailBegin({ value: 556 })).toEqual(expected);
      });
    });

    describe('updateEmailSuccess', () => {
      it('has a type of UPDATE_EMAIL_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_EMAIL_SUCCESS,
          payload: { value: 14 }
        };

        expect(updateEmailSuccess({ value: 14 })).toEqual(expected);
      });
    });

    describe('updateEmailError', () => {
      it('has a type of UPDATE_EMAIL_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_EMAIL_ERROR,
          error: { value: 648 }
        };

        expect(updateEmailError({ value: 648 })).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('emailsUnmount', () => {
      it('has a type of EMAILS_UNMOUNT', () => {
        const expected = {
          type: EMAILS_UNMOUNT,
        };

        expect(emailsUnmount()).toEqual(expected);
      });
    });
  });
});
