import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_FOLDERS_BEGIN, GET_FOLDER_BEGIN,
  CREATE_FOLDER_BEGIN, UPDATE_FOLDER_BEGIN,
  DELETE_FOLDER_BEGIN,
  GET_RESOURCES_BEGIN, GET_RESOURCE_BEGIN,
  CREATE_RESOURCE_BEGIN, UPDATE_RESOURCE_BEGIN,
  DELETE_RESOURCE_BEGIN,
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
} from 'containers/Resource/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getFolders(action) {
  try {
    const response = yield call(api.folders.all.bind(api.folders), action.payload);

    yield (put(getFoldersSuccess(response.data.page)));
  } catch (err) {
    yield put(getFoldersError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to load folders',
      options: { variant: 'warning' }
    }));
  }
}

export function* getFolder(action) {
  try {
    const response = yield call(api.folders.get.bind(api.folders), action.payload.id);
    yield put(getFolderSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getFolderError(err));
    yield put(showSnackbar({
      message: 'Failed to get folder',
      options: { variant: 'warning' }
    }));
  }
}

export function* createFolder(action) {
  try {
    const payload = { folder: action.payload };
    const response = yield call(api.folders.create.bind(api.folders), payload);

    yield put(push(ROUTES.group.resources.folders.index.path(payload.folder.group_id)));
    yield put(showSnackbar({
      message: 'Folder created',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(createFolderError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to create folder',
      options: { variant: 'warning' }
    }));
  }
}

export function* updateFolder(action) {
  try {
    const payload = { folder: action.payload };
    const response = yield call(api.folders.update.bind(api.folders), payload.folder.id, payload);

    yield put(push(ROUTES.group.resources.folders.index.path(payload.folder.group_id)));
    yield put(showSnackbar({
      message: 'Folder updated',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateFolderError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to update folder',
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteFolder(action) {
  try {
    yield call(api.folders.destroy.bind(api.folders), action.payload.id);
    yield put(push(ROUTES.group.resources.folders.index.path(action.payload.folder.group_id)));
    yield put(showSnackbar({
      message: 'Folder deleted',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(deleteFolderError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to delete folder',
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

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to load resources',
      options: { variant: 'warning' }
    }));
  }
}

export function* getResource(action) {
  try {
    const response = yield call(api.resources.get.bind(api.resources), action.payload.id);
    yield put(getResourceSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getResourceError(err));
    yield put(showSnackbar({
      message: 'Failed to get resource',
      options: { variant: 'warning' }
    }));
  }
}

export function* createResource(action) {
  try {
    const payload = { resource: action.payload };

    const response = yield call(api.resources.create.bind(api.resources), payload);

    yield put(push(ROUTES.group.resources.index.path(payload.resource.group_id)));
    yield put(showSnackbar({
      message: 'Resource created',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(createResourceError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to create resource',
      options: { variant: 'warning' }
    }));
  }
}

export function* updateResource(action) {
  try {
    const payload = { resource: action.payload };
    const response = yield call(api.resources.update.bind(api.resources), payload.resource.id, payload);

    yield put(push(ROUTES.group.resources.index.path(payload.resource.owner_group_id)));
    yield put(showSnackbar({
      message: 'Resource updated',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateResourceError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to update resource',
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteResource(action) {
  try {
    yield call(api.resources.destroy.bind(api.resources), action.payload.id);
    yield put(push(ROUTES.group.resources.index.path(action.payload.group_id)));
    yield put(showSnackbar({
      message: 'Resource deleted',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(deleteResourceError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to delete resource',
      options: { variant: 'warning' }
    }));
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
}
