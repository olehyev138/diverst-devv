/**
 *
 * TextField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import { TextField } from '@material-ui/core';
import dig from 'object-dig';

const CustomTextField = (props) => {
  const fieldData = dig(props, 'fieldData');

  return (
    <TextField
      id={fieldData.field.title}
      name={fieldData.field.title}
      label={fieldData.field.title}
      value={fieldData.data}
    />
  );
};

CustomTextField.propTypes = {
  fieldData: PropTypes.object,
};

export default CustomTextField;
