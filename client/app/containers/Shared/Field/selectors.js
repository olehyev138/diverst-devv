import { createSelector } from 'reselect/lib';
import { initialState } from 'containers/Shared/Field/reducer';

const selectFieldsDomain = state => state.fields || initialState;

const selectPaginatedFields = () => createSelector(
  selectFieldsDomain,
  fieldsState => fieldsState.fieldList
);

/* Select field list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
const selectPaginatedSelectFields = () => createSelector(
  selectFieldsDomain,
  fieldsState => (
    Object
      .values(fieldsState.fieldList)
      .map(field => ({ value: field.id, label: field.title }))
  )
);

const selectFieldTotal = () => createSelector(
  selectFieldsDomain,
  fieldsState => fieldsState.fieldTotal
);

const selectField = () => createSelector(
  selectFieldsDomain,
  fieldsState => fieldsState.currentField
);

const selectFormField = () => createSelector(
  selectFieldsDomain,
  (fieldsState) => {
    const { currentField } = fieldsState;
    if (!currentField) return null;

    // clone field before making mutations on it
    const selectField = Object.assign({}, currentField);

    selectField.children = selectField.children.map(child => ({
      value: child.id,
      label: child.name
    }));

    return selectField;
  }
);

const selectIsLoading = () => createSelector(
  selectFieldsDomain,
  fieldsState => fieldsState.isLoading
);

const selectIsCommitting = () => createSelector(
  selectFieldsDomain,
  fieldsState => fieldsState.isCommitting
);

const selectCommitSuccess = () => createSelector(
  selectFieldsDomain,
  fieldsState => fieldsState.commitSuccess
);

const selectHasChanged = () => createSelector(
  selectFieldsDomain,
  fieldsState => fieldsState.hasChanged
);

export {
  selectFieldsDomain, selectPaginatedFields, selectPaginatedSelectFields,
  selectFieldTotal, selectField, selectFormField, selectIsLoading, selectIsCommitting,
  selectCommitSuccess, selectHasChanged
};
