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
  GET_FIELD_BEGIN,
  GET_FIELD_SUCCESS,
  GET_FIELD_ERROR,
  GET_FIELDS_BEGIN,
  GET_FIELDS_SUCCESS,
  GET_FIELDS_ERROR,
  CREATE_FIELD_BEGIN,
  CREATE_FIELD_SUCCESS,
  CREATE_FIELD_ERROR,
  UPDATE_FIELD_BEGIN,
  UPDATE_FIELD_SUCCESS,
  UPDATE_FIELD_ERROR,
  DELETE_FIELD_BEGIN,
  DELETE_FIELD_SUCCESS,
  DELETE_FIELD_ERROR,
  FIELDS_UNMOUNT,
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
  getFieldBegin,
  getFieldSuccess,
  getFieldError,
  getFieldsBegin,
  getFieldsSuccess,
  getFieldsError,
  createFieldBegin,
  createFieldSuccess,
  createFieldError,
  updateFieldBegin,
  updateFieldSuccess,
  updateFieldError,
  deleteFieldBegin,
  deleteFieldSuccess,
  deleteFieldError,
  fieldsUnmount,
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

  describe('field getting actions', () => {
    describe('getFieldBegin', () => {
      it('has a type of GET_FIELD_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_FIELD_BEGIN,
          payload: { value: 433 }
        };

        expect(getFieldBegin({ value: 433 })).toEqual(expected);
      });
    });

    describe('getFieldSuccess', () => {
      it('has a type of GET_FIELD_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_FIELD_SUCCESS,
          payload: { value: 467 }
        };

        expect(getFieldSuccess({ value: 467 })).toEqual(expected);
      });
    });

    describe('getFieldError', () => {
      it('has a type of GET_FIELD_ERROR and sets a given error', () => {
        const expected = {
          type: GET_FIELD_ERROR,
          error: { value: 926 }
        };

        expect(getFieldError({ value: 926 })).toEqual(expected);
      });
    });
  });

  describe('field list actions', () => {
    describe('getFieldsBegin', () => {
      it('has a type of GET_FIELDS_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_FIELDS_BEGIN,
          payload: { value: 831 }
        };

        expect(getFieldsBegin({ value: 831 })).toEqual(expected);
      });
    });

    describe('getFieldsSuccess', () => {
      it('has a type of GET_FIELDS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_FIELDS_SUCCESS,
          payload: { value: 576 }
        };

        expect(getFieldsSuccess({ value: 576 })).toEqual(expected);
      });
    });

    describe('getFieldsError', () => {
      it('has a type of GET_FIELDS_ERROR and sets a given error', () => {
        const expected = {
          type: GET_FIELDS_ERROR,
          error: { value: 64 }
        };

        expect(getFieldsError({ value: 64 })).toEqual(expected);
      });
    });
  });

  describe('field creating actions', () => {
    describe('createFieldBegin', () => {
      it('has a type of CREATE_FIELD_BEGIN and sets a given payload', () => {
        const expected = {
          type: CREATE_FIELD_BEGIN,
          payload: { value: 453 }
        };

        expect(createFieldBegin({ value: 453 })).toEqual(expected);
      });
    });

    describe('createFieldSuccess', () => {
      it('has a type of CREATE_FIELD_SUCCESS and sets a given payload', () => {
        const expected = {
          type: CREATE_FIELD_SUCCESS,
          payload: { value: 295 }
        };

        expect(createFieldSuccess({ value: 295 })).toEqual(expected);
      });
    });

    describe('createFieldError', () => {
      it('has a type of CREATE_FIELD_ERROR and sets a given error', () => {
        const expected = {
          type: CREATE_FIELD_ERROR,
          error: { value: 558 }
        };

        expect(createFieldError({ value: 558 })).toEqual(expected);
      });
    });
  });

  describe('field updating actions', () => {
    describe('updateFieldBegin', () => {
      it('has a type of UPDATE_FIELD_BEGIN and sets a given payload', () => {
        const expected = {
          type: UPDATE_FIELD_BEGIN,
          payload: { value: 531 }
        };

        expect(updateFieldBegin({ value: 531 })).toEqual(expected);
      });
    });

    describe('updateFieldSuccess', () => {
      it('has a type of UPDATE_FIELD_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_FIELD_SUCCESS,
          payload: { value: 212 }
        };

        expect(updateFieldSuccess({ value: 212 })).toEqual(expected);
      });
    });

    describe('updateFieldError', () => {
      it('has a type of UPDATE_FIELD_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_FIELD_ERROR,
          error: { value: 127 }
        };

        expect(updateFieldError({ value: 127 })).toEqual(expected);
      });
    });
  });

  describe('field deleting actions', () => {
    describe('deleteFieldBegin', () => {
      it('has a type of DELETE_FIELD_BEGIN and sets a given payload', () => {
        const expected = {
          type: DELETE_FIELD_BEGIN,
          payload: { value: 589 }
        };

        expect(deleteFieldBegin({ value: 589 })).toEqual(expected);
      });
    });

    describe('deleteFieldSuccess', () => {
      it('has a type of DELETE_FIELD_SUCCESS and sets a given payload', () => {
        const expected = {
          type: DELETE_FIELD_SUCCESS,
          payload: { value: 996 }
        };

        expect(deleteFieldSuccess({ value: 996 })).toEqual(expected);
      });
    });

    describe('deleteFieldError', () => {
      it('has a type of DELETE_FIELD_ERROR and sets a given error', () => {
        const expected = {
          type: DELETE_FIELD_ERROR,
          error: { value: 936 }
        };

        expect(deleteFieldError({ value: 936 })).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('fieldsUnmount', () => {
      it('has a type of FIELDS_UNMOUNT', () => {
        const expected = {
          type: FIELDS_UNMOUNT,
        };

        expect(fieldsUnmount()).toEqual(expected);
      });
    });
  });
});
