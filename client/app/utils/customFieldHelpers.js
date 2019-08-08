/*
 * - Helpers to render custom field inputs
 *
 *****************************************************************************************
 * NOTE:
 *   - renderFieldInput, buildFieldInput & sub functions are not being used
 *****************************************************************************************
 */


/* eslint-disable react/prop-types */

import React from 'react';
import dig from 'object-dig';

import { TextField } from '@material-ui/core';
import Select from 'react-select';
import { Field } from 'formik';

/*
 * Render a custom Formik field for use in a Formik form
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

function serializeFieldData(fieldData) {
  const serializedFieldData = [];

  fieldData.forEach((fieldDatum) => {
    serializedFieldData.push({
      id: fieldDatum.id,
      data: serializeDatum(fieldDatum)
    });
  });

  return serializedFieldData;
}

function serializeDatum(fieldDatum) {
  const datum = fieldDatum.data;
  const type = dig(fieldDatum, 'field', 'type');

  switch (type) {
    case 'CheckBoxField':
    case 'SelectField':
      return JSON.stringify([datum.value]);
    case 'DateField':
      return JSON.stringify(datum);
    default:
      return datum;
  }
}

function deserializeDatum(fieldDatum) {
  const datum = fieldDatum.data;
  const type = dig(fieldDatum, 'field', 'type');

  switch (type) {
    case 'CheckBoxField':
    case 'SelectField':
      /* Certain fields have there data json serialized as a single item array  */
      return { label: JSON.parse(datum)[0], value: JSON.parse(datum)[0] };
    case 'DateField':
      /* TODO: change this to use Moment.js */
      return new Date(JSON.parse(datum)).toISOString().split('T')[0];
    default:
      return datum;
  }
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
  serializeFieldData, serializeDatum,
  deserializeDatum, deserializeOptionsText
};
