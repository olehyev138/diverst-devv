import { createSelector } from 'reselect';
import { initialState } from './reducer';
import { selectResourcesDomain } from '../Resource/selectors';

const selectArchivesDomain = state => state.archives || initialState;

const selectArchives = () => createSelector(
  selectArchivesDomain,
  archiveState => archiveState.archives
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
  selectHasChanged
};
