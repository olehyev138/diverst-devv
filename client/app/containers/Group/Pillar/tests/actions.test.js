import {
  GET_PILLAR_BEGIN,
  GET_PILLAR_SUCCESS,
  GET_PILLAR_ERROR,
  GET_PILLARS_BEGIN,
  GET_PILLARS_SUCCESS,
  GET_PILLARS_ERROR,
  CREATE_PILLAR_BEGIN,
  CREATE_PILLAR_SUCCESS,
  CREATE_PILLAR_ERROR,
  UPDATE_PILLAR_BEGIN,
  UPDATE_PILLAR_SUCCESS,
  UPDATE_PILLAR_ERROR,
  DELETE_PILLAR_BEGIN,
  DELETE_PILLAR_SUCCESS,
  DELETE_PILLAR_ERROR,
  PILLARS_UNMOUNT,
} from '../constants';

import {
  getPillarBegin,
  getPillarError,
  getPillarSuccess,
  getPillarsBegin,
  getPillarsError,
  getPillarsSuccess,
  createPillarBegin,
  createPillarError,
  createPillarSuccess,
  updatePillarBegin,
  updatePillarError,
  updatePillarSuccess,
  deletePillarBegin,
  deletePillarError,
  deletePillarSuccess,
  pillarsUnmount
} from '../actions';

describe('pillar actions', () => {
  describe('getPillarBegin', () => {
    it('has a type of GET_PILLAR_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_PILLAR_BEGIN,
        payload: { value: 118 }
      };

      expect(getPillarBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getPillarSuccess', () => {
    it('has a type of GET_PILLAR_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_PILLAR_SUCCESS,
        payload: { value: 865 }
      };

      expect(getPillarSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getPillarError', () => {
    it('has a type of GET_PILLAR_ERROR and sets a given error', () => {
      const expected = {
        type: GET_PILLAR_ERROR,
        error: { value: 709 }
      };

      expect(getPillarError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getPillarsBegin', () => {
    it('has a type of GET_PILLARS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_PILLARS_BEGIN,
        payload: { value: 118 }
      };

      expect(getPillarsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getPillarsSuccess', () => {
    it('has a type of GET_PILLARS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_PILLARS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getPillarsSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getPillarsError', () => {
    it('has a type of GET_PILLARS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_PILLARS_ERROR,
        error: { value: 709 }
      };

      expect(getPillarsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createPillarBegin', () => {
    it('has a type of CREATE_PILLAR_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_PILLAR_BEGIN,
        payload: { value: 118 }
      };

      expect(createPillarBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createPillarSuccess', () => {
    it('has a type of CREATE_PILLAR_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_PILLAR_SUCCESS,
        payload: { value: 118 }
      };

      expect(createPillarSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createPillarError', () => {
    it('has a type of CREATE_PILLAR_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_PILLAR_ERROR,
        error: { value: 709 }
      };

      expect(createPillarError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updatePillarBegin', () => {
    it('has a type of UPDATE_PILLAR_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_PILLAR_BEGIN,
        payload: { value: 118 }
      };

      expect(updatePillarBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updatePillarSuccess', () => {
    it('has a type of UPDATE_PILLAR_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_PILLAR_SUCCESS,
        payload: { value: 118 }
      };

      expect(updatePillarSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updatePillarError', () => {
    it('has a type of UPDATE_PILLAR_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_PILLAR_ERROR,
        error: { value: 709 }
      };

      expect(updatePillarError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deletePillarBegin', () => {
    it('has a type of DELETE_PILLAR_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_PILLAR_BEGIN,
        payload: { value: 118 }
      };

      expect(deletePillarBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deletePillarSuccess', () => {
    it('has a type of DELETE_PILLAR_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_PILLAR_SUCCESS,
        payload: { value: 118 }
      };

      expect(deletePillarSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deletePillarError', () => {
    it('has a type of DELETE_PILLAR_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_PILLAR_ERROR,
        error: { value: 709 }
      };

      expect(deletePillarError({ value: 709 })).toEqual(expected);
    });
  });

  describe('pillarsUnmount', () => {
    it('has a type of PILLARS_UNMOUNT', () => {
      const expected = {
        type: PILLARS_UNMOUNT,
      };

      expect(pillarsUnmount()).toEqual(expected);
    });
  });
});
