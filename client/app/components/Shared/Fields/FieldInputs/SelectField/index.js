/**
 *
 * SelectField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import dig from 'object-dig';
import { connect, Field, getIn } from 'formik';

import Select from 'components/Shared/DiverstSelect';

const CustomSelectField = (props) => {
  const fieldDatum = dig(props, 'fieldDatum');
  const fieldDatumIndex = dig(props, 'fieldDatumIndex');

  // allow specification of dataLocation
  const dataLocation = props.dataLocation || `fieldData.${fieldDatumIndex}.data`;

  return (
    <Select
      name={dataLocation}
      id={dataLocation}
      fullWidth
      margin='normal'
      required={fieldDatum.field.required}
      label={fieldDatum.field.title}
      value={getIn(props.formik.values, dataLocation)}
      options={fieldDatum.field.options}
      onChange={v => props.formik.setFieldValue(dataLocation, v)}
      {...props}
    />
  );
};

CustomSelectField.propTypes = {
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  dataLocation: PropTypes.string,
  formik: PropTypes.object
};

export default connect(CustomSelectField);
