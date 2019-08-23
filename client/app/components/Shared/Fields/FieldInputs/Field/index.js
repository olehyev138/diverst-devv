/**
 *
 * Field
 *
 * - Acts as the 'super' component
 * - Given a field object and renders the appropriate field input
 *
 * - We use Formiks 'connect' function to hook into Formik's context
 * - This way we can build our own custom Formik fields
 */

import React from 'react';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import { TextField } from '@material-ui/core';
import CustomTextField from 'components/Shared/Fields/FieldInputs/TextField';
import CustomDateField from 'components/Shared/Fields/FieldInputs/DateField';
import CustomSelectField from 'components/Shared/Fields/FieldInputs/SelectField';

const CustomField = (props) => {
  const fieldData = dig(props, 'fieldDatum');

  const renderField = (fieldData) => {
    switch (dig(fieldData, 'field', 'type')) {
      case 'TextField':
        return (<CustomTextField {...props} inputType='' />);
      case 'NumericField':
        return (<CustomTextField {...props} inputType='number' />);
      case 'DateField':
        return (<CustomDateField {...props} />);
      case 'SelectField':
        return (<CustomSelectField {...props} />);
      default:
        return (<TextField disabled />); // looks better then rendering nothing
    }
  };

  return renderField(fieldData);
};

CustomField.propTypes = {
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number
};

export default CustomField;
