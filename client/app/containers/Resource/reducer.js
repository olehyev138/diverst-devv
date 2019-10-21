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
  VALIDATE_FOLDER_PASSWORD_SUCCESS,
  GET_RESOURCES_SUCCESS,
  GET_RESOURCE_SUCCESS,
  RESOURCES_UNMOUNT,
  GET_FOLDERS_BEGIN,
  GET_RESOURCES_BEGIN
} from './constants';

export const initialState = {
  isLoading: true,
  folders: null,
  resources: null,
  foldersTotal: null,
  resourcesTotal: null,
  currentFolder: null,
  currentResource: null,
  valid: null,
};

/* eslint-disable default-case, no-param-reassign */
function resourcesReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_FOLDERS_BEGIN:
        draft.isLoading = true;
        break;
      case GET_FOLDERS_SUCCESS:
        draft.folders = action.payload.items;
        draft.foldersTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_FOLDER_SUCCESS:
        draft.currentFolder = action.payload.folder;
        draft.valid = !action.payload.folder.password_protected;
        draft.isLoading = false;
        break;
      case GET_RESOURCES_BEGIN:
        draft.isLoading = true;
        break;
      case GET_RESOURCES_SUCCESS:
        draft.resources = action.payload.items;
        draft.resourcesTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_RESOURCE_SUCCESS:
        draft.currentResource = action.payload.resource;
        draft.isLoading = false;
        break;
      case RESOURCES_UNMOUNT:
        return initialState;
      case FOLDERS_UNMOUNT:
        return initialState;
      case VALIDATE_FOLDER_PASSWORD_SUCCESS:
        draft.valid = true;
    }
  });
}

export default resourcesReducer;
