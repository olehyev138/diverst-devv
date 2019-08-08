/*
 * - Helpers to render custom field inputs
 * - Custom components aren't working because the way Formik works
 */

/* eslint-disable react/prop-types */

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
function renderFieldInput(fieldDatum, fieldDatumIndex, formikProps) {
  if (!fieldDatum)
    return <React.Fragment />;

  const baseProps = buildBaseProps(fieldDatum, fieldDatumIndex, formikProps);

  return (
    <React.Fragment>
      {buildField(fieldDatum, baseProps, formikProps)}
    </React.Fragment>
  );
}

/*
 * Delegates to a specific field builder
 */
function buildField(fieldDatum, props, formikProps) {
  switch (dig(fieldDatum, 'field', 'type')) {
    case 'TextField':
      return buildTextField(fieldDatum, props, formikProps);
    case 'SelectField':
      return buildSelectField(fieldDatum, props, formikProps);
    default:
      return buildTextField(fieldDatum, props, formikProps);
  }
}

/* Field Builders for each type */

function buildTextField(fieldDatum, props, formikProps) {
  return (
    <Field
      component={TextField}
      {...props}
    />
  );
}

function buildSelectField(fieldDatum, props, formikProps) {
  return (
    <Field
      fullWidth
      component={Select}
      name={props.name}
      id={props.id}
      value={props.value}
      options={fieldDatum.field.options_text}
      onChange={v => formikProps.setFieldValue(props.name, v)}
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
function buildBaseProps(fieldDatum, fieldDatumIndex, formikProps) {
  console.log(formikProps.values.field_data[fieldDatumIndex].data);

  return {
    name: `field_data.${fieldDatumIndex}.data`,
    id: `field_data.${fieldDatumIndex}.data`,
    value: formikProps.values.field_data[fieldDatumIndex].data,
    label: fieldDatum.field.title,
    onChange: formikProps.handleChange
  };
}

function getFieldData(field, fieldData) {
  return fieldData.findIndex(obj => field.id === obj.field_id);
}

export default renderFieldInput;
