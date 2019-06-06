/*
 *
 * HomePage reducer
 *
 */
import produce from 'immer';
import { DEFAULT_ACTION } from './constants';

export const initialState = {};

const homePageReducer = (state = initialState, action) => produce(state, (/* draft */) => {
  switch (action.type) {
    case DEFAULT_ACTION:
      break;
  }
});

export default homePageReducer;
