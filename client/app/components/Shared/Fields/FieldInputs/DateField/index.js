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

import { KeyboardDatePicker } from '@material-ui/pickers';

const CustomDateField = (props) => {
  const { fieldDatum, fieldDatumIndex, formik, ...rest } = props;
  const dataLocation = `fieldData.${fieldDatumIndex}.data`;

  return (
    <React.Fragment>
      <KeyboardDatePicker
        format='yyyy/MM/dd'
        mask='____/__/__'
        fullWidth
        name={dataLocation}
        id={dataLocation}
        margin='normal'
        required={fieldDatum.field.required}
        label={fieldDatum.field.title}
        value={getIn(formik.values, dataLocation)}
        onChange={v => formik.setFieldValue(dataLocation, v)}
        autoOk
        strictCompareDates
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
