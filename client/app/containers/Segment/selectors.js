import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Segment/reducer';

import dig from 'object-dig';

const selectSegmentsDomain = state => state.segments || initialState;

const selectPaginatedSegments = () => createSelector(
  selectSegmentsDomain,
  segmentsState => segmentsState.segmentList
);

const selectSegmentTotal = () => createSelector(
  selectSegmentsDomain,
  segmentsState => segmentsState.segmentTotal
);

const selectSegment = () => createSelector(
  selectSegmentsDomain,
  segmentsState => segmentsState.currentSegment
);

const selectSegmentRules = () => createSelector(
  selectSegmentsDomain,
  (segmentsState) => ({
    fieldRules: dig(segmentsState, 'currentSegment', 'field_rules'),
    orderRules: dig(segmentsState, 'currentSegment', 'order_rules'),
    groupRules: dig(segmentsState, 'currentSegment', 'group_rules')
  })
);

const selectFormSegment = () => createSelector(
  selectSegmentsDomain,
  (segmentsState) => {
    const { currentSegment } = segmentsState;
    if (!currentSegment) return null;

    // clone segment before making mutations on it
    const selectSegment = Object.assign({}, currentSegment);

    selectSegment.children = selectSegment.children.map(child => ({
      value: child.id,
      label: child.name
    }));

    return selectSegment;
  }
);

export {
  selectSegmentsDomain, selectPaginatedSegments,
  selectSegmentTotal, selectSegment,
  selectSegmentRules, selectFormSegment
};
