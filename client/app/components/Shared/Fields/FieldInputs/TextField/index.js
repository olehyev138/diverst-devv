/**
 *
 * TextField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

const TextField = ({ value }) => (
  <p>{value}</p>
);

TextField.propTypes = {
  value: PropTypes.string.isRequired,
};

export default TextField;
