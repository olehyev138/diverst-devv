/**
 *
 * TextField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import dig from 'object-dig';

import { TextField, Typography } from '@material-ui/core';

const CustomText = (props) => {
  const { classes } = props;

  const fieldDatum = dig(props, 'fieldDatum');

  return (
    <div className={classes.cell}>
      <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
        {fieldDatum.field.title}
      </Typography>
      <Typography color='secondary' component='h2' className={classes.data}>
        {fieldDatum.data ? fieldDatum.data : '(Not Entered)'}
      </Typography>
    </div>
  );
};

CustomText.propTypes = {
  classes: PropTypes.object,
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  inputType: PropTypes.string,
};

export default CustomText;
