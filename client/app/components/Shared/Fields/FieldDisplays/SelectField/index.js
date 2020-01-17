/**
 *
 * SelectField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import dig from 'object-dig';
import Select from 'components/Shared/DiverstSelect';
import { Typography } from '@material-ui/core';

const CustomSelect = (props) => {
  const { classes } = props;

  const fieldDatum = dig(props, 'fieldDatum');
  const fieldDatumIndex = dig(props, 'fieldDatumIndex');

  return (
    <div className={classes.cell}>
      <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
        {fieldDatum.field.title}
      </Typography>
      <Typography color='secondary' component='h2' className={classes.data}>
        {fieldDatum.data.value ? fieldDatum.data.value : '(Nothing Selected)'}
      </Typography>
    </div>
  );
};

CustomSelect.propTypes = {
  classes: PropTypes.object,
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  dataLocation: PropTypes.string,
};

export default CustomSelect;
