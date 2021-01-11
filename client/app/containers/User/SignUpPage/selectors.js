import { createSelector } from 'reselect/lib';

import produce from 'immer';

import { initialState } from './reducer';
import { deserializeFields, timezoneMap } from 'utils/selectorHelpers';
import { groupMapper } from 'containers/Group/selectors';

const selectSignUpDomain = state => state.signUp || initialState;

const selectToken = () => createSelector(
  selectSignUpDomain,
  usersState => usersState.token
);

const selectUser = () => createSelector(
  selectSignUpDomain,
  (usersState) => {
    const { user } = usersState;
    if (user) {
      const timezoneArray = user.timezones;
      return produce(user, (draft) => {
        draft.timezones = timezoneMap(timezoneArray, user, draft);
        draft.field_data = deserializeFields(user.field_data);
        draft.group_ids = user.group_ids.reduce((sum, groupId) => {
          sum[groupId] = true;
          return sum;
        }, {});
      });
    }
    return null;
  }
);

const selectGroups = () => createSelector(
  selectSignUpDomain,
  usersState => Object
    .values(usersState.groupList)
    .map(groupMapper)
);

const selectGroupsTotal = () => createSelector(
  selectSignUpDomain,
  usersState => usersState.groupTotal
);

const selectGroupsIsLoading = () => createSelector(
  selectSignUpDomain,
  usersState => usersState.isGroupsLoading
);

const selectIsLoading = () => createSelector(
  selectSignUpDomain,
  usersState => usersState.isLoading
);

const selectIsCommitting = () => createSelector(
  selectSignUpDomain,
  usersState => usersState.isCommitting
);

const selectFormErrors = () => createSelector(
  selectSignUpDomain,
  usersState => usersState.errors
);

export {
  selectSignUpDomain, selectToken,
  selectIsLoading, selectUser, selectFormErrors,
  selectIsCommitting, selectGroups, selectGroupsTotal,
  selectGroupsIsLoading,
};
