/**
 *
 * TextField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, getIn } from 'formik';
import dig from 'object-dig';

import { TextField, Typography } from '@material-ui/core';

const CustomText = (props) => {
  const { classes } = props;

  const fieldDatum = dig(props, 'fieldDatum');
  const fieldDatumIndex = dig(props, 'fieldDatumIndex');

  const dataLocation = `fieldData.${fieldDatumIndex}.data`;

  return (
    <div>
      <Typography variant='h5' component='h2' className={classes.dataHeaders}>
        {fieldDatum.field.title}
      </Typography>
      <Typography component='h2'>
        {fieldDatum.data.value}
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

export default connect(CustomText);
