import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectCsvFileDomain = state => state.csv_files || initialState;

const selectIsCommitting = () => createSelector(
  selectCsvFileDomain,
  csvFileState => csvFileState.isCommitting
);

export {
  selectCsvFileDomain,
  selectIsCommitting,
};
