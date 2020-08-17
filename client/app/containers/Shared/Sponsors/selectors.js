import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectSponsorsDomain = state => state.sponsors || initialState;

const selectPaginatedSponsors = () => createSelector(
  selectSponsorsDomain,
  sponsorsState => sponsorsState.sponsorList
);

const selectSponsors = () => createSelector(
  selectSponsorsDomain,
  sponsorsState => sponsorsState.sponsorList
);

const selectSponsorTotal = () => createSelector(
  selectSponsorsDomain,
  sponsorsState => sponsorsState.sponsorTotal
);

const selectSponsor = () => createSelector(
  selectSponsorsDomain,
  sponsorsState => sponsorsState.currentSponsor
);

const selectIsFetchingSponsors = () => createSelector(
  selectSponsorsDomain,
  sponsorsState => sponsorsState.isFetchingSponsors
);

const selectIsCommitting = () => createSelector(
  selectSponsorsDomain,
  sponsorsState => sponsorsState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectSponsorsDomain,
  sponsorsState => sponsorsState.hasChanged
);

export {
  selectSponsorsDomain, selectPaginatedSponsors, selectSponsor, selectHasChanged,
  selectSponsorTotal, selectIsFetchingSponsors, selectIsCommitting, selectSponsors
};
