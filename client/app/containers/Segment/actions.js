/*
 *
 * Segment actions
 *
 */

import {
  GET_SEGMENTS_BEGIN, GET_SEGMENTS_SUCCESS, GET_SEGMENTS_ERROR,
  GET_SEGMENT_BEGIN, GET_SEGMENT_SUCCESS, GET_SEGMENT_ERROR,
  CREATE_SEGMENT_BEGIN, CREATE_SEGMENT_SUCCESS, CREATE_SEGMENT_ERROR,
  UPDATE_SEGMENT_BEGIN, UPDATE_SEGMENT_SUCCESS, UPDATE_SEGMENT_ERROR,
  DELETE_SEGMENT_BEGIN, DELETE_SEGMENT_SUCCESS, DELETE_SEGMENT_ERROR,
  SEGMENT_UNMOUNT
} from 'containers/Segment/constants';

/* Segment listing */

export function getSegmentsBegin(payload) {
  return {
    type: GET_SEGMENTS_BEGIN,
    payload
  };
}

export function getSegmentsSuccess(payload) {
  return {
    type: GET_SEGMENTS_SUCCESS,
    payload
  };
}

export function getSegmentsError(error) {
  return {
    type: GET_SEGMENTS_ERROR,
    error,
  };
}

/* Getting specific group */

export function getSegmentBegin(payload) {
  return {
    type: GET_SEGMENT_BEGIN,
    payload,
  };
}

export function getSegmentSuccess(payload) {
  return {
    type: GET_SEGMENT_SUCCESS,
    payload,
  };
}

export function getSegmentError(error) {
  return {
    type: GET_SEGMENT_ERROR,
    error,
  };
}

/* Segment creating */

export function createSegmentBegin(payload) {
  return {
    type: CREATE_SEGMENT_BEGIN,
    payload,
  };
}

export function createSegmentSuccess(payload) {
  return {
    type: CREATE_SEGMENT_SUCCESS,
    payload,
  };
}

export function createSegmentError(error) {
  return {
    type: CREATE_SEGMENT_ERROR,
    error,
  };
}

/* Segment updating */

export function updateSegmentBegin(payload) {
  return {
    type: UPDATE_SEGMENT_BEGIN,
    payload,
  };
}

export function updateSegmentSuccess(payload) {
  return {
    type: UPDATE_SEGMENT_SUCCESS,
    payload,
  };
}

export function updateSegmentError(error) {
  return {
    type: UPDATE_SEGMENT_ERROR,
    error,
  };
}

/* Segment deleting */

export function deleteSegmentBegin(payload) {
  return {
    type: DELETE_SEGMENT_BEGIN,
    payload,
  };
}

export function deleteSegmentSuccess(payload) {
  return {
    type: DELETE_SEGMENT_SUCCESS,
    payload,
  };
}

export function deleteSegmentError(error) {
  return {
    type: DELETE_SEGMENT_ERROR,
    error,
  };
}

export function segmentUnmount() {
  return {
    type: SEGMENT_UNMOUNT
  };
}
