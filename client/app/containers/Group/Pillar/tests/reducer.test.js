import produce from 'immer';
import {
  getPillarsSuccess,
  getPillarSuccess
} from 'containers/Group/Pillar/actions';
import pillarReducer from 'containers/Group/Pillar/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('pillarReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      pillarList: [],
      pillarListTotal: null,
      currentPillar: null,
      isFetchingPillars: true,
      isFetchingPillar: true,
      isCommitting: false,
      hasChanged: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(pillarReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getPillarsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.pillarList = { id: 4, name: 'dummy' };
      draft.pillarListTotal = 31;
      draft.isFetchingPillars = false;
    });

    expect(
      pillarReducer(
        state,
        getPillarsSuccess({
          items: { id: 4, name: 'dummy' },
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getPillarSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentPillar = { id: 4, name: 'dummy' };
      draft.isFetchingPillar = false;
    });

    expect(
      pillarReducer(
        state,
        getPillarSuccess({
          pillar: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
