import { createSelector } from 'reselect';
import { initialState } from './reducer';


const selectArchivesDomain = state => state.archives || initialState;

const selectArchives = () => createSelector(
  selectArchivesDomain,
  archiveState => archiveState.archives
);

const selectIsLoading = () => createSelector(
  selectArchivesDomain,
  archiveState => archiveState.isLoading
);

const selectArchivesTotal = () => createSelector(
  selectArchivesDomain,
  archiveState => archiveState.archivesTotal
);

const selectHasChanged = () => createSelector(
  selectArchivesDomain,
  archiveState => archiveState.hasChanged
);

export {
  selectArchives,
  selectArchivesTotal,
  selectArchivesDomain,
  selectHasChanged,
  selectIsLoading
};
