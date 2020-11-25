import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_FOLDERS_BEGIN, GET_FOLDER_BEGIN,
  CREATE_FOLDER_BEGIN, UPDATE_FOLDER_BEGIN,
  DELETE_FOLDER_BEGIN,
  GET_RESOURCES_BEGIN, GET_RESOURCE_BEGIN,
  CREATE_RESOURCE_BEGIN, UPDATE_RESOURCE_BEGIN,
  DELETE_RESOURCE_BEGIN,
  VALIDATE_FOLDER_PASSWORD_BEGIN,
  ARCHIVE_RESOURCE_BEGIN, GET_FILE_DATA_BEGIN
} from 'containers/Resource/constants';

import {
  getFoldersSuccess, getFoldersError,
  getFolderSuccess, getFolderError,
  createFolderSuccess, createFolderError,
  updateFolderSuccess, updateFolderError,
  deleteFolderError,
  getResourcesSuccess, getResourcesError,
  getResourceSuccess, getResourceError,
  createResourceSuccess, createResourceError,
  updateResourceSuccess, updateResourceError,
  deleteResourceError,
  validateFolderPasswordSuccess, validateFolderPasswordError, deleteFolderSuccess, deleteResourceSuccess,
  archiveResourceError, archiveResourceSuccess,
  getFileDataSuccess, getFileDataError,
} from 'containers/Resource/actions';

import {
  getParentPage,
  getFolderShowPath,
} from 'utils/resourceHelpers';

export function* getFolders(action) {
  try {
    const response = yield call(api.folders.all.bind(api.folders), action.payload);

    yield (put(getFoldersSuccess(response.data.page)));
  } catch (err) {
    yield put(getFoldersError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.folders,
      options: { variant: 'warning' }
    }));
  }
}

export function* getFolder(action) {
  try {
    const response = yield call(api.folders.get.bind(api.folders), action.payload.id);
    yield put(getFolderSuccess(response.data));
  } catch (err) {
    yield put(getFolderError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.folder,
      options: { variant: 'warning' }
    }));
  }
}

export function* createFolder(action) {
  try {
    const payload = { folder: action.payload, group_id: action.payload.group_id };
    const response = yield call(api.folders.create.bind(api.folders), payload);

    yield put(createFolderSuccess());
    yield put(push(getParentPage(response.data.folder)));
    yield put(showSnackbar({
      message: messages.snackbars.success.create_folder,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(createFolderError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.create_folder,
      options: { variant: 'warning' }
    }));
  }
}

export function* updateFolder(action) {
  try {
    const payload = { folder: action.payload };
    const response = yield call(api.folders.update.bind(api.folders), payload.folder.id, payload);

    yield put(updateFolderSuccess());
    yield put(push(getParentPage(response.data.folder)));
    yield put(showSnackbar({
      message: messages.snackbars.success.update_folder,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateFolderError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.update_folder,
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteFolder(action) {
  try {
    yield call(api.folders.destroy.bind(api.folders), action.payload.id);

    yield put(deleteFolderSuccess());
    yield put(push(getParentPage(action.payload.folder)));
    yield put(showSnackbar({
      message: messages.snackbars.success.delete_folder,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(deleteFolderError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.delete_folder,
      options: { variant: 'warning' }
    }));
  }
}

export function* getResources(action) {
  try {
    const response = yield call(api.resources.all.bind(api.resources), action.payload);

    yield (put(getResourcesSuccess(response.data.page)));
  } catch (err) {
    yield put(getResourcesError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.resources,
      options: { variant: 'warning' }
    }));
  }
}

export function* getResource(action) {
  try {
    const response = yield call(api.resources.get.bind(api.resources), action.payload.id);
    yield put(getResourceSuccess(response.data));
  } catch (err) {
    yield put(getResourceError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.resource,
      options: { variant: 'warning' }
    }));
  }
}

export function* createResource(action) {
  try {
    const payload = { resource: action.payload, group_id: action.payload.group_id };
    const response = yield call(api.resources.create.bind(api.resources), payload);

    yield put(createResourceSuccess());
    yield put(push(getFolderShowPath(response.data.resource.folder)));
    yield put(showSnackbar({
      message: messages.snackbars.success.create_resource,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(createResourceError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.create_resource,
      options: { variant: 'warning' }
    }));
  }
}

export function* updateResource(action) {
  try {
    const payload = { resource: action.payload };
    const response = yield call(api.resources.update.bind(api.resources), payload.resource.id, payload);

    yield put(updateResourceSuccess());
    yield put(push(getFolderShowPath(response.data.resource.folder)));
    yield put(showSnackbar({
      message: messages.snackbars.success.update_resource,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateResourceError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.update_resource,
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteResource(action) {
  try {
    yield call(api.resources.destroy.bind(api.resources), action.payload.id);
    // TODO check for group vs enterprise

    yield put(deleteResourceSuccess());
    yield put(push(getFolderShowPath(action.payload.folder)));
    yield put(showSnackbar({
      message: messages.snackbars.success.delete_resource,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(deleteResourceError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.delete_resource,
      options: { variant: 'warning' }
    }));
  }
}

export function* archiveResource(action) {
  try {
    const payload = { resource: action.payload };
    const response = yield call(api.resources.archive.bind(api.resources), payload.resource.id, payload);
    yield put(archiveResourceSuccess());
    yield put(showSnackbar({
      message: messages.snackbars.success.archive,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(archiveResourceError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.archive,
      options: { variant: 'warning' }
    }));
  }
}

export function* validateFolderPassword(action) {
  try {
    const response = yield call(api.folders.validatePassword.bind(api.folders), action.payload);
    yield put(validateFolderPasswordSuccess(response.data));
  } catch (err) {
    yield put(validateFolderPasswordError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.password,
      options: { variant: 'warning' }
    }));
  }
}

export function* getResourceFileData(action) {
  try {
    const response = yield call(api.resources.getFileData.bind(api.resources), action.payload);

    yield put(getFileDataSuccess({ data: response.data, contentType: response.headers['content-type'] }));
  } catch (err) {
    yield put(getFileDataError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.file_data, options: { variant: 'warning' } }));
  }
}

export default function* foldersSaga() {
  yield takeLatest(GET_FOLDERS_BEGIN, getFolders);
  yield takeLatest(GET_FOLDER_BEGIN, getFolder);
  yield takeLatest(CREATE_FOLDER_BEGIN, createFolder);
  yield takeLatest(UPDATE_FOLDER_BEGIN, updateFolder);
  yield takeLatest(DELETE_FOLDER_BEGIN, deleteFolder);
  yield takeLatest(GET_RESOURCES_BEGIN, getResources);
  yield takeLatest(GET_RESOURCE_BEGIN, getResource);
  yield takeLatest(CREATE_RESOURCE_BEGIN, createResource);
  yield takeLatest(UPDATE_RESOURCE_BEGIN, updateResource);
  yield takeLatest(DELETE_RESOURCE_BEGIN, deleteResource);
  yield takeLatest(VALIDATE_FOLDER_PASSWORD_BEGIN, validateFolderPassword);
  yield takeLatest(ARCHIVE_RESOURCE_BEGIN, archiveResource);
  yield takeLatest(GET_FILE_DATA_BEGIN, getResourceFileData);
}
