import { createSelector } from 'reselect/lib';
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

export {
  selectUsersDomain, selectPaginatedUsers,
  selectUserTotal, selectUser, selectFieldData
};
