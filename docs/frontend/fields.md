# Fields (Frontend)

## Redux

The redux code, as well as messages.js are all inside its own folder in the Shared Folder

client/app/container/Shared/Field

The important thing to note that the `container/Shared/Field/saga.js` is incomplete, and in fact **should not
be used**. It only will catch GET_FIELD_BEGIN, UPDATE_FIELD_BEGIN, DELETE_FIELD_BEGIN.

Instead of using this saga, wherever you are using Fields, you should create an additional saga file.
In this new saga file, import the saga functions from the shared folder saga file, as well define saga functions
for `create` and, `getList`. Then at the bottom take the latest as usual.

As an example, the saga file `containers/GlobalSettings/Field/saga.js`, would look something like:
```javascript
import {
  getField, updateField, deleteField,
} from 'containers/Shared/Field/saga';

export function* getFields(action) {
  try {
    const { enterpriseId, ...rest } = action.payload;
    const response = yield call(api.enterprises.fields.bind(api.enterprises), enterpriseId, rest);
    yield put(getFieldsSuccess(response.data.page));
  } catch (err) {
    yield put(getFieldsError(err));
    yield put(showSnackbar({ message: 'Failed to load fields', options: { variant: 'warning' } }));
  }
}

export function* createField(action) {
  try {
    const { enterpriseId, ...rest } = action.payload;
    const payload = { field: rest };
    const response = yield call(api.enterprises.createFields.bind(api.enterprises), enterpriseId, payload);
    yield put(createFieldSuccess());
    yield put(showSnackbar({ message: 'Field created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createFieldError(err));
    yield put(showSnackbar({ message: 'Failed to create field', options: { variant: 'warning' } }));
  }
}

export default function* fieldsSaga() {
  yield takeLatest(GET_FIELDS_BEGIN, getFields);
  yield takeLatest(GET_FIELD_BEGIN, getField);
  yield takeLatest(CREATE_FIELD_BEGIN, createField);
  yield takeLatest(UPDATE_FIELD_BEGIN, updateField);
  yield takeLatest(DELETE_FIELD_BEGIN, deleteField);
}
```

The benefit of this, is that the components need not know anything who is the field's `field_definer` when calling actions.
They can just call the same action regardless, and it is the burden of the container to inject the proper saga.

Also, cuts down on reuse of code

## Components

All the Field Components are in `client/app/components/Shared/Fields

In this folder, there are 5 sub-directories all for the different types of components one would need

- `FieldDisplays`
    - Used for displaying the value of a `FieldData` object
- `FieldForms`
    - Used for the forms to create a new `Field`
- `FieldIndexItem`
    - Displays a `Field` with an edit form
- `FieldInputs`
    - To created an input form for `FieldData`
- `FieldList`
    - To display a Paginated List of `FieldIndexItems` with buttons to create
    
You may also notice that `FieldDisplays`, `FieldForms`, `FieldInputs`, all have components for each type of field,
however, all you need to concern yourself with is
- `FieldDisplays/Field`
- `FieldForms/FieldForm`
- `FieldInputs/Field`

as these will automatically render the component depending on the field's type.

### Props

- FieldDisplays/Field
    - `fieldDatum` : The field_data object to display
    - `fieldDatumIndex`: The array index the field_data
- FieldForms/FieldForm
    - `edit`: `True`: is editing a field, `False`: is creating a field
    - `field`: The field object to edit (if you are editing)
    - `fieldAction`: The action the submit button will perform 
    - `cancelAction`: The action the cancel button will perform
    - `isCommiting`: Boolean, is the field in the process of submitting to the API
- FieldIndexItem
    - `updateFieldBegin`: The updateFieldBegin Action
    - `deleteFieldBegin`: The deleteFieldBegin Action
    - `field`: The field object to show
    - `key`: The array index the field
- FieldInputs/Field
    - `fieldDatum`: The field_data object to edit
    - `fieldDatumIndex`: The array index the field_data
    - `disabled`: Disable the input (while committing)
- FieldList
    - `fields`: The array of fields being listed
    - `fieldTotal`: The total number of fields in the database
    - `isLoading`: Boolean: the fields are in the process of being loaded
    - `createFieldBegin`: **!!!** The action used to create a field
    - `updateFieldBegin`: The update field action
    - `deleteFieldBegin`: The delete field action
    - `handlePagination`: A function to handle paging
    - `isCommitting`: Boolean: a Field is in the process of Committing
    - `commitSuccess`: Boolean: Signals that a Commit was successful
    - `currentEnterprise`: (deprecated): The current enterprise object
    - `textField`: Boolean: show create text field button?
    - `selectField`: Boolean: show create select field button?
    - `checkboxField`: Boolean: show checkbox text field button?
    - `dateField`: Boolean: show create date field button?
    - `numberField` Boolean: show create number field button?
    
**!!! Don't Use the raw creatFieldBegin action, as Field Form will not be able to pass,
the field definer's id**.

Instead, create a new function like so:
```javascript
createFieldBegin={payload => props.createFieldBegin(
  {
    ...payload,
    fieldDefinerId: dig(props, 'currentEnterprise', 'id')
  }
)}
```
    
    