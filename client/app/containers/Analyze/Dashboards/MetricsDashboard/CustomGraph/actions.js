/*
 *
 * CustomGraph actions
 *
 */

import {
  GET_CUSTOM_GRAPHS_BEGIN,
  GET_CUSTOM_GRAPHS_SUCCESS,
  GET_CUSTOM_GRAPHS_ERROR,
  CREATE_CUSTOM_GRAPH_BEGIN,
  CREATE_CUSTOM_GRAPH_SUCCESS,
  CREATE_CUSTOM_GRAPH_ERROR,
  DELETE_CUSTOM_GRAPH_BEGIN,
  DELETE_CUSTOM_GRAPH_SUCCESS,
  DELETE_CUSTOM_GRAPH_ERROR,
  GET_CUSTOM_GRAPH_BEGIN,
  GET_CUSTOM_GRAPH_SUCCESS,
  GET_CUSTOM_GRAPH_ERROR,
  UPDATE_CUSTOM_GRAPH_BEGIN,
  UPDATE_CUSTOM_GRAPH_SUCCESS,
  UPDATE_CUSTOM_GRAPH_ERROR,
  CUSTOM_GRAPH_UNMOUNT
} from './constants';

export function getCustomGraphsBegin(payload) {
  return {
    type: GET_CUSTOM_GRAPHS_BEGIN,
    payload
  };
}

export function getCustomGraphsSuccess(payload) {
  return {
    type: GET_CUSTOM_GRAPHS_SUCCESS,
    payload
  };
}

export function getCustomGraphsError(error) {
  return {
    type: GET_CUSTOM_GRAPHS_ERROR,
    error
  };
}

/* Getting a specific metrics dashboard */

export function getCustomGraphBegin(payload) {
  return {
    type: GET_CUSTOM_GRAPH_BEGIN,
    payload
  };
}

export function getCustomGraphSuccess(payload) {
  return {
    type: GET_CUSTOM_GRAPH_SUCCESS,
    payload
  };
}

export function getCustomGraphError(error) {
  return {
    type: GET_CUSTOM_GRAPH_ERROR,
    error,
  };
}

/* Metrics dashboard creating */

export function createCustomGraphBegin(payload) {
  return {
    type: CREATE_CUSTOM_GRAPH_BEGIN,
    payload,
  };
}

export function createCustomGraphSuccess(payload) {
  return {
    type: CREATE_CUSTOM_GRAPH_SUCCESS,
    payload,
  };
}

export function createCustomGraphError(error) {
  return {
    type: CREATE_CUSTOM_GRAPH_ERROR,
    error,
  };
}

/* Metrics dashboard updating */

export function updateCustomGraphBegin(payload) {
  return {
    type: UPDATE_CUSTOM_GRAPH_BEGIN,
    payload,
  };
}

export function updateCustomGraphSuccess(payload) {
  return {
    type: UPDATE_CUSTOM_GRAPH_SUCCESS,
    payload,
  };
}

export function updateCustomGraphError(error) {
  return {
    type: UPDATE_CUSTOM_GRAPH_ERROR,
    error,
  };
}

/* Metrics dashboard deleting */

export function deleteCustomGraphBegin(payload) {
  return {
    type: DELETE_CUSTOM_GRAPH_BEGIN,
    payload,
  };
}

export function deleteCustomGraphSuccess(payload) {
  return {
    type: DELETE_CUSTOM_GRAPH_SUCCESS,
    payload,
  };
}

export function deleteCustomGraphError(error) {
  return {
    type: DELETE_CUSTOM_GRAPH_ERROR,
    error,
  };
}

export function customGraphUnmount() {
  return {
    type: CUSTOM_GRAPH_UNMOUNT,
  };
}
