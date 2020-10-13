import {
  selectMetricsDomain, selectGroupPopulation, selectViewsPerGroup,
  selectGrowthOfGroups, selectInitiativesPerGroup, selectNewsPerGroup,
  selectViewsPerNewsLink, selectViewsPerFolder, selectViewsPerResource,
  selectGrowthOfResources, selectGrowthOfUsers, selectGroupOverviewMetrics,
  selectGroupSpecificMetrics
} from '../selectors';

import { initialState } from '../reducer';

describe('Metrics selectors', () => {
  describe('selectMetricsDomain', () => {
    it('should select the metrics domain', () => {
      const mockedState = {};
      const selected = selectMetricsDomain(mockedState);

      expect(selected).toEqual({ ...initialState });
    });

    it('should select initialState', () => {
      const mockedState = {};
      const selected = selectMetricsDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectGroupPopulation', () => {
    it('should return the selected item', () => {
      const mockedState = { metricsData: { groupPopulation: {} } };
      const selected = selectGroupPopulation().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectGrowthOfGroups', () => {
    it('should return the selected item', () => {
      const mockedState = { metricsData: { growthOfGroups: {} } };
      const selected = selectGrowthOfGroups().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectGrowthOfResources', () => {
    it('should return the selected item', () => {
      const mockedState = { metricsData: { growthOfResources: {} } };
      const selected = selectGrowthOfResources().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectGrowthOfUsers', () => {
    it('should return the selected item', () => {
      const mockedState = { metricsData: { growthOfUsers: {} } };
      const selected = selectGrowthOfUsers().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectGroupOverviewMetrics', () => {
    it('should return the selected item', () => {
      const mockedState = { metricsData: { groupOverviewMetrics: {} } };
      const selected = selectGroupOverviewMetrics().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectGroupSpecificMetrics', () => {
    it('should return the selected item', () => {
      const mockedState = { metricsData: { groupSpecificMetrics: {} } };
      const selected = selectGroupSpecificMetrics().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectNewsPerGroup', () => {
    it('should return the selected item', () => {
      const mockedState = { metricsData: { newsPerGroup: {} } };
      const selected = selectNewsPerGroup().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectViewsPerGroup', () => {
    it('should return array when selectSeriesValues returns null', () => {
      const mockedState = { metricsData: { viewsPerGroup: {} } };
      const selected = selectViewsPerGroup().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });

    it('should return horizontal bargraph info', () => {
      const mockedState = { metricsData: { viewsPerGroup: {
        series: { 0: { values: [{}] } },
        values: [],
      } } };
      const selected = selectViewsPerGroup().resultFunc(mockedState);

      expect(selected).toEqual([{ children: {}, x: undefined, y: undefined }]);
    });
  });

  describe('selectViewsPerNewsLink', () => {
    it('should return array when selectViewsPerNewsLink returns null', () => {
      const mockedState = { metricsData: { viewsPerNewsLink: {} } };
      const selected = selectViewsPerNewsLink().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });

    it('should return horizontal bargraph info', () => {
      const mockedState = { metricsData: { viewsPerNewsLink: {
        series: { 0: { values: [{}] } },
        values: [],
      } } };
      const selected = selectViewsPerNewsLink().resultFunc(mockedState);

      expect(selected).toEqual([{ children: {}, x: undefined, y: undefined }]);
    });
  });

  describe('selectViewsPerResource', () => {
    it('should return array when selectViewsPerResource returns null', () => {
      const mockedState = { metricsData: { viewsPerResource: {} } };
      const selected = selectViewsPerResource().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });

    it('should return horizontal bargraph info', () => {
      const mockedState = { metricsData: { viewsPerResource: {
        series: { 0: { values: [{}] } },
        values: [],
      } } };
      const selected = selectViewsPerResource().resultFunc(mockedState);

      expect(selected).toEqual([{ children: {}, x: undefined, y: undefined }]);
    });
  });

  xdescribe('selectViewsPerFolder', () => {
    it('should return array when selectViewsPerFolder returns null', () => {
      const mockedState = { metricsData: { viewsPerFolder: {} } };
      const selected = selectViewsPerFolder().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });

    it('should return horizontal bargraph info', () => {
      const mockedState = { metricsData: { viewsPerFolder: {
        series: { 0: { values: [{}] } },
        values: [],
      } } };
      const selected = selectViewsPerFolder().resultFunc(mockedState);

      expect(selected).toEqual([{ children: {}, x: undefined, y: undefined }]);
    });
  });


  describe('selectInitiativesPerGroup', () => {
    it('should return array when selectViewsPerFolder returns null', () => {
      const mockedState = { metricsData: { initiativesPerGroup: {} } };
      const selected = selectInitiativesPerGroup().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });

    it('should return horizontal bargraph info', () => {
      const mockedState = { metricsData: { initiativesPerGroup: {
        series: { 0: { values: [{}] } },
        values: [],
      } } };
      const selected = selectInitiativesPerGroup().resultFunc(mockedState);

      expect(selected).toEqual([{ children: {}, x: undefined, y: undefined }]);
    });
  });
});
