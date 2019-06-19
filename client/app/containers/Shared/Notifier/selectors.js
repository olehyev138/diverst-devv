import { createSelector } from 'reselect';

const selectNotifer = state => state.notifier;

const selectNotifications = () => createSelector(
  selectNotifer,
  notifierState => notifierState.notifications,
);

export { selectNotifications };
