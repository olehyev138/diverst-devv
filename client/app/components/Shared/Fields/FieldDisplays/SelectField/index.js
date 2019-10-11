/**
 *
 * SelectField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import dig from 'object-dig';
import { connect, Field, getIn } from 'formik';

import Select from 'components/Shared/DiverstSelect';
import { Typography } from '@material-ui/core';

const CustomSelect = (props) => {
  const { classes } = props;

  const fieldDatum = dig(props, 'fieldDatum');
  const fieldDatumIndex = dig(props, 'fieldDatumIndex');

  // allow specification of dataLocation
  const dataLocation = props.dataLocation || `fieldData.${fieldDatumIndex}.data`;

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

CustomSelect.propTypes = {
  classes: PropTypes.object,
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number,
  dataLocation: PropTypes.string,
};

export default connect(CustomSelect);
