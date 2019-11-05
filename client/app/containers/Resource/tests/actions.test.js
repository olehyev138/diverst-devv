/* Resource action tests */
import {
  GET_FOLDERS_BEGIN,
  GET_FOLDERS_SUCCESS,
  GET_FOLDERS_ERROR,
  CREATE_FOLDER_BEGIN,
  CREATE_FOLDER_SUCCESS,
  CREATE_FOLDER_ERROR,
  DELETE_FOLDER_BEGIN,
  DELETE_FOLDER_SUCCESS,
  DELETE_FOLDER_ERROR,
  VALIDATE_FOLDER_PASSWORD_BEGIN,
  VALIDATE_FOLDER_PASSWORD_SUCCESS,
  VALIDATE_FOLDER_PASSWORD_ERROR,
  GET_FOLDER_BEGIN,
  GET_FOLDER_SUCCESS,
  GET_FOLDER_ERROR,
  UPDATE_FOLDER_BEGIN,
  UPDATE_FOLDER_SUCCESS,
  UPDATE_FOLDER_ERROR,
  FOLDERS_UNMOUNT,
  GET_RESOURCES_BEGIN,
  GET_RESOURCES_SUCCESS,
  GET_RESOURCES_ERROR,
  CREATE_RESOURCE_BEGIN,
  CREATE_RESOURCE_SUCCESS,
  CREATE_RESOURCE_ERROR,
  DELETE_RESOURCE_BEGIN,
  DELETE_RESOURCE_SUCCESS,
  DELETE_RESOURCE_ERROR,
  GET_RESOURCE_BEGIN,
  GET_RESOURCE_SUCCESS,
  GET_RESOURCE_ERROR,
  UPDATE_RESOURCE_BEGIN,
  UPDATE_RESOURCE_SUCCESS,
  UPDATE_RESOURCE_ERROR,
  RESOURCES_UNMOUNT,
} from '../constants';

import {
  getFoldersBegin,
  getFoldersSuccess,
  getFoldersError,
  getFolderBegin,
  getFolderSuccess,
  getFolderError,
  createFolderBegin,
  createFolderSuccess,
  createFolderError,
  updateFolderBegin,
  updateFolderSuccess,
  updateFolderError,
  deleteFolderBegin,
  deleteFolderSuccess,
  deleteFolderError,
  validateFolderPasswordBegin,
  validateFolderPasswordSuccess,
  validateFolderPasswordError,
  foldersUnmount,
  getResourcesBegin,
  getResourcesSuccess,
  getResourcesError,
  getResourceBegin,
  getResourceSuccess,
  getResourceError,
  createResourceBegin,
  createResourceSuccess,
  createResourceError,
  updateResourceBegin,
  updateResourceSuccess,
  updateResourceError,
  deleteResourceBegin,
  deleteResourceSuccess,
  deleteResourceError,
  resourcesUnmount } from '../actions';

