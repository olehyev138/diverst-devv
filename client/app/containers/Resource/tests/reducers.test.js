/*
 *
 * Resource reducer tests
 *
 */
import resourcesReducer from '../reducer';
import produce from 'immer';
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
  validateFolderPasswordSuccess,
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
  resourcesUnmount, getFileDataBegin, getFileDataSuccess, getFileDataError
} from '../actions';

describe('resourcesReducer', () => {
  let state;

  beforeEach(() => {
    state = {
      isCommitting: false,
      isLoading: true,
      isFormLoading: true,
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
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(resourcesReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getFoldersBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFormLoading = true;
    });

    expect(resourcesReducer(state, getFoldersBegin(true))).toEqual(expected);
  });

  it('handles the getFoldersSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.folders = [{ id: 4 }, { id: 5 }, { id: 6 }];
      draft.foldersTotal = 3;
      draft.isLoading = false;
    });
    expect(
      resourcesReducer(
        state,
        getFoldersSuccess({
          items: [{ id: 4 }, { id: 5 }, { id: 6 }],
          total: 3,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getFoldersError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isLoading = false;
    });
    expect(resourcesReducer(state, getFoldersError('error'))).toEqual(expected);
  });

  it('handles the getFolderBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFormLoading = true;
    });
    expect(resourcesReducer(state, getFolderBegin(true))).toEqual(expected);
  });

  it('handles the getFolderSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentFolder = { id: 4 };
      draft.valid = true;
      draft.isFormLoading = false;
    });
    expect(
      resourcesReducer(
        state,
        getFolderSuccess({
          folder: { id: 4 }
        })
      )
    ).toEqual(expected);
  });

  it('handles the getFolderError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFormLoading = false;
      draft.isLoading = true;
    });
    expect(resourcesReducer(state, getFolderError('error'))).toEqual(expected);
  });

  it('handles the createFolderBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = true;
    });
    expect(resourcesReducer(state, createFolderBegin(true))).toEqual(expected);
  });

  it('handles the createFolderSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });
    expect(resourcesReducer(state, createFolderSuccess(false))).toEqual(expected);
  });

  it('handles the createFolderError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });
    expect(resourcesReducer(state, createFolderError('error'))).toEqual(expected);
  });

  it('handles the updateFolderBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = true;
    });
    expect(resourcesReducer(state, updateFolderBegin(true))).toEqual(expected);
  });

  it('handles the updateFolderSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });
    expect(resourcesReducer(state, updateFolderSuccess(false))).toEqual(expected);
  });

  it('handles the updateFolderError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });
    expect(resourcesReducer(state, updateFolderError('error'))).toEqual(expected);
  });

  it('handles the validateFolderPasswordSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.valid = true;
    });
    expect(resourcesReducer(state, validateFolderPasswordSuccess(true))).toEqual(expected);
  });

  it('handles the foldersUnmount action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
      draft.isLoading = true;
      draft.isFormLoading = true;
      draft.folders = null;
      draft.resources = null;
      draft.foldersTotal = null;
      draft.resourcesTotal = null;
      draft.currentFolder = null;
      draft.currentResource = null;
      draft.valid = true;
      draft.isDownloadingFileData = false;
      draft.fileData = {
        data: null,
        contentType: null,
      };
    });
    expect(resourcesReducer(
      state,
      foldersUnmount({
        isCommitting: false,
        isLoading: true,
        isFormLoading: true,
        folders: null,
        resources: null,
        foldersTotal: null,
        resourcesTotal: null,
        currentFolder: null,
        currentResource: null,
        valid: true,
        isDownloadingFileData: false,
        fileData: {
          data: null,
          contentType: null,
        },
      })
    )).toEqual(expected);
  });

  it('handles the getResourcesBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isLoading = true;
    });
    expect(resourcesReducer(state, getResourcesBegin(true))).toEqual(expected);
  });

  it('handles the getResourcesSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.resources = [{ item1: 'item 1' }, { item2: 'item 2' }];
      draft.resourcesTotal = 3;
      draft.isLoading = false;
    });
    expect(resourcesReducer(
      state,
      getResourcesSuccess({
        items: [{ item1: 'item 1' }, { item2: 'item 2' }],
        total: 3,
        isLoading: false,
      })
    )).toEqual(expected);
  });

  it('handles the getResourcesError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isLoading = false;
    });
    expect(resourcesReducer(state, getResourcesError('error'))).toEqual(expected);
  });

  it('handles the getResourceBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFormLoading = true;
    });
    expect(resourcesReducer(state, getResourceBegin(true))).toEqual(expected);
  });

  it('handles the getResourceSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentResource = { resource_id: 1 };
      draft.isFormLoading = false;
    });
    expect(resourcesReducer(state, getResourceSuccess({ resource: { resource_id: 1 } }))).toEqual(expected);
  });

  it('handles the getResourceError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFormLoading = false;
    });
    expect(resourcesReducer(state, getResourceError('error'))).toEqual(expected);
  });

  it('handles the createResourceBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = true;
    });
    expect(resourcesReducer(state, createResourceBegin(true))).toEqual(expected);
  });

  it('handles the createResourceSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });
    expect(resourcesReducer(state, createResourceSuccess({
      isCommitting: false,
    }))).toEqual(expected);
  });

  it('handles the createResourceError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });
    expect(resourcesReducer(state, createResourceError('error'))).toEqual(expected);
  });

  it('handles the updateResourceBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = true;
    });
    expect(resourcesReducer(state, updateResourceBegin({ isCommitting: true }))).toEqual(expected);
  });

  it('handles the updateResourceSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });
    expect(resourcesReducer(state, updateResourceSuccess({
      isCommitting: false,
    }))).toEqual(expected);
  });

  it('handles the updateResourceError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });
    expect(resourcesReducer(state, updateResourceError('error'))).toEqual(expected);
  });

  it('handles the getFileDataBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isDownloadingFileData = true;
      draft.fileData.data = null;
      draft.fileData.contentType = null;
    });
    expect(resourcesReducer(state, getFileDataBegin())).toEqual(expected);
  });

  it('handles the getFileDataSuccess action correctly', () => {
    const data = {};
    const contentType = 'image/webp';

    const expected = produce(state, (draft) => {
      draft.isDownloadingFileData = false;
      draft.fileData.data = data;
      draft.fileData.contentType = contentType;
    });
    expect(resourcesReducer(state, getFileDataSuccess({
      data,
      contentType,
    }))).toEqual(expected);
  });

  it('handles the getFileDataError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isDownloadingFileData = false;
    });
    expect(resourcesReducer(state, getFileDataError('error'))).toEqual(expected);
  });

  it('handles the resourcesUnmount action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
      draft.isLoading = true;
      draft.isFormLoading = true;
      draft.folders = null;
      draft.resources = null;
      draft.foldersTotal = null;
      draft.resourcesTotal = null;
      draft.currentFolder = null;
      draft.currentResource = null;
      draft.valid = true;
      draft.isDownloadingFileData = false;
      draft.fileData = {
        data: null,
        contentType: null,
      };
    });
    expect(resourcesReducer(
      state,
      resourcesUnmount({
        isCommitting: false,
        isLoading: true,
        isFormLoading: true,
        folders: null,
        resources: null,
        foldersTotal: null,
        resourcesTotal: null,
        currentFolder: null,
        currentResource: null,
        valid: true,
        fileData: {
          data: null,
          contentType: null,
        },
      })
    )).toEqual(expected);
  });
});
