/**
 *
 * SelectField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';
import { connect, FastField, Field, getIn } from 'formik';

import Select from 'components/Shared/DiverstSelect';

const CustomSelectField = (props) => {
  const { fieldDatum, fieldDatumIndex, formik, fieldType, ...rest } = props;

  // allow specification of dataLocation
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
      component={Select}
      name={dataLocation}
      id={dataLocation}
      fullWidth
      margin='normal'
      required={fieldDatum.field.required}
      label={fieldDatum.field.title}
      value={getIn(formik.values, dataLocation)}
      options={fieldDatum.field.options}
      onChange={v => formik.setFieldValue(dataLocation, v)}
      {...rest}
    />
  );
};

CustomSelectField.propTypes = {
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  dataLocation: PropTypes.string,
  fieldType: PropTypes.oneOf(['FastField', 'Field']),
  formik: PropTypes.object
};

CustomSelectField.defaultProps = {
  fieldType: 'FastField'
};

export default connect(CustomSelectField);
