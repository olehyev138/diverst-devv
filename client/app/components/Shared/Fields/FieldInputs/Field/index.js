/**
 *
 * Field
 *
 * - Acts as the 'super' component
 * - Given a field object and renders the appropriate field input
 */

import React from 'react';
import PropTypes from 'prop-types';

import TextField from 'components/Shared/Fields/FieldInputs/TextField';

const Field = ({ field }) => {
  const renderField = (field) => {
    switch (field.type) {
      case 'TextField':
        return (<TextField value={field.value} />);
      default:
        return (<React.Fragment />);
    }
  };

  return renderField(field);
};

Field.propTypes = {
  field: PropTypes.object.isRequired
};

export default Field;
