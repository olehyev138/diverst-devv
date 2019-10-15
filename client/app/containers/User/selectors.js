import { createSelector } from 'reselect/lib';

import produce from 'immer';
import dig from 'object-dig';

import { initialState } from 'containers/User/reducer';
import { deserializeDatum, deserializeOptionsText } from 'utils/customFieldHelpers';

const selectUsersDomain = state => state.users || initialState;

const selectPaginatedUsers = () => createSelector(
  selectUsersDomain,
  usersState => usersState.userList
);

const selectUserTotal = () => createSelector(
  selectUsersDomain,
  usersState => usersState.userTotal
);

const selectIsFetchingUsers = () => createSelector(
  selectUsersDomain,
  usersState => usersState.isFetchingUsers
);

const selectUser = () => createSelector(
  selectUsersDomain,
  usersState => usersState.currentUser
);

const selectPaginatedPosts = () => createSelector(
  selectUsersDomain,
  userState => userState.posts
);

const selectPostsTotal = () => createSelector(
  selectUsersDomain,
  userState => userState.postsTotal
);

const selectPaginatedEvents = () => createSelector(
  selectUsersDomain,
  userState => userState.events
);

const selectEventsTotal = () => createSelector(
  selectUsersDomain,
  userState => userState.eventsTotal
);

const selectIsLoadingPosts = () => createSelector(
  selectUsersDomain,
  userState => userState.isLoadingPosts
);

const selectIsLoadingEvents = () => createSelector(
  selectUsersDomain,
  userState => userState.isLoadingEvents
);

/*
 * - Select fieldData objects out of user
 *   - parse field_data.data strings
 *   - parse any field 'options_text' into arrays of 'select' objects [ { label: <>, value: <> ] } ... ]
 */
const selectFieldData = () => createSelector(
  selectUsersDomain,
  (usersState) => {
    const fieldData = dig(usersState, 'currentUser', 'field_data');
    if (!fieldData) return fieldData;

    return produce(fieldData, (draft) => {
      if (fieldData)
        fieldData.forEach((datum) => {
          datum.data = deserializeDatum(datum);
          datum.field.options_text = deserializeOptionsText(datum.field);
        });
    });
  }
);

export {
  selectUsersDomain, selectPaginatedUsers,
  selectUserTotal, selectUser, selectFieldData,
  selectIsFetchingUsers, selectIsLoadingPosts,
  selectIsLoadingEvents, selectPaginatedPosts,
  selectPostsTotal, selectPaginatedEvents,
  selectEventsTotal,
};
