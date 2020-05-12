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
  GET_RESOURCES_BEGIN,
  CREATE_FOLDER_BEGIN,
  CREATE_FOLDER_SUCCESS,
  CREATE_FOLDER_ERROR,
  CREATE_RESOURCE_BEGIN,
  CREATE_RESOURCE_SUCCESS,
  CREATE_RESOURCE_ERROR,
  UPDATE_FOLDER_BEGIN,
  UPDATE_FOLDER_SUCCESS,
  UPDATE_FOLDER_ERROR,
  UPDATE_RESOURCE_BEGIN,
  UPDATE_RESOURCE_SUCCESS,
  UPDATE_RESOURCE_ERROR,
  GET_RESOURCE_BEGIN,
  GET_FOLDER_BEGIN,
  GET_FOLDER_ERROR,
  GET_FOLDERS_ERROR,
  GET_RESOURCE_ERROR,
  GET_RESOURCES_ERROR,
  ARCHIVE_RESOURCE_BEGIN,
  ARCHIVE_RESOURCE_SUCCESS,
  ARCHIVE_RESOURCE_ERROR,
  GET_FILE_DATA_BEGIN,
  GET_FILE_DATA_SUCCESS,
  GET_FILE_DATA_ERROR,
} from './constants';

export const initialState = {
  isCommitting: false,
  isResourceLoading: true,
  isResourceFormLoading: true,
  isFolderLoading: true,
  isFolderFormLoading: true,
  folders: null,
  resources: null,
  foldersTotal: null,
  resourcesTotal: null,
  currentFolder: null,
  currentResource: null,
  hasChanged: false,
  valid: true,
  isDownloadingFileData: false,
  fileData: {
    data: null,
    contentType: null,
  },
};

/* eslint-disable default-case, no-param-reassign */
function resourcesReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_FOLDER_BEGIN:
        draft.isFolderFormLoading = true;
        break;
      case GET_FOLDER_SUCCESS:
        draft.currentFolder = action.payload.folder;
        draft.valid = !action.payload.folder.password_protected;
        draft.isFolderFormLoading = false;
        break;
      case GET_FOLDERS_BEGIN:
        draft.isFolderLoading = true;
        break;
      case GET_FOLDERS_SUCCESS:
        draft.folders = action.payload.items;
        draft.foldersTotal = action.payload.total;
        draft.isFolderLoading = false;
        break;
      case GET_RESOURCE_BEGIN:
        draft.isResourceFormLoading = true;
        break;
      case GET_RESOURCE_SUCCESS:
        draft.currentResource = action.payload.resource;
        draft.isResourceFormLoading = false;
        break;
      case GET_RESOURCES_BEGIN:
        draft.isResourceLoading = true;
        break;
      case GET_RESOURCES_SUCCESS:
        draft.resources = action.payload.items;
        draft.resourcesTotal = action.payload.total;
        draft.isResourceLoading = false;
        break;
      case GET_FOLDER_ERROR:
        draft.isFolderFormLoading = false;
        break;
      case GET_RESOURCE_ERROR:
        draft.isResourceFormLoading = false;
        break;
      case GET_FOLDERS_ERROR:
        draft.isFolderLoading = false;
        break;
      case GET_RESOURCES_ERROR:
        draft.isResourceLoading = false;
        break;
      case CREATE_FOLDER_BEGIN:
      case CREATE_RESOURCE_BEGIN:
      case UPDATE_FOLDER_BEGIN:
      case UPDATE_RESOURCE_BEGIN:
        draft.isCommitting = true;
        break;
      case ARCHIVE_RESOURCE_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;
      case CREATE_FOLDER_SUCCESS:
      case CREATE_FOLDER_ERROR:
      case CREATE_RESOURCE_SUCCESS:
      case CREATE_RESOURCE_ERROR:
      case UPDATE_FOLDER_SUCCESS:
      case UPDATE_FOLDER_ERROR:
      case UPDATE_RESOURCE_SUCCESS:
      case UPDATE_RESOURCE_ERROR:
      case ARCHIVE_RESOURCE_ERROR:
        draft.isCommitting = false;
        break;
      case RESOURCES_UNMOUNT:
        return initialState;
      case FOLDERS_UNMOUNT:
        return initialState;
      case VALIDATE_FOLDER_PASSWORD_SUCCESS:
        draft.valid = true;
        break;
      case ARCHIVE_RESOURCE_SUCCESS:
        draft.hasChanged = true;
        draft.isCommitting = false;
        break;
      case GET_FILE_DATA_BEGIN:
        draft.isDownloadingFileData = true;
        draft.fileData.data = null;
        draft.fileData.contentType = null;
        break;
      case GET_FILE_DATA_SUCCESS:
        draft.isDownloadingFileData = false;
        draft.fileData.data = action.payload.data;
        draft.fileData.contentType = action.payload.contentType;
        break;
      case GET_FILE_DATA_ERROR:
        draft.isDownloadingFileData = false;
        break;
    }
  });
}

export default resourcesReducer;
