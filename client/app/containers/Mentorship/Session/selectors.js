import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectSessionDomain = state => state.sessions || initialState;

const selectPaginatedSessions = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.sessionList
);

const selectSessionsTotal = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.sessionListTotal
);

const selectSession = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.currentSession
);

const selectIsFetchingSessions = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.isFetchingSessions
);

const selectIsCommitting = () => createSelector(
  selectSessionDomain,
  sessionState => sessionState.isCommitting
);

export {
  selectPaginatedSessions,
  selectSessionsTotal,
  selectSession,
  selectIsFetchingSessions,
  selectIsCommitting,
};
