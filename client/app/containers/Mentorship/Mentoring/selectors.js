import { createSelector } from 'reselect/lib';
import produce from 'immer';
import { initialState } from 'containers/Mentorship/Mentoring/reducer';

const weekdays = [
  'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
];

const selectMentoringDomain = state => state.mentoring || initialState;

const selectPaginatedUsers = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.userList
);

const selectUsersTotal = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.userTotal
);

const selectIsFetchingUsers = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.isFetchingUsers
);

const selectPaginatedMentors = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.mentorshipList.map(mentorship => mentorship.mentor)
);

const selectPaginatedMentees = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.mentorshipList.map(mentorship => mentorship.mentee)
);

const selectMentorshipsTotal = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.mentorshipListTotal
);

const selectIsFetchingMentorships = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.isFetchingMentorships
);


export {
  selectPaginatedUsers,
  selectUsersTotal,
  selectIsFetchingUsers,
  selectPaginatedMentors,
  selectPaginatedMentees,
  selectMentorshipsTotal,
  selectIsFetchingMentorships,
};
