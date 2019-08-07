/*
 * - Helpers to render custom field inputs
 * - Custom components aren't working because the way Formik works
 */

import React from 'react';
import dig from 'object-dig';

import { TextField } from '@material-ui/core';
import Select from 'react-select';
import { Field } from 'formik';

/*
 * Render a custom Formik field for use in a Formik form
 *  @field        - the field object, this contains general info about the field
 *  @fieldData    - list of 'field datums' - each is the current users specific selection of the field its associated too
 *  @formikProps  - list of props formik passes
 */
function renderFieldInput(field, fieldData, formikProps) {
  if (!field || !fieldData)
    return <React.Fragment />;

  const fieldDatumIndex = getFieldData(field, fieldData);

  if (fieldDatumIndex < 0)
    return <React.Fragment />;

  const baseProps = buildBaseProps(field, fieldData, fieldDatumIndex, formikProps);

  return (
    <React.Fragment>
      { (fieldDatumIndex >= 0)
        ? buildField(field, fieldData[fieldDatumIndex], baseProps, formikProps)
        : <React.Fragment /> }
    </React.Fragment>
  );
}

/*
 * Delegates to a specific field builder
 */
function buildField(field, fieldDatum, props, formikProps) {
  switch (dig(field, 'type')) {
    case 'TextField':
      return buildTextField(field, fieldDatum, props, formikProps);
    case 'SelectField':
      return buildSelectField(field, fieldDatum, props, formikProps);
    default:
      return buildTextField(field, fieldDatum, props, formikProps);
  }
}

/* Field Builders for each type */

function buildTextField(field, fieldDatum, props, formikProps) {
  return (
    <Field
      component={TextField}
      {...props}
    />
  );
}

function buildSelectField(field, fieldDatum, props, formikProps) {
  const options = [];
  const value = undefined;

  return (
    <Field
      component={Select}
      options={[{ value: 0, label: 'test' }, { value: 1, label: 'ugh' }]}
    />
  );
}

function buildCheckboxField(field, fieldDatum, props, formikProps) {
}

/*
 * Build base set of props common to every field type
 *  - name & id are the 'key' for formik to access the relevant data in its values hash
 *  - value is the initial value as passed from the backend
 */
function buildBaseProps(field, fieldData, fieldDatumIndex, formikProps) {
  return {
    name: `field_data.${fieldDatumIndex}.data`,
    id: `field_data.${fieldDatumIndex}.data`,
    value: fieldData[fieldDatumIndex].data,
    label: field.title,
    onChange: formikProps.handleChange
  };
}

function getFieldData(field, fieldData) {
  return fieldData.findIndex(obj => field.id === obj.field_id);
}

export default renderFieldInput;
