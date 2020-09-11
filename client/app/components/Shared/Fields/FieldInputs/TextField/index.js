/**
 *
 * TextField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, FastField, Field, getIn } from 'formik';
import dig from 'object-dig';

import { TextField } from '@material-ui/core';

const CustomTextField = (props) => {
  const { inputType, fieldDatum, fieldDatumIndex, formik, fieldType, ...rest } = props;
  const dataLocation = props.dataLocation || `fieldData.${fieldDatumIndex}.data`;

  const UsedField = ((type) => {
    switch (type) {
      case 'FastField':
        return FastField;
      case 'Field':
        return Field;
      default:
        // eslint-disable-next-line no-console
        console.error('Invalid Field Type');
        return Field;
    }
  })(fieldType);

  return (
    <UsedField
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
  dataLocation: PropTypes.string,
  fieldType: PropTypes.oneOf(['FastField', 'Field']),
  formik: PropTypes.object
};

CustomTextField.defaultProps = {
  fieldType: 'FastField'
};

export default connect(CustomTextField);
