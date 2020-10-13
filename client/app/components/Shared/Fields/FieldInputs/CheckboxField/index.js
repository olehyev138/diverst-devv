/**
 *
 * CheckboxField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';
import { connect, FastField, Field, getIn } from 'formik';

import Select from 'components/Shared/DiverstSelect';

const CustomCheckboxField = (props) => {
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
    <React.Fragment>
      <UsedField
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
        isClearable
        {...rest}
      />
    </React.Fragment>
  );
};

CustomCheckboxField.propTypes = {
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  dataLocation: PropTypes.string,
  fieldType: PropTypes.oneOf(['FastField', 'Field']),
  formik: PropTypes.object
};

CustomCheckboxField.defaultProps = {
  fieldType: 'FastField'
};

export default connect(CustomCheckboxField);
