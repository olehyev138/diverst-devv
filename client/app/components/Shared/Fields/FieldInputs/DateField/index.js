/**
 *
 * DateField
 *
 */

/* TODO: switch input to use @material-ui/pickers */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, FastField, Field, getIn } from 'formik';
import dig from 'object-dig';

import { KeyboardDatePicker } from '@material-ui/pickers';

const CustomDateField = (props) => {
  const { fieldDatum, fieldDatumIndex, formik, dataLocation: oldDataLocation, fieldType, ...rest } = props;
  const dataLocation = oldDataLocation || `fieldData.${fieldDatumIndex}.data`;

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
    <React.Fragment>
      <UsedField
        component={KeyboardDatePicker}
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
  dataLocation: PropTypes.string,
  fieldType: PropTypes.oneOf(['FastField', 'Field']),
  formik: PropTypes.object
};

CustomDateField.defaultProps = {
  fieldType: 'FastField'
};

export default connect(CustomDateField);
