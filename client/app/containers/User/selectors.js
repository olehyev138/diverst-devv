import { createSelector } from 'reselect/lib';

import produce from 'immer';
import dig from 'object-dig';

import { initialState } from 'containers/User/reducer';

import {
  mapAndDeserializeFieldData,
  mapFieldNames,
  mapSelectField,
  timezoneMap,
  formatColor,
  deserializeFields
} from 'utils/selectorHelpers';

const selectUsersDomain = state => state.users || initialState;

const selectPaginatedUsers = () => createSelector(
  selectUsersDomain,
  usersState => usersState.userList
);

const selectPaginatedSelectUsers = () => createSelector(
  selectUsersDomain,
  usersState => (
    Object
      .values(usersState.userList)
      .map(user => ({ value: user.id, label: user.name }))
  )
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
  userState => userState.currentUser
);

const selectFormUser = () => createSelector(
  selectUsersDomain,
  (usersState) => {
    const user = usersState.currentUser;
    if (user) {
      const timezoneArray = user.timezones;
      return produce(user, (draft) => {
        draft.timezones = timezoneMap(timezoneArray, user, draft);
        draft.field_data = deserializeFields(user.field_data);
        draft.user_role_id = mapSelectField(user.user_role, 'role_name');
        draft.available_roles = user.available_roles
          && user.available_roles.map(item => mapSelectField(item, 'role_name', 'default'));
      });
    }
    return null;
  }
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


const selectCalendarEvents = () => createSelector(
  selectUsersDomain,
  userState => userState.events.map(event => mapFieldNames(event,
    {
      groupId: 'group.id',
      title: 'name',
      backgroundColor: event => formatColor(event.group.calendar_color),
      borderColor: event => formatColor(event.group.calendar_color),
    }, { ...event, textColor: event.is_attending ? 'black' : 'white' }))
);

const selectEventsTotal = () => createSelector(
  selectUsersDomain,
  userState => userState.eventsTotal
);

const selectPaginatedDownloads = () => createSelector(
  selectUsersDomain,
  userState => userState.downloads
);

const selectDownloadsTotal = () => createSelector(
  selectUsersDomain,
  userState => userState.downloadsTotal
);

const selectIsLoadingPosts = () => createSelector(
  selectUsersDomain,
  userState => userState.isLoadingPosts
);

const selectIsLoadingEvents = () => createSelector(
  selectUsersDomain,
  userState => userState.isLoadingEvents
);

const selectIsLoadingDownloads = () => createSelector(
  selectUsersDomain,
  userState => userState.isLoadingDownloads
);

const selectIsFormLoading = () => createSelector(
  selectUsersDomain,
  userState => userState.isFormLoading
);

const selectIsCommitting = () => createSelector(
  selectUsersDomain,
  userState => userState.isCommitting
);

const selectIsDownloadingData = () => createSelector(
  selectUsersDomain,
  userState => userState.isDownloadingData
);

const selectDownloadData = () => createSelector(
  selectUsersDomain,
  userState => userState.downloadData
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

    return deserializeFields(fieldData);
  }
);

export {
  selectUsersDomain, selectPaginatedUsers,
  selectPaginatedSelectUsers,
  selectUserTotal, selectUser, selectFieldData,
  selectIsFetchingUsers, selectIsLoadingPosts,
  selectIsLoadingEvents, selectFormUser, selectCalendarEvents,
  selectPaginatedPosts, selectPostsTotal,
  selectPaginatedEvents, selectEventsTotal,
  selectIsCommitting, selectIsFormLoading,
  selectPaginatedDownloads, selectDownloadsTotal,
  selectIsLoadingDownloads, selectIsDownloadingData,
  selectDownloadData,
};
