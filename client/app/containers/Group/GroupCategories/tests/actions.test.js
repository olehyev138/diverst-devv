import {
  GET_GROUP_CATEGORY_BEGIN,
  GET_GROUP_CATEGORY_SUCCESS,
  GET_GROUP_CATEGORY_ERROR,
  GET_GROUP_CATEGORIES_BEGIN,
  GET_GROUP_CATEGORIES_SUCCESS,
  GET_GROUP_CATEGORIES_ERROR,
  CREATE_GROUP_CATEGORIES_BEGIN,
  CREATE_GROUP_CATEGORIES_SUCCESS,
  CREATE_GROUP_CATEGORIES_ERROR,
  UPDATE_GROUP_CATEGORIES_BEGIN,
  UPDATE_GROUP_CATEGORIES_SUCCESS,
  UPDATE_GROUP_CATEGORIES_ERROR,
  DELETE_GROUP_CATEGORIES_BEGIN,
  DELETE_GROUP_CATEGORIES_SUCCESS,
  DELETE_GROUP_CATEGORIES_ERROR,
  ADD_GROUP_CATEGORIES_BEGIN,
  ADD_GROUP_CATEGORIES_ERROR,
  ADD_GROUP_CATEGORIES_SUCCESS,
  UPDATE_GROUP_CATEGORY_TYPE_BEGIN,
  UPDATE_GROUP_CATEGORY_TYPE_ERROR,
  UPDATE_GROUP_CATEGORY_TYPE_SUCCESS,
  CATEGORIES_UNMOUNT,
} from '../constants';

import {
  getGroupCategoryBegin,
  getGroupCategoryError,
  getGroupCategorySuccess,
  getGroupCategoriesBegin,
  getGroupCategoriesError,
  getGroupCategoriesSuccess,
  createGroupCategoriesBegin,
  createGroupCategoriesError,
  createGroupCategoriesSuccess,
  updateGroupCategoriesBegin,
  updateGroupCategoriesError,
  updateGroupCategoriesSuccess,
  deleteGroupCategoriesBegin,
  deleteGroupCategoriesError,
  deleteGroupCategoriesSuccess,
  updateGroupCategoryTypeError,
  updateGroupCategoryTypeBegin,
  updateGroupCategoryTypeSuccess,
  addGroupCategoriesBegin,
  addGroupCategoriesError,
  addGroupCategoriesSuccess,
  categoriesUnmount
} from '../actions';

