import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import { selectGroupsDomain } from '../../Group/selectors';

const selectCampaignsDomain = state => state.campaigns || initialState;

const selectPaginatedCampaigns = () => createSelector(
  selectCampaignsDomain,
  campaignsState => campaignsState.campaignList
);

/* Select user list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
// const selectPaginatedSelectCampaigns = () => createSelector(
//   selectCampaignsDomain,
//   campaignsState => (
//     Object
//       .values(campaignsState.campaignList)
//       .map(user => ({
//         value: user.id,
//         label: `${user.first_name} ${user.last_name}`
//       }))
//   )
// );

const selectCampaignTotal = () => createSelector(
  selectCampaignsDomain,
  campaignsState => campaignsState.campaignTotal
);

const selectCampaign = () => createSelector(
  selectCampaignsDomain,
  campaignsState => campaignsState.currentCampaign
);

const selectIsFetchingCampaigns = () => createSelector(
  selectCampaignsDomain,
  campaignsState => campaignsState.isFetchingCampaigns
);

const selectIsFormLoading = () => createSelector(
  selectCampaignsDomain,
  campaignsState => campaignsState.isFormLoading
);

const selectIsCommitting = () => createSelector(
  selectCampaignsDomain,
  campaignsState => campaignsState.isCommitting
);

const selectFormCampaign = () => createSelector(
  selectCampaignsDomain,
  (campaignsState) => {
    const { currentCampaign } = campaignsState;
    if (!currentCampaign) return null;

    // clone group before making mutations on it
    const selectCampaign = Object.assign({}, currentCampaign);

    selectCampaign.groups = selectCampaign.groups.map(group => ({
      value: group.id,
      label: group.name
    }));

    return selectCampaign;
  }
);

export {
  selectCampaignsDomain, selectPaginatedCampaigns, selectCampaign,
  selectCampaignTotal, selectIsFetchingCampaigns, selectIsCommitting,
  selectFormCampaign, selectIsFormLoading,
};
