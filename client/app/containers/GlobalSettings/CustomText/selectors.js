import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/GlobalSettings/CustomText/reducer';

const selectCustomTextDomain = state => state.customText || initialState;

const selectCustomText = () => createSelector(
  selectCustomTextDomain,
  customTextState => customTextState.currentCustomText
);

export {
  selectCustomTextDomain,
  selectCustomText,
};
