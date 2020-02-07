/*
 *
 * Resource selector tests
 *
 */
import {
  selectResourcesDomain,
  selectPaginatedFolders,
  selectPaginatedSelectFolders,
  selectFoldersTotal,
  selectFolder,
  selectFormFolder,
  selectValid,
  selectPaginatedResources,
  selectResourcesTotal,
  selectResource,
  selectFormResource,
  selectIsLoading,
  selectIsFormLoading,
  selectIsCommitting,
} from '../selectors';

describe('Resource selectors', () => {
  describe('selectResourcesDomain', () => {
    it('should select the resources domain', () => {
      const mockedState = {
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
      };
      const selected = selectResourcesDomain(mockedState);

      expect(selected).toEqual({
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
        valid: true, });
    });
  });

  describe('selectPaginatedFolders', () => {
    it('should select the paginated folders', () => {
      const mockedState = { folders: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedFolders().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectPaginatedSelectFolders', () => {
    it('should select the paginated select folders', () => {
      const mockedState = { folders: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedSelectFolders().resultFunc(mockedState);

      expect(selected).toEqual([{ value: 37, label: 'dummy' }]);
    });
  });

  describe('selectFoldersTotal', () => {
    it('should select the group total', () => {
      const mockedState = { foldersTotal: 84 };
      const selected = selectFoldersTotal().resultFunc(mockedState);

      expect(selected).toEqual(84);
    });
  });

  describe('selectFolder', () => {
    it('should select the current folder', () => {
      const mockedState = { currentFolder: { name: 'dummy-folder-02' } };
      const selected = selectFolder().resultFunc(mockedState);

      expect(selected).toEqual({ name: 'dummy-folder-02' });
    });
  });

  describe('selectFormFolder', () => {
    it('should determine if the current folder has a parent and return the current folder', () => {
      const mockedState = { currentFolder: { name: 'dummy-folder-02' } };
      const selected = selectFormFolder().resultFunc(mockedState);

      expect(selected).toEqual({ name: 'dummy-folder-02' });
    });
  });

  describe('selectValid', () => {
    it('should select folderState.valid', () => {
      const mockedState = { valid: false };
      const selected = selectValid().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectResource', () => {
    it('should select the current resource', () => {
      const mockedState = { currentResource: { name: 'dummy-resource-02' } };
      const selected = selectResource().resultFunc(mockedState);

      expect(selected).toEqual({ name: 'dummy-resource-02' });
    });
  });

  describe('selectPaginatedResources', () => {
    it('should select paginated resources', () => {
      const mockedState = { resources: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedResources().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectResourcesTotal', () => {
    it('should select the resources total', () => {
      const mockedState = { resourcesTotal: 84 };
      const selected = selectResourcesTotal().resultFunc(mockedState);

      expect(selected).toEqual(84);
    });
  });

  describe('selectFormResource', () => {
    it('should determine if the current resource has a folder, give the folder info, and return the current resource', () => {
      const mockedState = { currentResource: { name: 'dummy-resource-02' } };
      const selected = selectFormResource().resultFunc(mockedState);

      expect(selected).toEqual({ name: 'dummy-resource-02' });
    });
  });

  describe('selectIsLoading', () => {
    it('should select isLoading from state', () => {
      const mockedState = { isLoading: false };
      const selected = selectIsLoading().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectIsFormLoading', () => {
    it('should select isFormLoading from state', () => {
      const mockedState = { isFormLoading: false };
      const selected = selectIsFormLoading().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectIsCommitting', () => {
    it('should select isFormLoading from state', () => {
      const mockedState = { isFormLoading: false };
      const selected = selectIsFormLoading().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });
});
