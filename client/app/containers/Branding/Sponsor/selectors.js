import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectSponsorsDomain = state => state.sponsors || initialState;

const selectPaginatedSponsors = () => createSelector(
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

const selectFormSponsor = () => createSelector(
  selectSponsorsDomain,
  (sponsorsState) => {
    const { currentSponsor } = sponsorsState;
    if (!currentSponsor) return null;

    // clone group before making mutations on it
    const selectSponsor = Object.assign({}, currentSponsor);

    selectSponsor.groups = selectSponsor.groups.map(group => ({
      value: group.id,
      label: group.name
    }));

    return selectSponsor;
  }
);

export {
  selectSponsorsDomain, selectPaginatedSponsors, selectSponsor,
  selectSponsorTotal, selectIsFetchingSponsors, selectIsCommitting,
  selectFormSponsor,
};
