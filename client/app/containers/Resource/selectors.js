import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectFoldersDomain = state => state.resource || initialState;

const selectPaginatedFolders = () => createSelector(
  selectFoldersDomain,
  foldersState => foldersState.folders
);

const selectFoldersTotal = () => createSelector(
  selectFoldersDomain,
  foldersState => foldersState.foldersTotal
);

const selectFolder = () => createSelector(
  selectFoldersDomain,
  foldersState => foldersState.currentFolder
);

export { selectFoldersDomain, selectPaginatedFolders, selectFoldersTotal, selectFolder };
