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
  createSegmentSuccess, createSegmentError,
  getSegmentBegin, getSegmentSuccess, getSegmentError,
  updateSegmentSuccess, updateSegmentError,
  getSegmentMembersSuccess, getSegmentMembersError,
  deleteSegmentError, deleteSegmentSuccess,
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
        type: GET_SEGMENT_SUCCESS,
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
});
