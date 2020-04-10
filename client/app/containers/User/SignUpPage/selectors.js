import { createSelector } from 'reselect/lib';

import produce from 'immer';
import dig from 'object-dig';

import { initialState } from './reducer';

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
        draft.timezones = timezoneArray.map((element) => {
          if (element[1] === user.time_zone)
            draft.time_zone = { label: element[1], value: element[0] };
          return { label: element[1], value: element[0] };
        });
        draft.field_data = user.field_data.map(fd => produce(fd, (draft2) => {
          draft2.field = produce(fd.field, (draft3) => {
            draft3.options = fd.field.options_text
              ? fd.field.options_text.split('\n').filter(o => o).map(o => ({ value: o, label: o }))
              : null;
          });
        }));
      });
    }
    return null;
  }
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
  selectIsCommitting,
};
