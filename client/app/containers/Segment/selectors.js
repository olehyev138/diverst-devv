import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Segment/reducer';

import dig from 'object-dig';
import { deserializeDatum, deserializeOptionsText } from 'utils/customFieldHelpers';

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

    // TODO: multi selects

    (dig(segmentsState.currentSegment, 'field_rules') || []).forEach((fieldRule) => {
      fieldRule.data = deserializeDatum(fieldRule);
      fieldRule.field.options_text = deserializeOptionsText(fieldRule.field);
    });

    segment.group_rules = (dig(segmentsState.currentSegment, 'group_rules') || []).map((groupRule) => {
      groupRule.group_ids = groupRule.group_ids.map(group => ({ label: group.name, value: group.id }));
      return groupRule;
    });

    segment.order_rules = dig(segmentsState.currentSegment, 'order_rules') || [];

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
