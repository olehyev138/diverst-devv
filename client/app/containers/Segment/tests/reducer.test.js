import produce from 'immer';
import {
  getSegmentsSuccess,
  getSegmentSuccess
} from '../actions';
import segmentReducer from 'containers/Segment/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('segmentReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isLoading: true,
      isFormLoading: true,
      isCommitting: false,
      segmentList: {},
      segmentTotal: null,
      currentSegment: null,
      segmentMemberList: [],
      segmentMemberTotal: null,
      isFetchingSegmentMembers: true,
      isSegmentBuilding: false
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(segmentReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getSegments action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.segmentList = { 4: { id: 4, name: 'dummy' } };
      draft.segmentTotal = 31;
      draft.isLoading = false;
    });

    expect(
      segmentReducer(
        state,
        getSegmentsSuccess({
          items: [{ id: 4, name: 'dummy' }],
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getSegmentSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentSegment = { id: 4, name: 'dummy' };
      draft.isFormLoading = false;
    });

    expect(
      segmentReducer(
        state,
        getSegmentSuccess({
          segment: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
