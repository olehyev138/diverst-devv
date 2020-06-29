import {
  GET_SEGMENTS_BEGIN, GET_SEGMENTS_SUCCESS, GET_SEGMENTS_ERROR,
  GET_SEGMENT_BEGIN, GET_SEGMENT_SUCCESS, GET_SEGMENT_ERROR,
  CREATE_SEGMENT_BEGIN, CREATE_SEGMENT_SUCCESS, CREATE_SEGMENT_ERROR,
  UPDATE_SEGMENT_BEGIN, UPDATE_SEGMENT_SUCCESS, UPDATE_SEGMENT_ERROR,
  DELETE_SEGMENT_BEGIN, DELETE_SEGMENT_SUCCESS, DELETE_SEGMENT_ERROR,
  GET_SEGMENT_MEMBERS_BEGIN, GET_SEGMENT_MEMBERS_SUCCESS, GET_SEGMENT_MEMBERS_ERROR,
  SEGMENT_UNMOUNT
} from 'containers/Segment/constants';

import {
  getSegmentsBegin, getSegmentsSuccess, getSegmentsError,
  getSegmentBegin, getSegmentSuccess, getSegmentError,
  createSegmentBegin, createSegmentSuccess, createSegmentError,
  updateSegmentBegin, updateSegmentSuccess, updateSegmentError,
  getSegmentMembersBegin, getSegmentMembersSuccess, getSegmentMembersError,
  deleteSegmentBegin, deleteSegmentError, deleteSegmentSuccess,
  segmentUnmount
} from 'containers/Segment/actions';

describe('segment actions', () => {
  describe('getSegmentBegin', () => {
    it('has a type of GET_SEGMENT_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_SEGMENT_BEGIN,
        payload: { value: 118 }
      };

      expect(getSegmentBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getSegmentSuccess', () => {
    it('has a type of GET_SEGMENT_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_SEGMENT_SUCCESS,
        payload: { value: 865 }
      };

      expect(getSegmentSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getSegmentError', () => {
    it('has a type of GET_SEGMENT_ERROR and sets a given error', () => {
      const expected = {
        type: GET_SEGMENT_ERROR,
        error: { value: 709 }
      };

      expect(getSegmentError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getSegmentsBegin', () => {
    it('has a type of GET_SEGMENTS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_SEGMENTS_BEGIN,
        payload: { value: 118 }
      };

      expect(getSegmentsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getSegmentsSuccess', () => {
    it('has a type of GET_SEGMENT_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_SEGMENTS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getSegmentsSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getSegmentsError', () => {
    it('has a type of GET_SEGMENTS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_SEGMENTS_ERROR,
        error: { value: 709 }
      };

      expect(getSegmentsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createSegmentBegin', () => {
    it('has a type of CREATE_SEGMENT_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_SEGMENT_BEGIN,
        payload: { value: 118 }
      };

      expect(createSegmentBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createSegmentSuccess', () => {
    it('has a type of CREATE_SEGMENT_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_SEGMENT_SUCCESS,
        payload: { value: 865 }
      };

      expect(createSegmentSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('createSegmentError', () => {
    it('has a type of CREATE_SEGMENT_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_SEGMENT_ERROR,
        error: { value: 709 }
      };

      expect(createSegmentError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateSegmentBegin', () => {
    it('has a type of UPDATE_SEGMENT_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_SEGMENT_BEGIN,
        payload: { value: 118 }
      };

      expect(updateSegmentBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateSegmentSuccess', () => {
    it('has a type of UPDATE_SEGMENT_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_SEGMENT_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateSegmentSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateSegmentError', () => {
    it('has a type of UPDATE_SEGMENT_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_SEGMENT_ERROR,
        error: { value: 709 }
      };

      expect(updateSegmentError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deleteSegmentBegin', () => {
    it('has a type of DELETE_SEGMENT_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_SEGMENT_BEGIN,
        payload: { value: 118 }
      };

      expect(deleteSegmentBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteSegmentSuccess', () => {
    it('has a type of DELETE_SEGMENT_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_SEGMENT_SUCCESS,
        payload: { value: 118 }
      };

      expect(deleteSegmentSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteSegmentError', () => {
    it('has a type of DELETE_SEGMENT_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_SEGMENT_ERROR,
        error: { value: 709 }
      };

      expect(deleteSegmentError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getSegmentMembersBegin', () => {
    it('has a type of GET_SEGMENT_MEMBERS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_SEGMENT_MEMBERS_BEGIN,
        payload: { value: 118 }
      };

      expect(getSegmentMembersBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getSegmentMembersSuccess', () => {
    it('has a type of GET_SEGMENT_MEMBERS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_SEGMENT_MEMBERS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getSegmentMembersSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getSegmentMembersError', () => {
    it('has a type of GET_SEGMENT_MEMBERS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_SEGMENT_MEMBERS_ERROR,
        error: { value: 709 }
      };

      expect(getSegmentMembersError({ value: 709 })).toEqual(expected);
    });
  });

  describe('segmentUnmount', () => {
    it('has a type of SEGMENT_UNMOUNT', () => {
      const expected = {
        type: SEGMENT_UNMOUNT,
      };

      expect(segmentUnmount()).toEqual(expected);
    });
  });
});
