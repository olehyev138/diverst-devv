/**
 *
 * SelectField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import dig from 'object-dig';
import { connect, Field, getIn } from 'formik';

import Select from 'react-select';

const CustomSelectField = (props) => {
  const fieldDatum = dig(props, 'fieldDatum');
  const fieldDatumIndex = dig(props, 'fieldDatumIndex');

  const dataLocation = `field_data.${fieldDatumIndex}.data`;

  return (
    <Select
      name={dataLocation}
      id={dataLocation}
      label={fieldDatum.field.title}
      value={getIn(props.formik.values, dataLocation)}
      options={fieldDatum.field.options_text}
      onChange={v => props.formik.setFieldValue(dataLocation, v)}
    />
  );
};

CustomSelectField.propTypes = {
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  formik: PropTypes.object
};

export default connect(CustomSelectField);
