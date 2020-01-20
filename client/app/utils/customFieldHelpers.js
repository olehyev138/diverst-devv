/*
 * - Helpers to render custom field inputs
 *
 */


/* eslint-disable react/prop-types, no-underscore-dangle */

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

function serializeFieldDataWithFieldId(fieldData) {
  const serializedFieldData = [];

  fieldData.forEach((fieldDatum) => {
    serializedFieldData.push({
      id: fieldDatum.id,
      data: serializeDatum(fieldDatum),
      field_id: fieldDatum.field_id
    });
  });

  return serializedFieldData;
}

function serializeDatum(fieldDatum) {
  const datum = fieldDatum.data;
  const type = dig(fieldDatum, 'field', 'type');

  switch (type) {
    case 'CheckboxField':
      if (datum.lenght === 0)
        return '[]';
      if (typeof datum[0] === 'object')
        return JSON.stringify(datum.map(i => i.value));
      return JSON.stringify(datum);
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
    case 'CheckboxField':
      return JSON.parse(datum).map(i => ({ label: i, value: i }));
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

function serializeSegment(segment) {
  const serializedSegment = { ...segment };

  // TODO: switch to immer

  // serialize field rules
  // pluck out attributes we want - (should use spread op)
  serializedSegment.field_rules_attributes = serializedSegment.field_rules_attributes.map(r => ({
    id: r.id,
    field_id: r.field_id,
    segment_id: r.segment_id,
    operator: r.operator,
    data: JSON.stringify([r.data.value]), // TODO: change this to multi
    _destroy: r._destroy || 0
  }));

  // serialize group rules
  // pluck out attributes we want
  // map each groups rules array of groups to an array of group ids
  serializedSegment.group_rules_attributes = serializedSegment.group_rules_attributes.map(r => ({
    id: r.id,
    operator: r.operator,
    group_ids: r.group_ids.map(g => g.value),
    _destroy: r._destroy || 0
  }));

  return serializedSegment;
}

export {
  serializeFieldData, serializeDatum,
  deserializeDatum, deserializeOptionsText,
  serializeSegment,
  serializeFieldDataWithFieldId
};
