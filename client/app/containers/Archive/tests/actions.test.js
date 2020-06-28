import {
  GET_ARCHIVES_BEGIN,
  GET_ARCHIVES_ERROR,
  GET_ARCHIVES_SUCCESS,
  RESTORE_ARCHIVE_BEGIN,
  RESTORE_ARCHIVE_ERROR,
  RESTORE_ARCHIVE_SUCCESS,
} from '../constants';

import {
  getArchivesBegin,
  getArchivesError,
  getArchivesSuccess,
  restoreArchiveBegin,
  restoreArchiveError,
  restoreArchiveSuccess,
} from '../actions';

describe('archive actions', () => {
  describe('getArchivesBegin', () => {
    it('has a type of GET_ARCHIVES_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_ARCHIVES_BEGIN,
        payload: { value: 118 }
      };

      expect(getArchivesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getArchivesSuccess', () => {
    it('has a type of GET_ARCHIVES_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_ARCHIVES_SUCCESS,
        payload: { value: 865 }
      };

      expect(getArchivesSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getArchivesError', () => {
    it('has a type of GET_ARCHIVES_ERROR and sets a given error', () => {
      const expected = {
        type: GET_ARCHIVES_ERROR,
        error: { value: 709 }
      };

      expect(getArchivesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('restoreArchiveBegin', () => {
    it('has a type of RESTORE_ARCHIVE_BEGIN and sets a given payload', () => {
      const expected = {
        type: RESTORE_ARCHIVE_BEGIN,
        payload: { value: 118 }
      };

      expect(restoreArchiveBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('restoreArchiveSuccess', () => {
    it('has a type of RESTORE_ARCHIVE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: RESTORE_ARCHIVE_SUCCESS,
        payload: { value: 118 }
      };

      expect(restoreArchiveSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('restoreArchivesError', () => {
    it('has a type of RESTORE_ARCHIVE_ERROR and sets a given error', () => {
      const expected = {
        type: RESTORE_ARCHIVE_ERROR,
        error: { value: 709 }
      };

      expect(restoreArchiveError({ value: 709 })).toEqual(expected);
    });
  });
});
