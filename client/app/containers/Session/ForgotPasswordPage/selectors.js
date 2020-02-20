import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectForgotPasswordPageDomain = state => state.forgotPasswordPage || initialState;

export {
  selectForgotPasswordPageDomain
};
