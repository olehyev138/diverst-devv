/*
 *
 * Folder reducer
 *
 */
import produce from 'immer';
import {
  GET_FOLDERS_SUCCESS,
  FOLDERS_UNMOUNT,
  GET_FOLDER_SUCCESS,
  GET_RESOURCES_SUCCESS,
  GET_RESOURCE_SUCCESS, RESOURCES_UNMOUNT
} from './constants';

export const initialState = {
  folders: [],
  resources: [],
  foldersTotal: null,
  resourcesTotal: null,
  currentFolder: null,
  currentResource: null
};

/* eslint-disable default-case, no-param-reassign */
function foldersReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_FOLDERS_SUCCESS:
        draft.folders = action.payload.items;
        draft.foldersTotal = action.payload.total;
        break;
      case GET_FOLDER_SUCCESS:
        draft.currentFolder = action.payload.folder;
        break;
      case GET_RESOURCES_SUCCESS:
        draft.resources = action.payload.items;
        draft.resourcesTotal = action.payload.total;
        break;
      case GET_RESOURCE_SUCCESS:
        draft.currentResouce = action.payload.resource;
        break;
      case RESOURCES_UNMOUNT:
        return initialState;
    }
  });
}

export default foldersReducer;
