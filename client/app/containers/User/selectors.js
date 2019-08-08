import { createSelector } from 'reselect/lib';
import { initialState } from 'containers/User/reducer';

import dig from 'object-dig';

const selectUsersDomain = state => state.users || initialState;

const selectPaginatedUsers = () => createSelector(
  selectUsersDomain,
  usersState => usersState.userList
);

const selectUserTotal = () => createSelector(
  selectUsersDomain,
  usersState => usersState.userTotal
);

const selectUser = () => createSelector(
  selectUsersDomain,
  usersState => usersState.currentUser
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
    if (fieldData)
      fieldData.forEach((datum) => {
        /* eslint-disable no-param-reassign */
        datum.data = deserializeDatum(datum);
        datum.field.options_text = deserializeOptionsText(datum);
        /* eslint-enable no-param-reassign */
      });

    return fieldData;
  }
);

/* Helpers */

function deserializeDatum(fieldDatum) {
  const datum = fieldDatum.data;
  const type = dig(fieldDatum, 'field', 'type');

  /* Certain fields have there data json serialized as a single item array  */
  if (type && (type === 'SelectField' || type === 'CheckBoxField')) {
    const parsedDatum = JSON.parse(datum)[0];
    return { label: parsedDatum, value: parsedDatum };
  }

  return datum;
}

function deserializeOptionsText(datum) {
  /* Fields with multiple 'options' store them as new line separated strings
   *  - Split them on '\n' into an array
   *  - Map array to a list of 'select' objects - [ { label: <>, value: <> ] } ... ]
   */

  const optionsText = datum.field.options_text;

  return optionsText
    ? datum.field.options_text
      .split('\n')
      .map(option => ({ label: option, value: option }))
    : optionsText;
}

export {
  selectUsersDomain, selectPaginatedUsers,
  selectUserTotal, selectUser, selectFieldData
};
