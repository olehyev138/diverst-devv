import { createSelector } from 'reselect';
import { initialState } from 'containers/GlobalSettings/CustomText/reducer';

const selectCustomTextDomain = state => state.custom_text || initialState;


const selectIsCommitting = () => createSelector(
  selectCustomTextDomain,
  customTextState => customTextState.isCommitting
);

export { selectIsCommitting };
