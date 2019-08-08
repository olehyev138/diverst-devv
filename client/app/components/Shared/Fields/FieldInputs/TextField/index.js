/**
 *
 * TextField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, getIn } from 'formik';
import dig from 'object-dig';

import { TextField } from '@material-ui/core';

const CustomTextField = (props) => {
  const fieldDatum = dig(props, 'fieldDatum');
  const fieldDatumIndex = dig(props, 'fieldDatumIndex');

  const dataLocation = `fieldData.${fieldDatumIndex}.data`;

  return (
    <TextField
      name={dataLocation}
      id={dataLocation}
      type={props.inputType}
      label={fieldDatum.field.title}
      value={getIn(props.formik.values, dataLocation)}
      onChange={props.formik.handleChange}
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
