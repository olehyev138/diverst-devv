/**
 *
 * TextFieldForm
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

const TextFieldForm = ({ value }) => (
  <p>{value}</p>
);

TextFieldForm.propTypes = {
  value: PropTypes.string.isRequired,
};

export default TextFieldForm;
