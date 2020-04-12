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
        draft.timezones = timezoneMap(timezoneArray, user, draft);
        draft.field_data = mapFieldData(user.field_data);
      });
    }
    return null;
  }
);

// Map the possible timezones to make it compatible with select fields
//    If the time zone we are currently mapping is what the user's timezone is set too
//    set the timezone field to be also compatible with select fields
const timezoneMap = (timeZones, user, draft) => {
  return timeZones.map((element) => {
    if (element[1] === user.time_zone)
      draft.time_zone = { label: element[1], value: element[0] };
    return { label: element[1], value: element[0] };
  });
};

// maps each field to transfom select/checkbox field options to an array compatible with the Select Field
const mapFieldData = fieldData => produce(fieldData, (draft) => {
  draft.field = splitOptions(fieldData.field);
});

// Takes fields and transforms the options texts in the form of ("Option1\nOption2\nOption3\n")
// and turns it into an array of select field options [{label: "Option1", value: "Option1"}, ...]
const splitOptions = field => produce(field, (draft) => {
  draft.options = field.options_text
    ? field.options_text.split('\n').filter(o => o).map(o => ({ value: o, label: o }))
    : null;
});

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
