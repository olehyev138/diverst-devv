/**
 *
 * Field
 *
 * - Renders a custom field
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import TextField from 'components/Shared/Fields/TextField';
import { render } from 'react-testing-library';

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
  value: PropTypes.string.isRequired,
};

export default TextField;
