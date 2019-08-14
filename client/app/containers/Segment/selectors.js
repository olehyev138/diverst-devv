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

const selectSegmentWithRules = () => createSelector(
  selectSegmentsDomain,
  (segmentsState) => {
    const segment = segmentsState.currentSegment;

    if (!segment) return segment;

    segment.field_rules = dig(segmentsState.currentSegment, 'field_rules') || [];
    segment.order_rules = dig(segmentsState.currentSegment, 'order_rules') || [];
    segment.group_rules = (dig(segmentsState.currentSegment, 'group_rules') || []).map((groupRule) => {
      groupRule.group_ids = groupRule.group_ids.map(group => ({ label: group.name, value: group.id })); /* eslint-disable-line no-param-reassign */
      return groupRule;
    });

    return segment;
  }
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
  selectSegmentTotal, selectSegment, selectSegmentWithRules,
  selectFormSegment
};
