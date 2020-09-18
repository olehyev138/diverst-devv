import {
  GET_GROUP_OVERVIEW_METRICS_BEGIN, GET_GROUP_OVERVIEW_METRICS_SUCCESS, GET_GROUP_OVERVIEW_METRICS_ERROR,
  GET_GROUP_SPECIFIC_METRICS_BEGIN, GET_GROUP_SPECIFIC_METRICS_SUCCESS, GET_GROUP_SPECIFIC_METRICS_ERROR,
  GET_GROUP_POPULATION_BEGIN, GET_GROUP_POPULATION_SUCCESS, GET_GROUP_POPULATION_ERROR,
  GET_GROWTH_OF_GROUPS_BEGIN, GET_GROWTH_OF_GROUPS_SUCCESS, GET_GROWTH_OF_GROUPS_ERROR,
  GET_VIEWS_PER_GROUP_BEGIN, GET_VIEWS_PER_GROUP_SUCCESS, GET_VIEWS_PER_GROUP_ERROR,
  GET_INITIATIVES_PER_GROUP_BEGIN, GET_INITIATIVES_PER_GROUP_SUCCESS, GET_INITIATIVES_PER_GROUP_ERROR,
  GET_NEWS_PER_GROUP_BEGIN, GET_NEWS_PER_GROUP_SUCCESS, GET_NEWS_PER_GROUP_ERROR,
  GET_VIEWS_PER_NEWS_LINK_BEGIN, GET_VIEWS_PER_NEWS_LINK_SUCCESS, GET_VIEWS_PER_NEWS_LINK_ERROR,
  GET_VIEWS_PER_FOLDER_BEGIN, GET_VIEWS_PER_FOLDER_SUCCESS, GET_VIEWS_PER_FOLDER_ERROR,
  GET_VIEWS_PER_RESOURCE_BEGIN, GET_VIEWS_PER_RESOURCE_SUCCESS, GET_VIEWS_PER_RESOURCE_ERROR,
  GET_GROWTH_OF_RESOURCES_BEGIN, GET_GROWTH_OF_RESOURCES_SUCCESS, GET_GROWTH_OF_RESOURCES_ERROR,
  GET_GROWTH_OF_USERS_BEGIN, GET_GROWTH_OF_USERS_SUCCESS, GET_GROWTH_OF_USERS_ERROR,
  METRICS_UNMOUNT,
} from 'containers/Analyze/constants';

import {
  getGroupOverviewMetricsBegin,
  getGroupOverviewMetricsError,
  getGroupOverviewMetricsSuccess,
  getGroupSpecificMetricsBegin,
  getGroupSpecificMetricsError,
  getGroupSpecificMetricsSuccess,
  getGroupPopulationBegin,
  getGroupPopulationError,
  getGroupPopulationSuccess,
  getGrowthOfGroupsBegin,
  getGrowthOfGroupsError,
  getGrowthOfGroupsSuccess,
  getGrowthOfResourcesBegin,
  getGrowthOfResourcesError,
  getGrowthOfResourcesSuccess,
  getViewsPerFolderBegin,
  getViewsPerFolderError,
  getViewsPerFolderSuccess,
  getViewsPerGroupBegin,
  getViewsPerGroupError,
  getViewsPerGroupSuccess,
  getViewsPerNewsLinkBegin,
  getViewsPerNewsLinkError,
  getViewsPerNewsLinkSuccess,
  getViewsPerResourceBegin,
  getViewsPerResourceError,
  getViewsPerResourceSuccess,
  getGrowthOfUsersBegin,
  getGrowthOfUsersError,
  getGrowthOfUsersSuccess,
  getInitiativesPerGroupBegin,
  getInitiativesPerGroupError,
  getInitiativesPerGroupSuccess,
  getNewsPerGroupBegin,
  getNewsPerGroupError,
  getNewsPerGroupSuccess,
  metricsUnmount
} from '../actions';

