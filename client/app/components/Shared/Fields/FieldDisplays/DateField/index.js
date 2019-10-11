/**fieldDatum={fieldDatum} fieldDatumIndex={i}
 *
 * DateField
 *
 */

/* TODO: switch input to use @material-ui/pickers */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, getIn } from 'formik';
import dig from 'object-dig';

import { TextField, Typography } from '@material-ui/core';

const CustomDate = (props) => {
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

export default connect(CustomDate);
