/**
 *
 * DateField
 *
 */

/* TODO: switch input to use @material-ui/pickers */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, Field, getIn } from 'formik';
import dig from 'object-dig';

import { TextField } from '@material-ui/core';

const CustomDateField = (props) => {
  const { fieldDatum, fieldDatumIndex, formik, ...rest } = props;

  const dataLocation = `fieldData.${fieldDatumIndex}.data`;

  return (
    <TextField
      name={dataLocation}
      id={dataLocation}
      type='date'
      margin='normal'
      required={fieldDatum.field.required}
      label={fieldDatum.field.title}
      value={getIn(formik.values, dataLocation)}
      onChange={formik.handleChange}
      {...rest}
    />
  );
};

CustomDateField.propTypes = {
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  formik: PropTypes.object
};

export default connect(CustomDateField);
