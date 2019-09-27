import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectFoldersDomain = state => state.resource || initialState;

const selectPaginatedFolders = () => createSelector(
  selectFoldersDomain,
  foldersState => foldersState.folders
);

const selectPaginatedSelectFolders = () => createSelector(
  selectFoldersDomain,
  foldersState => (
    Object
      .values(foldersState.folders)
      .map(folder => ({ value: folder.id, label: folder.name }))
  )
);

const selectFoldersTotal = () => createSelector(
  selectFoldersDomain,
  foldersState => foldersState.foldersTotal
);

const selectFolder = () => createSelector(
  selectFoldersDomain,
  foldersState => foldersState.currentFolder
);

const selectValid = () => createSelector(
  selectFoldersDomain,
  foldersState => foldersState.valid
);

export {
  selectFoldersDomain, selectPaginatedFolders, selectPaginatedSelectFolders,
  selectFoldersTotal, selectFolder, selectValid,
};