describe('groupCategory actions', () => {
  describe('getGroupCategoryBegin', () => {
    it('has a type of GET_GROUP_CATEGORY_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_CATEGORY_BEGIN,
        payload: { value: 118 }
      };

      expect(getGroupCategoryBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGroupCategorySuccess', () => {
    it('has a type of GET_GROUP_CATEGORY_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_CATEGORY_SUCCESS,
        payload: { value: 865 }
      };

      expect(getGroupCategorySuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getGroupCategoryError', () => {
    it('has a type of GET_GROUP_CATEGORY_ERROR and sets a given error', () => {
      const expected = {
        type: GET_GROUP_CATEGORY_ERROR,
        error: { value: 709 }
      };

      expect(getGroupCategoryError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getGroupCategoriesBegin', () => {
    it('has a type of GET_GROUP_CATEGORIES_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_CATEGORIES_BEGIN,
        payload: { value: 118 }
      };

      expect(getGroupCategoriesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGroupCategoriesSuccess', () => {
    it('has a type of GET_GROUP_CATEGORIES_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_CATEGORIES_SUCCESS,
        payload: { value: 118 }
      };

      expect(getGroupCategoriesSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGroupCategoriesError', () => {
    it('has a type of GET_GROUP_CATEGORIES_ERROR and sets a given error', () => {
      const expected = {
        type: GET_GROUP_CATEGORIES_ERROR,
        error: { value: 709 }
      };

      expect(getGroupCategoriesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createGroupCategoryBegin', () => {
    it('has a type of CREATE_GROUP_CATEGORY_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_GROUP_CATEGORIES_BEGIN,
        payload: { value: 118 }
      };

      expect(createGroupCategoriesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createGroupCategorySuccess', () => {
    it('has a type of CREATE_GROUP_CATEGORY_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_GROUP_CATEGORIES_SUCCESS,
        payload: { value: 118 }
      };

      expect(createGroupCategoriesSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createGroupCategoryError', () => {
    it('has a type of CREATE_GROUP_CATEGORY_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_GROUP_CATEGORIES_ERROR,
        error: { value: 709 }
      };

      expect(createGroupCategoriesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateGroupCategoryBegin', () => {
    it('has a type of UPDATE_GROUP_CATEGORY_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_GROUP_CATEGORIES_BEGIN,
        payload: { value: 118 }
      };

      expect(updateGroupCategoriesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateGroupCategorySuccess', () => {
    it('has a type of UPDATE_GROUP_CATEGORY_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_GROUP_CATEGORIES_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateGroupCategoriesSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateGroupCategoryError', () => {
    it('has a type of UPDATE_GROUP_CATEGORY_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_GROUP_CATEGORIES_ERROR,
        error: { value: 709 }
      };

      expect(updateGroupCategoriesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('addGroupCategoryBegin', () => {
    it('has a type of ADD_GROUP_CATEGORY_BEGIN and sets a given payload', () => {
      const expected = {
        type: ADD_GROUP_CATEGORIES_BEGIN,
        payload: { value: 118 }
      };

      expect(addGroupCategoriesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('addGroupCategorySuccess', () => {
    it('has a type of ADD_GROUP_CATEGORY_SUCCESS and sets a given payload', () => {
      const expected = {
        type: ADD_GROUP_CATEGORIES_SUCCESS,
        payload: { value: 118 }
      };

      expect(addGroupCategoriesSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('addGroupCategoryError', () => {
    it('has a type of ADD_GROUP_CATEGORY_ERROR and sets a given error', () => {
      const expected = {
        type: ADD_GROUP_CATEGORIES_ERROR,
        error: { value: 709 }
      };

      expect(addGroupCategoriesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('addGroupCategoryBegin', () => {
    it('has a type of ADD_GROUP_CATEGORY_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_GROUP_CATEGORY_TYPE_BEGIN,
        payload: { value: 118 }
      };

      expect(updateGroupCategoryTypeBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('addGroupCategorySuccess', () => {
    it('has a type of ADD_GROUP_CATEGORY_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_GROUP_CATEGORY_TYPE_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateGroupCategoryTypeSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('addGroupCategoryError', () => {
    it('has a type of ADD_GROUP_CATEGORY_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_GROUP_CATEGORY_TYPE_ERROR,
        error: { value: 709 }
      };

      expect(updateGroupCategoryTypeError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deleteGroupCategoryBegin', () => {
    it('has a type of DELETE_GROUP_CATEGORY_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_GROUP_CATEGORIES_BEGIN,
        payload: { value: 118 }
      };

      expect(deleteGroupCategoriesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteGroupCategorySuccess', () => {
    it('has a type of DELETE_GROUP_CATEGORY_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_GROUP_CATEGORIES_SUCCESS,
        payload: { value: 118 }
      };

      expect(deleteGroupCategoriesSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteGroupCategoryError', () => {
    it('has a type of DELETE_GROUP_CATEGORY_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_GROUP_CATEGORIES_ERROR,
        error: { value: 709 }
      };

      expect(deleteGroupCategoriesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('categoriesUnmount', () => {
    it('has a type of GROUP_CATEGORIES_UNMOUNT', () => {
      const expected = {
        type: CATEGORIES_UNMOUNT,
      };

      expect(categoriesUnmount()).toEqual(expected);
    });
  });
});
