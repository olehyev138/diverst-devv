import {
  GET_POLL_BEGIN,
  GET_POLL_SUCCESS,
  GET_POLL_ERROR,
  GET_POLLS_BEGIN,
  GET_POLLS_SUCCESS,
  GET_POLLS_ERROR,
  CREATE_POLL_BEGIN,
  CREATE_POLL_SUCCESS,
  CREATE_POLL_ERROR,
  UPDATE_POLL_BEGIN,
  UPDATE_POLL_SUCCESS,
  UPDATE_POLL_ERROR,
  DELETE_POLL_BEGIN,
  DELETE_POLL_SUCCESS,
  DELETE_POLL_ERROR,
  POLLS_UNMOUNT,
} from '../constants';

import {
  getPollBegin,
  getPollError,
  getPollSuccess,
  getPollsBegin,
  getPollsError,
  getPollsSuccess,
  createPollBegin,
  createPollError,
  createPollSuccess,
  updatePollBegin,
  updatePollError,
  updatePollSuccess,
  deletePollBegin,
  deletePollError,
  deletePollSuccess,
  pollsUnmount
} from '../actions';

describe('poll actions', () => {
  describe('getPollBegin', () => {
    it('has a type of GET_POLL_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_POLL_BEGIN,
        payload: { value: 118 }
      };

      expect(getPollBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getPollSuccess', () => {
    it('has a type of GET_POLL_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_POLL_SUCCESS,
        payload: { value: 865 }
      };

      expect(getPollSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getPollError', () => {
    it('has a type of GET_POLL_ERROR and sets a given error', () => {
      const expected = {
        type: GET_POLL_ERROR,
        error: { value: 709 }
      };

      expect(getPollError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getPollsBegin', () => {
    it('has a type of GET_POLLS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_POLLS_BEGIN,
        payload: { value: 118 }
      };

      expect(getPollsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getPollsSuccess', () => {
    it('has a type of GET_POLLS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_POLLS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getPollsSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getPollsError', () => {
    it('has a type of GET_POLLS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_POLLS_ERROR,
        error: { value: 709 }
      };

      expect(getPollsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createPollBegin', () => {
    it('has a type of CREATE_POLL_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_POLL_BEGIN,
        payload: { value: 118 }
      };

      expect(createPollBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createPollSuccess', () => {
    it('has a type of CREATE_POLL_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_POLL_SUCCESS,
        payload: { value: 118 }
      };

      expect(createPollSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createPollError', () => {
    it('has a type of CREATE_POLL_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_POLL_ERROR,
        error: { value: 709 }
      };

      expect(createPollError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updatePollBegin', () => {
    it('has a type of UPDATE_POLL_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_POLL_BEGIN,
        payload: { value: 118 }
      };

      expect(updatePollBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updatePollSuccess', () => {
    it('has a type of UPDATE_POLL_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_POLL_SUCCESS,
        payload: { value: 118 }
      };

      expect(updatePollSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updatePollError', () => {
    it('has a type of UPDATE_POLL_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_POLL_ERROR,
        error: { value: 709 }
      };

      expect(updatePollError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deletePollBegin', () => {
    it('has a type of DELETE_POLL_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_POLL_BEGIN,
        payload: { value: 118 }
      };

      expect(deletePollBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deletePollSuccess', () => {
    it('has a type of DELETE_POLL_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_POLL_SUCCESS,
        payload: { value: 118 }
      };

      expect(deletePollSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deletePollError', () => {
    it('has a type of DELETE_POLL_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_POLL_ERROR,
        error: { value: 709 }
      };

      expect(deletePollError({ value: 709 })).toEqual(expected);
    });
  });

  describe('pollsUnmount', () => {
    it('has a type of POLLS_UNMOUNT', () => {
      const expected = {
        type: POLLS_UNMOUNT,
      };

      expect(pollsUnmount()).toEqual(expected);
    });
  });
});
