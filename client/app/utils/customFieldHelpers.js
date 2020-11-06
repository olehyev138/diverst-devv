/*
 * - Helpers to render custom field inputs
 *
 */


/* eslint-disable react/prop-types, no-underscore-dangle */

import React from 'react';

import { DateTime } from 'luxon';
import produce from 'immer';

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
  const type = fieldDatum?.field?.type;

  if (datum == null)
    return null;

  switch (type) {
    case 'CheckboxField':
      if (datum.length === 0)
        return '[]';
      if (typeof datum[0] === 'object')
        return JSON.stringify(datum.map(i => i.value));
      return JSON.stringify(datum);
    case 'SelectField':
      return datum.value ? JSON.stringify([datum.value]) : null;
    case 'DateField':
      return JSON.stringify(datum);
    default:
      return datum;
  }
}

const dateMap = {};

function deserializeDatum(fieldDatum) {
  try {
    const datum = fieldDatum.data;
    const type = fieldDatum?.field?.type;
    const parsed = ['CheckboxField', 'SelectField', 'DateField'].includes(type) ? datum && JSON.parse(datum) : datum;
    switch (type) {
      case 'CheckboxField':
        // Seeds seem to be malformed. This is a safety net
        if (parsed instanceof Array)
          return parsed.map(i => ({ label: i, value: i }));
        if (parsed != null)
          return [{ label: parsed, value: parsed }];
        return [];
      case 'SelectField':
        /* Certain fields have there data json serialized as a single item array  */
        return { label: (parsed || [])[0], value: (parsed || [])[0] };
      case 'DateField':
        if (typeof parsed === 'string')
          return parsed.split('T')[0];
        if (typeof parsed === 'number')
          return DateTime.fromSeconds(parsed).toISO().split('T')[0];
        return null;
      default:
        return datum || '';
    }
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error(`Can't deserialize "${fieldDatum.data}" of type ${fieldDatum?.field?.type}`);
    // eslint-disable-next-line no-console
    console.error(error);
    return fieldDatum.data || '';
  }
}

// maps each field to transform select/checkbox field options to an array compatible with the Select Field
function mapFieldData(fieldData) {
  return fieldData.map(fieldDatum => produce(fieldDatum, (draft) => {
    draft.field = splitOptions(fieldDatum.field);
    draft.data = deserializeDatum(fieldDatum);
  }));
}

// Takes fields and transforms the options texts in the form of ("Option1\nOption2\nOption3\n")
// and turns it into an array of select field options [{label: "Option1", value: "Option1"}, ...]
function splitOptions(field) {
  return produce(field, (draft) => {
    draft.options = field.options_text
      ? field.options_text.split('\n').filter(o => o && o.length).map(o => ({ value: o, label: o }))
      : null;
  });
}

function deserializeOptionsText(field) {
  /* Fields with multiple 'options' store them as new line separated strings
   *  - Split them on '\n' into an array
   *  - Map array to a list of 'select' objects - [ { label: <>, value: <> ] } ... ]
   */
  return field.options_text
    ? field.options_text.split('\n').filter(o => o && o.length).map(o => ({ value: o, label: o }))
    : null;
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
    data: serializeDatum(r),
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
  serializeSegment, splitOptions, mapFieldData,
  serializeFieldDataWithFieldId
};
