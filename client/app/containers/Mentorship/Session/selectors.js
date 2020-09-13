import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import produce from 'immer';

const selectSessionDomain = state => state.sessions || initialState;

const selectPaginatedSessions = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.sessionList
);

const selectPaginatedUsers = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.userList
);

const selectSessionsTotal = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.sessionListTotal
);

const selectSession = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.currentSession
);

const selectFormSession = () => createSelector(
  selectSessionDomain,
  (sessionState) => {
    const session = sessionState.currentSession;
    if (session)
      return produce(session, (draft) => {
        if (session.mentoring_interests)
          draft.mentoring_interests = session.mentoring_interests.map(i => ({ label: i.name, value: i.id }));
        if (session.users)
          draft.users = session.users.map(i => ({ label: i.name, value: i.id }));
      });
    return null;
  }
);

const selectIsFetchingSessions = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.isFetchingSessions
);

const selectIsFetchingSession = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.isFetchingSession
);

const selectIsCommitting = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.hasChanged
);

export {
  selectPaginatedSessions,
  selectPaginatedUsers,
  selectSessionsTotal,
  selectSession,
  selectIsFetchingSessions,
  selectIsFetchingSession,
  selectFormSession,
  selectIsCommitting,
  selectHasChanged,
};