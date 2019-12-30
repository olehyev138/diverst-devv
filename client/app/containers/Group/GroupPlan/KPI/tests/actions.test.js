import {
  GET_UPDATE_BEGIN,
  GET_UPDATE_SUCCESS,
  GET_UPDATE_ERROR,
  GET_UPDATES_BEGIN,
  GET_UPDATES_SUCCESS,
  GET_UPDATES_ERROR,
  CREATE_UPDATE_BEGIN,
  CREATE_UPDATE_SUCCESS,
  CREATE_UPDATE_ERROR,
  UPDATE_UPDATE_BEGIN,
  UPDATE_UPDATE_SUCCESS,
  UPDATE_UPDATE_ERROR,
  DELETE_UPDATE_BEGIN,
  DELETE_UPDATE_SUCCESS,
  DELETE_UPDATE_ERROR,
  UPDATES_UNMOUNT,
} from '../constants';

import {
  getUpdateBegin,
  getUpdateSuccess,
  getUpdateError,
  getUpdatesBegin,
  getUpdatesSuccess,
  getUpdatesError,
  createUpdateBegin,
  createUpdateSuccess,
  createUpdateError,
  updateUpdateBegin,
  updateUpdateSuccess,
  updateUpdateError,
  deleteUpdateBegin,
  deleteUpdateSuccess,
  deleteUpdateError,
  updatesUnmount,
} from '../actions';

describe('kpi actions', () => {
  describe('update getting actions', () => {
    describe('getUpdateBegin', () => {
      it('has a type of GET_UPDATE_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_UPDATE_BEGIN,
          payload: { value: 726 }
        };

        expect(getUpdateBegin({ value: 726 })).toEqual(expected);
      });
    });

    describe('getUpdateSuccess', () => {
      it('has a type of GET_UPDATE_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_UPDATE_SUCCESS,
          payload: { value: 582 }
        };

        expect(getUpdateSuccess({ value: 582 })).toEqual(expected);
      });
    });

    describe('getUpdateError', () => {
      it('has a type of GET_UPDATE_ERROR and sets a given error', () => {
        const expected = {
          type: GET_UPDATE_ERROR,
          error: { value: 135 }
        };

        expect(getUpdateError({ value: 135 })).toEqual(expected);
      });
    });
  });

  describe('update list actions', () => {
    describe('getUpdatesBegin', () => {
      it('has a type of GET_UPDATES_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_UPDATES_BEGIN,
          payload: { value: 754 }
        };

        expect(getUpdatesBegin({ value: 754 })).toEqual(expected);
      });
    });

    describe('getUpdatesSuccess', () => {
      it('has a type of GET_UPDATES_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_UPDATES_SUCCESS,
          payload: { value: 382 }
        };

        expect(getUpdatesSuccess({ value: 382 })).toEqual(expected);
      });
    });

    describe('getUpdatesError', () => {
      it('has a type of GET_UPDATES_ERROR and sets a given error', () => {
        const expected = {
          type: GET_UPDATES_ERROR,
          error: { value: 523 }
        };

        expect(getUpdatesError({ value: 523 })).toEqual(expected);
      });
    });
  });

  describe('update creating actions', () => {
    describe('createUpdateBegin', () => {
      it('has a type of CREATE_UPDATE_BEGIN and sets a given payload', () => {
        const expected = {
          type: CREATE_UPDATE_BEGIN,
          payload: { value: 278 }
        };

        expect(createUpdateBegin({ value: 278 })).toEqual(expected);
      });
    });

    describe('createUpdateSuccess', () => {
      it('has a type of CREATE_UPDATE_SUCCESS and sets a given payload', () => {
        const expected = {
          type: CREATE_UPDATE_SUCCESS,
          payload: { value: 980 }
        };

        expect(createUpdateSuccess({ value: 980 })).toEqual(expected);
      });
    });

    describe('createUpdateError', () => {
      it('has a type of CREATE_UPDATE_ERROR and sets a given error', () => {
        const expected = {
          type: CREATE_UPDATE_ERROR,
          error: { value: 569 }
        };

        expect(createUpdateError({ value: 569 })).toEqual(expected);
      });
    });
  });

  describe('update updating actions', () => {
    describe('updateUpdateBegin', () => {
      it('has a type of UPDATE_UPDATE_BEGIN and sets a given payload', () => {
        const expected = {
          type: UPDATE_UPDATE_BEGIN,
          payload: { value: 484 }
        };

        expect(updateUpdateBegin({ value: 484 })).toEqual(expected);
      });
    });

    describe('updateUpdateSuccess', () => {
      it('has a type of UPDATE_UPDATE_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_UPDATE_SUCCESS,
          payload: { value: 745 }
        };

        expect(updateUpdateSuccess({ value: 745 })).toEqual(expected);
      });
    });

    describe('updateUpdateError', () => {
      it('has a type of UPDATE_UPDATE_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_UPDATE_ERROR,
          error: { value: 373 }
        };

        expect(updateUpdateError({ value: 373 })).toEqual(expected);
      });
    });
  });

  describe('update deleting actions', () => {
    describe('deleteUpdateBegin', () => {
      it('has a type of DELETE_UPDATE_BEGIN and sets a given payload', () => {
        const expected = {
          type: DELETE_UPDATE_BEGIN,
          payload: { value: 258 }
        };

        expect(deleteUpdateBegin({ value: 258 })).toEqual(expected);
      });
    });

    describe('deleteUpdateSuccess', () => {
      it('has a type of DELETE_UPDATE_SUCCESS and sets a given payload', () => {
        const expected = {
          type: DELETE_UPDATE_SUCCESS,
          payload: { value: 974 }
        };

        expect(deleteUpdateSuccess({ value: 974 })).toEqual(expected);
      });
    });

    describe('deleteUpdateError', () => {
      it('has a type of DELETE_UPDATE_ERROR and sets a given error', () => {
        const expected = {
          type: DELETE_UPDATE_ERROR,
          error: { value: 362 }
        };

        expect(deleteUpdateError({ value: 362 })).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('updatesUnmount', () => {
      it('has a type of UPDATES_UNMOUNT', () => {
        const expected = {
          type: UPDATES_UNMOUNT,
        };

        expect(updatesUnmount()).toEqual(expected);
      });
    });
  });
});
