import { createSelector } from 'reselect/lib';

import { initialState } from 'containers/Mentorship/reducer';

const selectMentorshipDomain = state => state.mentorship || initialState;

const selectPaginatedUsers = () => createSelector(
  selectMentorshipDomain,
  mentorshipState => mentorshipState.userList
);

const selectUserTotal = () => createSelector(
  selectMentorshipDomain,
  mentorshipState => mentorshipState.userTotal
);

const selectIsFetchingUsers = () => createSelector(
  selectMentorshipDomain,
  mentorshipState => mentorshipState.isFetchingUsers
);

const selectUser = () => createSelector(
  selectMentorshipDomain,
  mentorshipState => mentorshipState.currentUser
);

export {
  selectMentorshipDomain, selectPaginatedUsers,
  selectUserTotal, selectUser,
  selectIsFetchingUsers
};
