/**
 *
 * TextField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, FastField, getIn } from 'formik';
import dig from 'object-dig';

import { TextField } from '@material-ui/core';

const CustomTextField = (props) => {
  const { inputType, fieldDatum, fieldDatumIndex, formik, ...rest } = props;
  const dataLocation = `fieldData.${fieldDatumIndex}.data`;

  return (
    <FastField
      component={TextField}
      required={fieldDatum.field.required}
      name={dataLocation}
      id={dataLocation}
      type={inputType}
      fullWidth
      margin='normal'
      label={fieldDatum.field.title}
      value={getIn(formik.values, dataLocation)}
      onChange={formik.handleChange}
      {...rest}
    />
  );
};

CustomTextField.propTypes = {
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  inputType: PropTypes.string,
  formik: PropTypes.object
};

export default connect(CustomTextField);
