/*
 * - Helpers to render custom field inputs
 * - Custom components aren't working because the way Formik works
 */

import React from 'react';
import dig from 'object-dig';
import { TextField } from '@material-ui/core';
import { Field } from 'formik';

function renderFieldInput(field, fieldData, formikProps) {
  if (!field || !fieldData)
    return <React.Fragment />;

  const fieldType = dig(field, 'type');
  const input = getInput(fieldType);
  const fieldDatumIndex = fieldData.findIndex(obj => field.id === obj.field_id);

  return (
    <React.Fragment>
      { (fieldDatumIndex >= 0) ? (
        <Field
          component={input}
          name={`field_data.${fieldDatumIndex}.data`}
          id={`field_data.${fieldDatumIndex}.data`}
          value={fieldData[fieldDatumIndex].data}
          label={field.title}
          onChange={formikProps.handleChange}
        />) : <React.Fragment /> }
    </React.Fragment>
  );
}

function getInput(fieldType) {
  switch (fieldType) {
    case 'TextField':
      return TextField;
  }
}

export default renderFieldInput;