describe('actions', () => {
  it('has a type of GET_FOLDERS_BEGIN and sets a given payload', () => {
    const expected = {
      type: GET_FOLDERS_BEGIN,
      payload: { payload: 'payload' }
    };
    expect(getFoldersBegin({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of GET_FOLDERS_SUCCESS and sets a given payload', () => {
    const expected = {
      type: GET_FOLDERS_SUCCESS,
      payload: { payload: 'payload' }
    };
    expect(getFoldersSuccess({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of GET_FOLDERS_ERROR and sets a given payload', () => {
    const expected = {
      type: GET_FOLDERS_ERROR,
      payload: { payload: 'payload' }
    };
    expect(getFoldersError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of GET_FOLDER_BEGIN and sets a given payload', () => {
    const expected = {
      type: GET_FOLDER_BEGIN,
      payload: { payload: 'payload' }
    };
    expect(getFolderBegin({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of GET_FOLDER_SUCCESS and sets a given payload', () => {
    const expected = {
      type: GET_FOLDER_SUCCESS,
      payload: { payload: 'payload' }
    };
    expect(getFolderSuccess({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of GET_FOLDER_ERROR and sets a given payload', () => {
    const expected = {
      type: GET_FOLDER_ERROR,
      payload: { payload: 'payload' }
    };
    expect(getFolderError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of CREATE_FOLDER_BEGIN and sets a given payload', () => {
    const expected = {
      type: CREATE_FOLDER_BEGIN,
      payload: { payload: 'payload' }
    };
    expect(createFolderBegin({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of CREATE_FOLDER_SUCCESS and sets a given payload', () => {
    const expected = {
      type: CREATE_FOLDER_SUCCESS,
      payload: { payload: 'payload' }
    };
    expect(createFolderSuccess({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of CREATE_FOLDER_ERROR and sets a given payload', () => {
    const expected = {
      type: CREATE_FOLDER_ERROR,
      payload: { payload: 'payload' }
    };
    expect(createFolderError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of DELETE_FOLDER_BEGIN and sets a given payload', () => {
    const expected = {
      type: DELETE_FOLDER_BEGIN,
      payload: { payload: 'payload' }
    };
    expect(deleteFolderBegin ({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of DELETE_FOLDER_SUCCESS and sets a given payload', () => {
    const expected = {
      type: DELETE_FOLDER_SUCCESS,
      payload: { payload: 'payload' }
    };
    expect(deleteFolderSuccess ({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of DELETE_FOLDER_ERROR and sets a given payload', () => {
    const expected = {
      type: DELETE_FOLDER_ERROR,
      payload: { payload: 'payload' }
    };
    expect(deleteFolderError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of VALIDATE_FOLDER_PASSWORD_BEGIN and sets a given payload', () => {
    const expected = {
      type: VALIDATE_FOLDER_PASSWORD_BEGIN,
      payload: { payload: 'payload' }
    };
    expect(validateFolderPasswordBegin({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of VALIDATE_FOLDER_PASSWORD_SUCCESS and sets a given payload', () => {
    const expected = {
      type: VALIDATE_FOLDER_PASSWORD_SUCCESS,
      payload: { payload: 'payload' }
    };
    expect(validateFolderPasswordSuccess({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of VALIDATE_FOLDER_PASSWORD_ERROR and sets a given payload', () => {
    const expected = {
      type: VALIDATE_FOLDER_PASSWORD_ERROR,
      payload: { payload: 'payload' }
    };
    expect(validateFolderPasswordError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of UPDATE_FOLDER_BEGIN and sets a given payload', () => {
    const expected = {
      type: UPDATE_FOLDER_BEGIN,
      payload: { payload: 'payload' }
    };
    expect(updateFolderBegin({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of UPDATE_FOLDER_SUCCESS and sets a given payload', () => {
    const expected = {
      type: UPDATE_FOLDER_SUCCESS,
      payload: { payload: 'payload' }
    };
    expect(updateFolderSuccess({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of UPDATE_FOLDER_ERROR and sets a given payload', () => {
    const expected = {
      type: UPDATE_FOLDER_ERROR,
      payload: { payload: 'payload' }
    };
    expect(updateFolderError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of UPDATE_FOLDER_ERROR and sets a given payload', () => {
    const expected = {
      type: UPDATE_FOLDER_ERROR,
      payload: { payload: 'payload' }
    };
    expect(updateFolderError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of FOLDERS_UNMOUNT and sets a given payload', () => {
    const expected = {
      type: FOLDERS_UNMOUNT,
      payload: { payload: 'payload' }
    };
    expect(foldersUnmount({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of GET_RESOURCES_BEGIN and sets a given payload', () => {
    const expected = {
      type: GET_RESOURCES_BEGIN,
      payload: { payload: 'payload' }
    };
    expect(getResourcesBegin({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of GET_RESOURCES_SUCCESS and sets a given payload', () => {
    const expected = {
      type: GET_RESOURCES_SUCCESS,
      payload: { payload: 'payload' }
    };
    expect(getResourcesSuccess({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of GET_RESOURCES_ERROR and sets a given payload', () => {
    const expected = {
      type: GET_RESOURCES_ERROR,
      payload: { payload: 'payload' }
    };
    expect(getResourcesError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of CREATE_RESOURCE_BEGIN and sets a given payload', () => {
    const expected = {
      type: CREATE_RESOURCE_BEGIN,
      payload: { payload: 'payload' }
    };
    expect(createResourceBegin({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of CREATE_RESOURCE_SUCCESS and sets a given payload', () => {
    const expected = {
      type: CREATE_RESOURCE_SUCCESS,
      payload: { payload: 'payload' }
    };
    expect(createResourceSuccess({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of CREATE_RESOURCE_ERROR and sets a given payload', () => {
    const expected = {
      type: CREATE_RESOURCE_ERROR,
      payload: { payload: 'payload' }
    };
    expect(createResourceError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of DELETE_RESOURCE_BEGIN and sets a given payload', () => {
    const expected = {
      type: DELETE_RESOURCE_BEGIN,
      payload: { payload: 'payload' }
    };
    expect(deleteResourceBegin({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of DELETE_RESOURCE_SUCCESS and sets a given payload', () => {
    const expected = {
      type: DELETE_RESOURCE_SUCCESS,
      payload: { payload: 'payload' }
    };
    expect(deleteResourceSuccess({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of DELETE_RESOURCE_ERROR and sets a given payload', () => {
    const expected = {
      type: DELETE_RESOURCE_ERROR,
      payload: { payload: 'payload' }
    };
    expect(deleteResourceError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of GET_RESOURCE_BEGIN and sets a given payload', () => {
    const expected = {
      type: GET_RESOURCE_BEGIN,
      payload: { payload: 'payload' }
    };
    expect(getResourceBegin({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of GET_RESOURCE_SUCCESS and sets a given payload', () => {
    const expected = {
      type: GET_RESOURCE_SUCCESS,
      payload: { payload: 'payload' }
    };
    expect(getResourceSuccess({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of GET_RESOURCE_ERROR and sets a given payload', () => {
    const expected = {
      type: GET_RESOURCE_ERROR,
      payload: { payload: 'payload' }
    };
    expect(getResourceError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of UPDATE_RESOURCE_BEGIN and sets a given payload', () => {
    const expected = {
      type: UPDATE_RESOURCE_BEGIN,
      payload: { payload: 'payload' }
    };
    expect(updateResourceBegin({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of UPDATE_RESOURCE_SUCCESS and sets a given payload', () => {
    const expected = {
      type: UPDATE_RESOURCE_SUCCESS,
      payload: { payload: 'payload' }
    };
    expect(updateResourceSuccess({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of UPDATE_RESOURCE_ERROR and sets a given payload', () => {
    const expected = {
      type: UPDATE_RESOURCE_ERROR,
      payload: { payload: 'payload' }
    };
    expect(updateResourceError({ payload: 'payload' })).toEqual(expected);
  });

  it('has a type of RESOURCES_UNMOUNT and sets a given payload', () => {
    const expected = {
      type: RESOURCES_UNMOUNT,
      payload: { payload: 'payload' }
    };
    expect(resourcesUnmount({ payload: 'payload' })).toEqual(expected);
  });
});
