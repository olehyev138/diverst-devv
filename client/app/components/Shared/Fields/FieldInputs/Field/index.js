/**
 *
 * Field
 *
 * - Acts as the 'super' component
 * - Given a field object and renders the appropriate field input
 */

import React from 'react';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import CustomTextField from 'components/Shared/Fields/FieldInputs/TextField';

const CustomField = (props) => {
  const fieldData = dig(props, 'fieldData');

  const renderField = (fieldData) => {
    switch (dig(fieldData, 'field', 'type')) {
      case 'TextField':
        return (<CustomTextField fieldData={fieldData} />);
      default:
        return (<React.Fragment />);
    }
  };

  return renderField(fieldData);
};

CustomField.propTypes = {
  fieldData: PropTypes.object,
  field: PropTypes.object
};

export default CustomField;
