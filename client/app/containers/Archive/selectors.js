import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectArchivesDomain = state => state.archives || initialState;

const selectArchives = () => createSelector(
  selectArchivesDomain,
  archiveState => archiveState.archives
);

const selectArchivesTotal = () => createSelector(
  selectArchivesDomain,
  archiveState => archiveState.archivesTotal
);

export {
  selectArchives,
  selectArchivesTotal,
  selectArchivesDomain
};
