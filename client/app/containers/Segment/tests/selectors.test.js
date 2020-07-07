import {
  selectSegmentsDomain, selectPaginatedSegments, selectPaginatedSelectSegments,
  selectSegmentTotal, selectSegment, selectSegmentWithRules,
  selectPaginatedSegmentMembers, selectSegmentMemberTotal,
  selectIsFetchingSegmentMembers, selectIsSegmentBuilding,
  selectFormSegment, selectIsLoading, selectIsCommitting,
  selectIsFormLoading,
} from '../selectors';

import { initialState } from '../reducer';

describe('segment selectors', () => {
  describe('selectSegmentsDomain', () => {
    it('should select the groups domain', () => {
      const mockedState = { segments: { segment: {} } };
      const selected = selectSegmentsDomain(mockedState);

      expect(selected).toEqual({ segment: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectSegmentsDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectSegmentWithRules', () => {
    it('should select the current segment with rules', () => {
      const mockedState = { currentSegment: {} };
      const selected = selectSegmentWithRules().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectFormSegment', () => {
    it('should select the current segment with rules', () => {
      const mockedState = { currentSegment: { children: [] } };
      const selected = selectFormSegment().resultFunc(mockedState);

      expect(selected).toEqual({ children: [] });
    });

    it('should return null', () => {
      const mockedState = { abc: {} };
      const selected = selectFormSegment().resultFunc(mockedState);

      expect(selected).toEqual(null);
    });
  });

  describe('selectPaginatedSelectSegments', () => {
    it('should select the current segment', () => {
      const mockedState = { segmentList: [] };
      const selected = selectPaginatedSelectSegments().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectSegmentTotal', () => {
    it('should select the current segment', () => {
      const mockedState = { segmentTotal: 456 };
      const selected = selectSegmentTotal().resultFunc(mockedState);

      expect(selected).toEqual(456);
    });
  });

  describe('selectPaginatedSegments', () => {
    it('should select the current segment', () => {
      const mockedState = { segmentList: [] };
      const selected = selectPaginatedSegments().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectSegment', () => {
    it('should select the current segment', () => {
      const mockedState = { currentSegment: {} };
      const selected = selectSegment().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectIsCommitting', () => {
    it('should select the \'is committing\' flag', () => {
      const mockedState = { isCommitting: true };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectSegmentMemberTotal', () => {
    it('should select the \'is segmentMemberTotal\' flag', () => {
      const mockedState = { segmentMemberTotal: 123 };
      const selected = selectSegmentMemberTotal().resultFunc(mockedState);

      expect(selected).toEqual(123);
    });
  });

  describe('selectPaginatedSegmentMembers', () => {
    it('should select the \'is segmentMemberList\' flag', () => {
      const mockedState = { segmentMemberList: [] };
      const selected = selectPaginatedSegmentMembers().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectIsSegmentBuilding', () => {
    it('should select the \'is SegmentBuilding\' flag', () => {
      const mockedState = { isSegmentBuilding: true };
      const selected = selectIsSegmentBuilding().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFetchingSegmentMembers', () => {
    it('should select the \'is isFetchingSegmentMembers\' flag', () => {
      const mockedState = { isFetchingSegmentMembers: true };
      const selected = selectIsFetchingSegmentMembers().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFormLoading', () => {
    it('should select the \'is FormLoading\' flag', () => {
      const mockedState = { isFormLoading: true };
      const selected = selectIsFormLoading().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsLoading', () => {
    it('should select the \'is loading\' flag', () => {
      const mockedState = { isLoading: true };
      const selected = selectIsLoading().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });
});
