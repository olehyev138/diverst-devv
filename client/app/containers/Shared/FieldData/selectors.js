import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectFieldDataDomain = state => state.fieldData || initialState;

const selectIsCommitting = () => createSelector(
  selectFieldDataDomain,
  fieldDataState => fieldDataState.isCommitting
);

export {
  selectFieldDataDomain,
  selectIsCommitting,
};
