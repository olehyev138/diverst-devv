import {
  GET_OUTCOME_BEGIN,
  GET_OUTCOME_SUCCESS,
  GET_OUTCOME_ERROR,
  GET_OUTCOMES_BEGIN,
  GET_OUTCOMES_SUCCESS,
  GET_OUTCOMES_ERROR,
  CREATE_OUTCOME_BEGIN,
  CREATE_OUTCOME_SUCCESS,
  CREATE_OUTCOME_ERROR,
  UPDATE_OUTCOME_BEGIN,
  UPDATE_OUTCOME_SUCCESS,
  UPDATE_OUTCOME_ERROR,
  DELETE_OUTCOME_BEGIN,
  DELETE_OUTCOME_SUCCESS,
  DELETE_OUTCOME_ERROR,
  OUTCOMES_UNMOUNT,
} from '../constants';

import {
  getOutcomeBegin,
  getOutcomeError,
  getOutcomeSuccess,
  getOutcomesBegin,
  getOutcomesError,
  getOutcomesSuccess,
  createOutcomeBegin,
  createOutcomeError,
  createOutcomeSuccess,
  updateOutcomeBegin,
  updateOutcomeError,
  updateOutcomeSuccess,
  deleteOutcomeBegin,
  deleteOutcomeError,
  deleteOutcomeSuccess,
  outcomesUnmount
} from '../actions';

describe('outcome actions', () => {
  describe('getOutcomeBegin', () => {
    it('has a type of GET_OUTCOME_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_OUTCOME_BEGIN,
        payload: { value: 118 }
      };

      expect(getOutcomeBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getOutcomeSuccess', () => {
    it('has a type of GET_OUTCOME_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_OUTCOME_SUCCESS,
        payload: { value: 865 }
      };

      expect(getOutcomeSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getOutcomeError', () => {
    it('has a type of GET_OUTCOME_ERROR and sets a given error', () => {
      const expected = {
        type: GET_OUTCOME_ERROR,
        error: { value: 709 }
      };

      expect(getOutcomeError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getOutcomesBegin', () => {
    it('has a type of GET_OUTCOMES_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_OUTCOMES_BEGIN,
        payload: { value: 118 }
      };

      expect(getOutcomesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getOutcomesSuccess', () => {
    it('has a type of GET_OUTCOMES_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_OUTCOMES_SUCCESS,
        payload: { value: 118 }
      };

      expect(getOutcomesSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getOutcomesError', () => {
    it('has a type of GET_OUTCOMES_ERROR and sets a given error', () => {
      const expected = {
        type: GET_OUTCOMES_ERROR,
        error: { value: 709 }
      };

      expect(getOutcomesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createOutcomeBegin', () => {
    it('has a type of CREATE_OUTCOME_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_OUTCOME_BEGIN,
        payload: { value: 118 }
      };

      expect(createOutcomeBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createOutcomeSuccess', () => {
    it('has a type of CREATE_OUTCOME_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_OUTCOME_SUCCESS,
        payload: { value: 118 }
      };

      expect(createOutcomeSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createOutcomeError', () => {
    it('has a type of CREATE_OUTCOME_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_OUTCOME_ERROR,
        error: { value: 709 }
      };

      expect(createOutcomeError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateOutcomeBegin', () => {
    it('has a type of UPDATE_OUTCOME_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_OUTCOME_BEGIN,
        payload: { value: 118 }
      };

      expect(updateOutcomeBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateOutcomeSuccess', () => {
    it('has a type of UPDATE_OUTCOME_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_OUTCOME_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateOutcomeSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateOutcomeError', () => {
    it('has a type of UPDATE_OUTCOME_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_OUTCOME_ERROR,
        error: { value: 709 }
      };

      expect(updateOutcomeError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deleteOutcomeBegin', () => {
    it('has a type of DELETE_OUTCOME_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_OUTCOME_BEGIN,
        payload: { value: 118 }
      };

      expect(deleteOutcomeBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteOutcomeSuccess', () => {
    it('has a type of DELETE_OUTCOME_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_OUTCOME_SUCCESS,
        payload: { value: 118 }
      };

      expect(deleteOutcomeSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteOutcomeError', () => {
    it('has a type of DELETE_OUTCOME_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_OUTCOME_ERROR,
        error: { value: 709 }
      };

      expect(deleteOutcomeError({ value: 709 })).toEqual(expected);
    });
  });

  describe('outcomesUnmount', () => {
    it('has a type of OUTCOMES_UNMOUNT', () => {
      const expected = {
        type: OUTCOMES_UNMOUNT,
      };

      expect(outcomesUnmount()).toEqual(expected);
    });
  });
});
