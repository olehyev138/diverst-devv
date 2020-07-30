/**
 *
 * CheckboxField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import dig from 'object-dig';
import { connect, FastField, Field, getIn } from 'formik';

import Select from 'components/Shared/DiverstSelect';

const CustomCheckboxField = (props) => {
  const { fieldDatum, fieldDatumIndex, formik, ...rest } = props;

  // allow specification of dataLocation
  const dataLocation = props.dataLocation || `fieldData.${fieldDatumIndex}.data`;

  return (
    <React.Fragment>
      <FastField
        component={Select}
        name={dataLocation}
        id={dataLocation}
        isMulti
        fullWidth
        margin='normal'
        required={fieldDatum.field.required}
        label={fieldDatum.field.title}
        value={getIn(formik.values, dataLocation)}
        options={fieldDatum.field.options}
        onChange={v => formik.setFieldValue(dataLocation, v)}
        {...rest}
      />
    </React.Fragment>
  );
};

CustomCheckboxField.propTypes = {
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  dataLocation: PropTypes.string,
  formik: PropTypes.object
};

export default connect(CustomCheckboxField);