describe('analyze actions', () => {
  describe('getGroupOverviewMetricsBegin', () => {
    it('has a type of GET__GROUP_OVERVIEW_METRICS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_OVERVIEW_METRICS_BEGIN,
        payload: { value: 118 }
      };

      expect(getGroupOverviewMetricsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGroupOverviewMetricsSuccess', () => {
    it('has a type of GET__GROUP_OVERVIEW_METRICS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_OVERVIEW_METRICS_SUCCESS,
        payload: { value: 865 }
      };

      expect(getGroupOverviewMetricsSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getGroupOverviewMetricsError', () => {
    it('has a type of GET__GROUP_OVERVIEW_METRICS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_GROUP_OVERVIEW_METRICS_ERROR,
        error: { value: 709 }
      };

      expect(getGroupOverviewMetricsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getGroupSpecificMetricsBegin', () => {
    it('has a type of GET_GROUP_SPECIFIC_METRICS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_SPECIFIC_METRICS_BEGIN,
        payload: { value: 118 }
      };

      expect(getGroupSpecificMetricsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGroupSpecificMetricsSuccess', () => {
    it('has a type of GET_GROUP_SPECIFIC_METRICS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_SPECIFIC_METRICS_SUCCESS,
        payload: { value: 865 }
      };

      expect(getGroupSpecificMetricsSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getGroupSpecificMetricsError', () => {
    it('has a type of GET_GROUP_SPECIFIC_METRICS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_GROUP_SPECIFIC_METRICS_ERROR,
        error: { value: 709 }
      };

      expect(getGroupSpecificMetricsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getGroupPopulationBegin', () => {
    it('has a type of GET_GROUP_POPULATION_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_POPULATION_BEGIN,
        payload: { value: 118 }
      };

      expect(getGroupPopulationBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGroupPopulationSuccess', () => {
    it('has a type of GET_GROUP_POPULATION_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_POPULATION_SUCCESS,
        payload: { value: 865 }
      };

      expect(getGroupPopulationSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getGroupPopulationError', () => {
    it('has a type of GET_GROUP_POPULATION_ERROR and sets a given error', () => {
      const expected = {
        type: GET_GROUP_POPULATION_ERROR,
        error: { value: 709 }
      };

      expect(getGroupPopulationError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getGrowthOfGroupsBegin', () => {
    it('has a type of GET_GROWTH_OF_GROUPS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_GROWTH_OF_GROUPS_BEGIN,
        payload: { value: 118 }
      };

      expect(getGrowthOfGroupsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGrowthOfGroupsSuccess', () => {
    it('has a type of GET_GROWTH_OF_GROUPS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_GROWTH_OF_GROUPS_SUCCESS,
        payload: { value: 865 }
      };

      expect(getGrowthOfGroupsSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getGrowthOfGroupsError', () => {
    it('has a type of GET_GROWTH_OF_GROUPS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_GROWTH_OF_GROUPS_ERROR,
        error: { value: 709 }
      };

      expect(getGrowthOfGroupsError({ value: 709 })).toEqual(expected);
    });
  });
  describe('getViewsPerGroupBegin', () => {
    it('has a type of GET_VIEWS_PER_GROUP_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_VIEWS_PER_GROUP_BEGIN,
        payload: { value: 118 }
      };

      expect(getViewsPerGroupBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getViewsPerGroupSuccess', () => {
    it('has a type of GET_VIEWS_PER_GROUP_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_VIEWS_PER_GROUP_SUCCESS,
        payload: { value: 865 }
      };

      expect(getViewsPerGroupSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getViewsPerGroupError', () => {
    it('has a type of GET_VIEWS_PER_GROUP_ERROR and sets a given error', () => {
      const expected = {
        type: GET_VIEWS_PER_GROUP_ERROR,
        error: { value: 709 }
      };

      expect(getViewsPerGroupError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getInitiativesPerGroupBegin', () => {
    it('has a type of GET_INITIATIVES_PER_GROUP_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_INITIATIVES_PER_GROUP_BEGIN,
        payload: { value: 118 }
      };

      expect(getInitiativesPerGroupBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getInitiativesPerGroupSuccess', () => {
    it('has a type of GET_INITIATIVES_PER_GROUP_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_INITIATIVES_PER_GROUP_SUCCESS,
        payload: { value: 865 }
      };

      expect(getInitiativesPerGroupSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getInitiativesPerGroupError', () => {
    it('has a type of GET_INITIATIVES_PER_GROUP_ERROR and sets a given error', () => {
      const expected = {
        type: GET_INITIATIVES_PER_GROUP_ERROR,
        error: { value: 709 }
      };

      expect(getInitiativesPerGroupError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getNewsPerGroupBegin', () => {
    it('has a type of GET_NEWS_PER_GROUP_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_NEWS_PER_GROUP_BEGIN,
        payload: { value: 118 }
      };

      expect(getNewsPerGroupBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getNewsPerGroupSuccess', () => {
    it('has a type of GET_NEWS_PER_GROUP_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_NEWS_PER_GROUP_SUCCESS,
        payload: { value: 865 }
      };

      expect(getNewsPerGroupSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getNewsPerGroupError', () => {
    it('has a type of GET_NEWS_PER_GROUP_ERROR and sets a given error', () => {
      const expected = {
        type: GET_NEWS_PER_GROUP_ERROR,
        error: { value: 709 }
      };

      expect(getNewsPerGroupError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getViewsPerNewsLinkBegin', () => {
    it('has a type of GET_VIEWS_PER_NEWS_LINK_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_VIEWS_PER_NEWS_LINK_BEGIN,
        payload: { value: 118 }
      };

      expect(getViewsPerNewsLinkBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getViewsPerNewsLinkSuccess', () => {
    it('has a type of GET_VIEWS_PER_NEWS_LINK_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_VIEWS_PER_NEWS_LINK_SUCCESS,
        payload: { value: 865 }
      };

      expect(getViewsPerNewsLinkSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getViewsPerNewsLinkError', () => {
    it('has a type of GET_VIEWS_PER_NEWS_LINK_ERROR and sets a given error', () => {
      const expected = {
        type: GET_VIEWS_PER_NEWS_LINK_ERROR,
        error: { value: 709 }
      };

      expect(getViewsPerNewsLinkError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getGrowthOfUsersBegin', () => {
    it('has a type of GET_GROWTH_OF_USERS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_GROWTH_OF_USERS_BEGIN,
        payload: { value: 118 }
      };

      expect(getGrowthOfUsersBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGrowthOfUsersSuccess', () => {
    it('has a type of GET_GROWTH_OF_USERS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_GROWTH_OF_USERS_SUCCESS,
        payload: { value: 865 }
      };

      expect(getGrowthOfUsersSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getGrowthOfUsersError', () => {
    it('has a type of GET_GROWTH_OF_USERS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_GROWTH_OF_USERS_ERROR,
        error: { value: 709 }
      };

      expect(getGrowthOfUsersError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getGrowthOfResourcesBegin', () => {
    it('has a type of GET_GROWTH_OF_RESOURCES_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_GROWTH_OF_RESOURCES_BEGIN,
        payload: { value: 118 }
      };

      expect(getGrowthOfResourcesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGrowthOfResourcesSuccess', () => {
    it('has a type of GET_GROWTH_OF_RESOURCES_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_GROWTH_OF_RESOURCES_SUCCESS,
        payload: { value: 865 }
      };

      expect(getGrowthOfResourcesSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getGrowthOfResourcesError', () => {
    it('has a type of GET_GROWTH_OF_RESOURCES_ERROR and sets a given error', () => {
      const expected = {
        type: GET_GROWTH_OF_RESOURCES_ERROR,
        error: { value: 709 }
      };

      expect(getGrowthOfResourcesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getViewsPerFolderBegin', () => {
    it('has a type of GET_VIEWS_PER_FOLDER_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_VIEWS_PER_FOLDER_BEGIN,
        payload: { value: 118 }
      };

      expect(getViewsPerFolderBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getViewsPerFolderSuccess', () => {
    it('has a type of GET_VIEWS_PER_FOLDER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_VIEWS_PER_FOLDER_SUCCESS,
        payload: { value: 865 }
      };

      expect(getViewsPerFolderSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getViewsPerFolderError', () => {
    it('has a type of GET_VIEWS_PER_FOLDER_ERROR and sets a given error', () => {
      const expected = {
        type: GET_VIEWS_PER_FOLDER_ERROR,
        error: { value: 709 }
      };

      expect(getViewsPerFolderError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getViewsPerResourceBegin', () => {
    it('has a type of GET_VIEWS_PER_RESOURCE_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_VIEWS_PER_RESOURCE_BEGIN,
        payload: { value: 118 }
      };

      expect(getViewsPerResourceBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getViewsPerResourceSuccess', () => {
    it('has a type of GET_VIEWS_PER_RESOURCE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_VIEWS_PER_RESOURCE_SUCCESS,
        payload: { value: 865 }
      };

      expect(getViewsPerResourceSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getViewsPerResourceError', () => {
    it('has a type of GET_VIEWS_PER_RESOURCE_ERROR and sets a given error', () => {
      const expected = {
        type: GET_VIEWS_PER_RESOURCE_ERROR,
        error: { value: 709 }
      };

      expect(getViewsPerResourceError({ value: 709 })).toEqual(expected);
    });
  });

  describe('metricsUnmount', () => {
    it('has a type of METRICS_UNMOUNT', () => {
      const expected = {
        type: METRICS_UNMOUNT,
      };

      expect(metricsUnmount()).toEqual(expected);
    });
  });
});
