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

import TextFieldForm from 'components/Shared/Fields/FieldSubForms/TextFieldForm';
import DateFieldForm from 'components/Shared/Fields/FieldSubForms/DateFieldForm';
import SelectFieldForm from 'components/Shared/Fields/FieldSubForms/SelectFieldForm';
import CheckboxFieldForm from 'components/Shared/Fields/FieldSubForms/CheckboxFieldForm';
import NumericFieldForm from 'components/Shared/Fields/FieldSubForms/NumericFieldForm';

const FieldForm = ({ field, ...props }) => {
  const renderField = (field) => {
    switch (field.type) {
      case 'TextField':
        return (<TextFieldForm {...props} field={field} />);
      case 'DateField':
        return (<DateFieldForm {...props} field={field} />);
      case 'SelectField':
        return (<SelectFieldForm {...props} field={field} />);
      case 'CheckboxField':
        return (<CheckboxFieldForm {...props} field={field} />);
      case 'NumericField':
        return (<NumericFieldForm {...props} field={field} />);
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
