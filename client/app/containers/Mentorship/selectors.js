import { createSelector } from 'reselect/lib';
import produce from 'immer';
import { initialState } from 'containers/Mentorship/reducer';

const weekdays = [
  'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
];

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

const selectFormUser = () => createSelector(
  selectMentorshipDomain,
  (mentorshipState) => {
    const user = mentorshipState.currentUser;
    if (user)
      return produce(user, (draft) => {
        if (user.availabilities)
          draft.availabilities = user.availabilities.map(i => ({
            // label: new Date().toLocaleString('en-us', { weekday: 'long' }),
            day: {
              label: weekdays[i.day],
              value: i.day
            },
            start: i.start,
            end: i.end,
            local_start: i.local_start,
            local_end: i.local_end,
          }));
        if (user.interest_options)
          draft.interest_options = user.interest_options.map(i => ({ label: i.name, value: i.id }));
        if (user.mentoring_interests)
          draft.mentoring_interests = user.mentoring_interests.map(i => ({ label: i.name, value: i.id }));
        if (user.type_options)
          draft.type_options = user.type_options.map(i => ({ label: i.name, value: i.id }));
        if (user.mentoring_types)
          draft.mentoring_types = user.mentoring_types.map(i => ({ label: i.name, value: i.id }));
      });

    return null;
  }
);

const selectPaginatedMentors = () => createSelector(
  selectMentorshipDomain,
  (mentorshipState) => {
    const mentorings = mentorshipState.mentorList;
    if (mentorings) {
      return mentorings.map(mentoring => mentoring.mentor);
    }
    return [];
  }
);

const selectMentorTotal = () => createSelector(
  selectMentorshipDomain,
  mentorshipState => mentorshipState.mentorTotal
);

const selectIsFetchingMentors = () => createSelector(
  selectMentorshipDomain,
  mentorshipState => mentorshipState.isFetchingMentors
);

const selectPaginatedMentees = () => createSelector(
  selectMentorshipDomain,
  (mentorshipState) => {
    const mentorings = mentorshipState.menteeList;
    if (mentorings)
      return mentorings.map(mentoring => mentoring.mentee);
    return [];
  }
);

const selectMenteeTotal = () => createSelector(
  selectMentorshipDomain,
  mentorshipState => mentorshipState.menteeTotal
);

const selectIsFetchingMentees = () => createSelector(
  selectMentorshipDomain,
  mentorshipState => mentorshipState.isFetchingMentees
);


export {
  selectMentorshipDomain, selectPaginatedUsers,
  selectUserTotal, selectUser,
  selectIsFetchingUsers,
  selectFormUser,
  selectPaginatedMentors,
  selectMentorTotal,
  selectIsFetchingMentors,
  selectPaginatedMentees,
  selectMenteeTotal,
  selectIsFetchingMentees,
};
