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
import DateFieldForm from 'components/Shared/Fields/FieldForms/DateFieldForm';

const FieldForm = ({ field, ...props }) => {
  const renderField = (field) => {
    switch (field.type) {
      case 'TextField':
        return (<TextFieldForm {...props} field={field} />);
      case 'DateField':
        return (<DateFieldForm {...props} field={field} />);
      default:
        return (<p>{field.type}</p>);
    }
  };

  return renderField(field);
};

FieldForm.propTypes = {
  field: PropTypes.object
};

export default FieldForm;
