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

function deserializeOptionsText(field) {
  /* Fields with multiple 'options' store them as new line separated strings
   *  - Split them on '\n' into an array
   *  - Map array to a list of 'select' objects - [ { label: <>, value: <> ] } ... ]
   */

  const optionsText = field.options_text;

  return optionsText
    ? field.options_text
      .split('\n')
      .map(option => ({ label: option, value: option }))
    : optionsText;
}

export {
  serializeFieldData, serializeDatum,
  deserializeDatum, deserializeOptionsText
};
