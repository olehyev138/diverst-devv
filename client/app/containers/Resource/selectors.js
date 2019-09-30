import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectResourcesDomain = state => state.resource || initialState;

const selectPaginatedFolders = () => createSelector(
  selectResourcesDomain,
  foldersState => foldersState.folders
);

const selectPaginatedSelectFolders = () => createSelector(
  selectResourcesDomain,
  foldersState => (
    Object
      .values(foldersState.folders)
      .map(folder => ({ value: folder.id, label: folder.name }))
  )
);

const selectFoldersTotal = () => createSelector(
  selectResourcesDomain,
  foldersState => foldersState.foldersTotal
);

const selectFolder = () => createSelector(
  selectResourcesDomain,
  foldersState => foldersState.currentFolder
);

const selectValid = () => createSelector(
  selectResourcesDomain,
  foldersState => foldersState.valid
);

const selectPaginatedResources = () => createSelector(
  selectResourcesDomain,
  resourcesState => resourcesState.resources
);

const selectResourcesTotal = () => createSelector(
  selectResourcesDomain,
  resourcesState => resourcesState.resourcesTotal
);

const selectResource = () => createSelector(
  selectResourcesDomain,
  resourcesState => resourcesState.currentResource
);

export {
  selectResourcesDomain,
  selectPaginatedFolders, selectPaginatedSelectFolders,
  selectFoldersTotal, selectFolder,
  selectValid,
  selectPaginatedResources,
  selectResourcesTotal, selectResource,
};
