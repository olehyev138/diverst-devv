import produce from 'immer';
import {
  getRegionLeadersSuccess,
  getRegionLeaderSuccess
} from 'containers/Region/RegionLeaders/actions';
import regionLeaderReducer from 'containers/Region/RegionLeaders/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('regionLeaderReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isCommitting: false,
      isFormLoading: true,
      regionLeaderList: [],
      regionLeaderTotal: null,
      isFetchingRegionLeaders: true,
      currentRegionLeader: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(regionLeaderReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getRegionLeadersSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.regionLeaderList = { id: 4, name: 'dummy' };
      draft.regionLeaderTotal = 31;
      draft.isFetchingRegionLeaders = false;
    });

    expect(
      regionLeaderReducer(
        state,
        getRegionLeadersSuccess({
          items: { id: 4, name: 'dummy' },
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getRegionLeaderSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentRegionLeader = { id: 4, name: 'dummy' };
      draft.isFormLoading = false;
    });

    expect(
      regionLeaderReducer(
        state,
        getRegionLeaderSuccess({
          region_leader: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
