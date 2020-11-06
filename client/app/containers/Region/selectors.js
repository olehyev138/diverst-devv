import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import produce from 'immer';

import { groupMapper } from 'containers/Group/selectors';

const selectRegionsDomain = state => state.regions || initialState;

const selectPaginatedRegions = () => createSelector(
  selectRegionsDomain,
  regionsState => regionsState.regionList
);

/* Select region list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */

const regionMapper = region => ({ value: region.id, label: region.name, children: (region.children || []).map(groupMapper) });

const selectPaginatedSelectRegions = () => createSelector(
  selectRegionsDomain,
  regionsState => (
    Object
      .values(regionsState.regionList)
      .map(regionMapper)
  )
);

const selectRegionTotal = () => createSelector(
  selectRegionsDomain,
  regionsState => regionsState.regionTotal
);

const selectRegion = () => createSelector(
  selectRegionsDomain,
  regionsState => regionsState.currentRegion
);

const selectRegionIsLoading = () => createSelector(
  selectRegionsDomain,
  regionsState => regionsState.isLoading
);

const selectRegionIsFormLoading = () => createSelector(
  selectRegionsDomain,
  regionsState => regionsState.isFormLoading
);

const selectRegionIsCommitting = () => createSelector(
  selectRegionsDomain,
  regionsState => regionsState.isCommitting
);

const selectFormRegion = () => createSelector(
  selectRegionsDomain,
  (regionsState) => {
    const { currentRegion } = regionsState;
    if (!currentRegion) return null;

    // clone region before making mutations on it
    return produce(currentRegion, (draft) => {
      draft.children = currentRegion.children.map(child => ({
        value: child.id,
        label: child.name
      }));
      if (currentRegion.parent)
        draft.parent = {
          value: currentRegion.parent.id,
          label: currentRegion.parent.name
        };
    });
  }
);
const selectHasChanged = () => createSelector(
  selectRegionsDomain,
  regionsState => regionsState.hasChanged
);

export {
  selectRegionsDomain,
  selectPaginatedSelectRegions,
  selectPaginatedRegions,
  selectRegionTotal,
  selectRegion,
  selectFormRegion,
  selectRegionIsLoading,
  selectRegionIsFormLoading,
  selectRegionIsCommitting,
  selectHasChanged,
};
