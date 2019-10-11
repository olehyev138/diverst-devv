/**
 *
 * CheckboxField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import dig from 'object-dig';
import { connect, Field, getIn } from 'formik';

import Select from 'components/Shared/DiverstSelect';

const CustomCheckboxField = (props) => {
  const fieldDatum = dig(props, 'fieldDatum');
  const fieldDatumIndex = dig(props, 'fieldDatumIndex');

  // allow specification of dataLocation
  const dataLocation = props.dataLocation || `fieldData.${fieldDatumIndex}.data`;

  return (
    <div>
      <Select
        name={dataLocation}
        id={dataLocation}
        isMulti
        fullWidth
        margin='normal'
        label={fieldDatum.field.title}
        value={getIn(props.formik.values, dataLocation)}
        options={fieldDatum.field.options_text}
        onChange={v => props.formik.setFieldValue(dataLocation, v)}
      />
    </div>
  );
};

CustomCheckboxField.propTypes = {
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  dataLocation: PropTypes.string,
  formik: PropTypes.object
};

export default connect(CustomCheckboxField);
