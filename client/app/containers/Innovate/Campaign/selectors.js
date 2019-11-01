import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

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

const selectIsFetchingCampaigns = () => createSelector(
  selectCampaignsDomain,
  campaignsState => campaignsState.isFetchingCampaigns
);

const selectIsCommitting = () => createSelector(
  selectCampaignsDomain,
  campaignsState => campaignsState.isCommitting
);

export {
  selectCampaignsDomain, selectPaginatedCampaigns,
  selectCampaignTotal, selectIsFetchingCampaigns, selectIsCommitting
};
