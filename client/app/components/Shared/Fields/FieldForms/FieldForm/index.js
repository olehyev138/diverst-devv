/**
 *
 * Field Form
 *
 * - Acts as the 'super' component
 * - Given a field object and renders the appropriate field form
 *
 */


import React from 'react';
import PropTypes from 'prop-types';

import TextFieldForm from 'components/Shared/Fields/FieldForms/TextFieldForm';

const FieldForm = ({ field }) => {
  const renderField = (field) => {
    switch (field.type) {
      case 'TextField':
        return (<TextFieldForm value={field.value} />);
      default:
        return (<React.Fragment />);
    }
  };

  return renderField(field);
};

FieldForm.propTypes = {
  value: PropTypes.string.isRequired,
};

export default FieldForm;
