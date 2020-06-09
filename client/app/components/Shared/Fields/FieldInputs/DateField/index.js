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
import { DiverstDatePicker } from 'components/Shared/Pickers/DiverstDatePicker';

const CustomDateField = (props) => {
  const { fieldDatum, fieldDatumIndex, formik, ...rest } = props;
  const dataLocation = `fieldData.${fieldDatumIndex}.data`;

  console.log('Hello');

  return (
    <React.Fragment>
      <Field
        component={DiverstDatePicker}
        keyboardMode
        fullWidth
        name={dataLocation}
        id={dataLocation}
        margin='normal'
        required={fieldDatum.field.required}
        label={fieldDatum.field.title}
        value={getIn(formik.values, dataLocation)}
        {...rest}
      />
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
    </React.Fragment>
  );
};

CustomDateField.propTypes = {
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  formik: PropTypes.object
};

export default connect(CustomDateField);
