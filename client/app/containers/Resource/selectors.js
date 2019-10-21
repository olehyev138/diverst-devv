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
      .values(foldersState.folders || [])
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

const selectFormFolder = () => createSelector(
  selectResourcesDomain,
  (foldersState) => {
    const folder = Object.assign({}, foldersState.currentFolder);
    if (folder.parent)
      folder.parent = { value: folder.parent.id, label: folder.parent.name };
    return folder;
  }
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

const selectFormResource = () => createSelector(
  selectResourcesDomain,
  (resourcesState) => {
    const resource = Object.assign({}, resourcesState.currentResource);
    if (resource.folder)
      resource.folder = { value: resource.folder.id, label: resource.folder.name };
    return resource;
  }
);

const selectIsLoading = () => createSelector(
  selectResourcesDomain,
  resourcesState => resourcesState.isLoading
);

export {
  selectResourcesDomain,
  selectPaginatedFolders, selectPaginatedSelectFolders,
  selectFoldersTotal,
  selectFolder, selectFormFolder,
  selectValid, selectIsLoading,
  selectPaginatedResources,
  selectResourcesTotal,
  selectResource, selectFormResource
};
