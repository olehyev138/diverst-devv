/**
 *
 * DateField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, getIn } from 'formik';
import dig from 'object-dig';

import { TextField, Typography } from '@material-ui/core';

const CustomDate = (props) => {
  const { classes } = props;

  const fieldDatum = dig(props, 'fieldDatum');
  const fieldDatumIndex = dig(props, 'fieldDatumIndex');

  return (
    <div className={classes.cell}>
      <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
        {fieldDatum.field.title}
      </Typography>
      <Typography color='secondary' component='h2' className={classes.data}>
        {fieldDatum.data}
      </Typography>
    </div>
  );
};

CustomDate.propTypes = {
  classes: PropTypes.object,
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
};

export default CustomDate;
