import {
  GET_LOGS_BEGIN,
  GET_LOGS_ERROR,
  GET_LOGS_SUCCESS,
  EXPORT_LOGS_BEGIN,
  EXPORT_LOGS_ERROR,
  EXPORT_LOGS_SUCCESS
} from '../constants';

import {
  getLogsBegin,
  getLogsError,
  getLogsSuccess,
  exportLogsBegin,
  exportLogsError,
  exportLogsSuccess
} from '../actions';

describe('log actions', () => {
  describe('getArchivesBegin', () => {
    it('has a type of GET_LOGS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_LOGS_BEGIN,
        payload: { value: 118 }
      };

      expect(getLogsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getLogsSuccess', () => {
    it('has a type of GET_LOGS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_LOGS_SUCCESS,
        payload: { value: 865 }
      };

      expect(getLogsSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getLogsError', () => {
    it('has a type of GET_LOGS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_LOGS_ERROR,
        error: { value: 709 }
      };

      expect(getLogsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('exportLogsBegin', () => {
    it('has a type of EXPORT_LOGS_BEGIN and sets a given payload', () => {
      const expected = {
        type: EXPORT_LOGS_BEGIN,
        payload: { value: 118 }
      };

      expect(exportLogsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('exportLogsSuccess', () => {
    it('has a type of EXPORT_LOGS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: EXPORT_LOGS_SUCCESS,
        payload: { value: 118 }
      };

      expect(exportLogsSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('exportLogsError', () => {
    it('has a type of EXPORT_LOGS_ERROR and sets a given error', () => {
      const expected = {
        type: EXPORT_LOGS_ERROR,
        error: { value: 709 }
      };

      expect(exportLogsError({ value: 709 })).toEqual(expected);
    });
  });
});
