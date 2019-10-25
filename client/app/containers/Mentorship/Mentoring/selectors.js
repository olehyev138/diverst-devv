import { createSelector } from 'reselect/lib';
import produce from 'immer';
import { initialState } from 'containers/Mentorship/Mentoring/reducer';

const weekdays = [
  'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
];

const selectMentoringDomain = state => state.mentoring || initialState;

const selectPaginatedMentors = () => createSelector(
  selectMentoringDomain,
  // (mentorshipState) => {
  //   const { mentorList } = mentorshipState;
  //   if (mentorList)
  //     return mentorList.map(mentoring => mentoring.mentor);
  //   return [];
  // }
  mentorshipState => mentorshipState.mentorList
);

const selectMentorTotal = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.mentorTotal
);

const selectIsFetchingMentors = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.isFetchingMentors
);

const selectPaginatedMentees = () => createSelector(
  selectMentoringDomain,
  // (mentorshipState) => {
  //   const mentorings = mentorshipState.menteeList;
  //   if (mentorings)
  //     return mentorings.map(mentoring => mentoring.mentee);
  //   return [];
  // }
  mentorshipState => mentorshipState.menteeList
);

const selectMenteeTotal = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.menteeTotal
);

const selectIsFetchingMentees = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.isFetchingMentees
);

const selectPaginatedAvailableMentors = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.availableMentorList
);

const selectAvailableMentorTotal = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.availableMentorTotal
);

const selectIsFetchingAvailableMentors = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.isFetchingAvailableMentors
);

const selectPaginatedAvailableMentees = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.availableMenteeList
);

const selectAvailableMenteeTotal = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.availableMenteeTotal
);

const selectIsFetchingAvailableMentees = () => createSelector(
  selectMentoringDomain,
  mentorshipState => mentorshipState.isFetchingAvailableMentees
);


export {
  selectPaginatedMentors,
  selectMentorTotal,
  selectIsFetchingMentors,
  selectPaginatedMentees,
  selectMenteeTotal,
  selectIsFetchingMentees,
  selectPaginatedAvailableMentors,
  selectAvailableMentorTotal,
  selectIsFetchingAvailableMentors,
  selectPaginatedAvailableMentees,
  selectAvailableMenteeTotal,
  selectIsFetchingAvailableMentees
};
