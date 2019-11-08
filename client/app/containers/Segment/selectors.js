import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Segment/reducer';

import dig from 'object-dig';
import produce from 'immer';

import { deserializeDatum, deserializeOptionsText } from 'utils/customFieldHelpers';

const selectSegmentsDomain = state => state.segments || initialState;

const selectPaginatedSegments = () => createSelector(
  selectSegmentsDomain,
  segmentsState => segmentsState.segmentList
);

/* Select segment list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
const selectPaginatedSelectSegments = () => createSelector(
  selectSegmentsDomain,
  groupsState => (
    Object
      .values(groupsState.segmentList)
      .map(segment => ({ value: segment.id, label: segment.name }))
  )
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
    const { currentSegment } = segmentsState;
    if (!currentSegment) return currentSegment;

    // use immer to avoid mutating the store
    return produce(currentSegment, (draft) => {
      // TODO: multi selects

      (dig(draft, 'field_rules') || []).forEach((fieldRule) => {
        fieldRule.data = deserializeDatum(fieldRule);
        fieldRule.field.options_text = deserializeOptionsText(fieldRule.field);
      });

      (dig(draft, 'group_rules') || []).forEach((groupRule) => {
        groupRule.group_ids = groupRule.group_ids.map(group => ({ label: group.name, value: group.id }));
      });
    });
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

const selectPaginatedSegmentMembers = () => createSelector(
  selectSegmentsDomain,
  segmentsState => segmentsState.segmentMemberList
);

const selectSegmentMemberTotal = () => createSelector(
  selectSegmentsDomain,
  segmentsState => segmentsState.segmentMemberTotal
);

const selectIsFetchingSegmentMembers = () => createSelector(
  selectSegmentsDomain,
  segmentsState => segmentsState.isFetchingSegmentMembers
);

const selectIsSegmentBuilding = () => createSelector(
  selectSegmentsDomain,
  segmentsState => segmentsState.isSegmentBuilding
);

const selectIsLoading = () => createSelector(
  selectSegmentsDomain,
  segmentsState => segmentsState.isLoading
);

const selectIsFormLoading = () => createSelector(
  selectSegmentsDomain,
  segmentsState => segmentsState.isFormLoading
);

const selectIsCommitting = () => createSelector(
  selectSegmentsDomain,
  segmentsState => segmentsState.isCommitting
);


export {
  selectSegmentsDomain, selectPaginatedSegments, selectPaginatedSelectSegments,
  selectSegmentTotal, selectSegment, selectSegmentWithRules,
  selectPaginatedSegmentMembers, selectSegmentMemberTotal,
  selectIsFetchingSegmentMembers, selectIsSegmentBuilding,
  selectFormSegment, selectIsLoading, selectIsCommitting,
  selectIsFormLoading,
};
