import produce from 'immer';
import metricsReducer from 'containers/Analyze/reducer';
import {
  getGroupOverviewMetricsSuccess,
  getGroupSpecificMetricsSuccess,
  getGroupPopulationSuccess,
  getGrowthOfGroupsSuccess,
  getGrowthOfResourcesSuccess,
  getViewsPerFolderSuccess,
  getViewsPerGroupSuccess,
  getViewsPerNewsLinkSuccess,
  getViewsPerResourceSuccess,
  getGrowthOfUsersSuccess,
  getInitiativesPerGroupSuccess,
  getNewsPerGroupSuccess,
  metricsUnmount
} from 'containers/Analyze/actions';

/* eslint-disable default-case, no-param-reassign */
describe('metricsReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      metricsData: {
        groupOverviewMetrics: {},
        groupSpecificMetrics: {},
        groupPopulation: [],
        viewsPerGroup: {},
        growthOfGroups: [],
        initiativesPerGroup: {},
        newsPerGroup: [],
        viewsPerNewsLink: {},
        viewsPerFolder: [],
        viewsPerResource: {},
        growthOfResources: {},
        growthOfUsers: {},
      }
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(metricsReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getGroupOverviewMetricsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.groupOverviewMetrics = { id: 37, name: 'dummy' };
    });

    expect(
      metricsReducer(
        state,
        getGroupOverviewMetricsSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the getGroupSpecificMetricsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.groupSpecificMetrics = { id: 37, name: 'dummy' };
    });

    expect(
      metricsReducer(
        state,
        getGroupSpecificMetricsSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the getGroupPopulationSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.groupPopulation = { id: 37, name: 'dummy' };
    });

    expect(
      metricsReducer(
        state,
        getGroupPopulationSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the getGrowthOfGroupsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.growthOfGroups = [{ id: 37, name: 'dummy' }];
    });
    expect(
      metricsReducer(
        state,
        getGrowthOfGroupsSuccess([{
          id: 37,
          name: 'dummy'
        }])
      )
    ).toEqual(expected);
  });

  it('handles the getGrowthOfResourcesSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.growthOfResources = { id: 37, name: 'dummy' };
    });

    expect(
      metricsReducer(
        state,
        getGrowthOfResourcesSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the getGrowthOfUsersSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.growthOfUsers = { id: 37, name: 'dummy' };
    });

    expect(
      metricsReducer(
        state,
        getGrowthOfUsersSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the getViewsPerFolderSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.viewsPerFolder = { id: 37, name: 'dummy' };
    });

    expect(
      metricsReducer(
        state,
        getViewsPerFolderSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the getViewsPerGroupSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.viewsPerGroup = { id: 37, name: 'dummy' };
    });

    expect(
      metricsReducer(
        state,
        getViewsPerGroupSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the getViewsPerNewsLinkSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.viewsPerNewsLink = { id: 37, name: 'dummy' };
    });

    expect(
      metricsReducer(
        state,
        getViewsPerNewsLinkSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the getViewsPerResourceSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.viewsPerResource = { id: 37, name: 'dummy' };
    });

    expect(
      metricsReducer(
        state,
        getViewsPerResourceSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the getInitiativesPerGroupSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.initiativesPerGroup = { id: 37, name: 'dummy' };
    });

    expect(
      metricsReducer(
        state,
        getInitiativesPerGroupSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the getNewsPerGroupSuccessSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.metricsData.newsPerGroup = { id: 37, name: 'dummy' };
    });

    expect(
      metricsReducer(
        state,
        getNewsPerGroupSuccess({
          id: 37,
          name: 'dummy'
        })
      )
    ).toEqual(expected);
  });

  it('handles the metricsUnmount action correctly', () => {
    const expected = state;

    expect(metricsReducer(state, metricsUnmount())).toEqual(expected);
  });
});
