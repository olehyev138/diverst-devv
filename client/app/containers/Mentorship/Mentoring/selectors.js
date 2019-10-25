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


export {
  selectPaginatedUsers,
  selectUsersTotal,
  selectIsFetchingUsers,
};
