/**
 *
 *  NumericField Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field } from 'formik';
import {
  TextField, Box, Grid, IconButton, Typography
} from '@material-ui/core';


import messages from 'containers/Shared/Field/messages';
import DeleteIcon from '@material-ui/icons/Delete';

/* eslint-disable object-curly-newline */
export function NumericFieldForm({ formikProps, arrayHelpers, index, fieldsName, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  const { remove } = arrayHelpers;

  return (
    <React.Fragment>
      <Grid container>
        <Grid item xs={12}>
          <Typography color='primary' variant='h6' component='h2'>
            <DiverstFormattedMessage {...messages.numericField} />
          </Typography>
        </Grid>
        <Grid item xs={11}>
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            required
            disabled={props.isCommitting}
            id={`${fieldsName}[${index}].title`}
            name={`${fieldsName}[${index}].title`}
            value={values[fieldsName][index].title}
            label={<DiverstFormattedMessage {...messages.title} />}
          />
          <Box mb={2} />
          <Grid container spacing={2}>
            <Grid item xs={6} md={6}>
              <TextField
                id={`${fieldsName}[${index}].min`}
                name={`${fieldsName}[${index}].min`}
                type='number'
                fullWidth
                margin='normal'
                label={<DiverstFormattedMessage {...messages.min} />}
                value={values[fieldsName][index].min}
                onChange={handleChange}
              />
            </Grid>
            <Grid item xs={6} md={6}>
              <TextField
                id={`${fieldsName}[${index}].max`}
                name={`${fieldsName}[${index}].max`}
                type='number'
                fullWidth
                margin='normal'
                label={<DiverstFormattedMessage {...messages.max} />}
                value={values[fieldsName][index].max}
                onChange={handleChange}
              />
            </Grid>
          </Grid>
        </Grid>
        <Grid item xs={1}>
          <IconButton onClick={() => remove(index)}>
            <DeleteIcon />
          </IconButton>
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

NumericFieldForm.propTypes = {
  formikProps: PropTypes.shape({
    handleSubmit: PropTypes.func,
    handleChange: PropTypes.func,
    handleBlur: PropTypes.func,
    cancelAction: PropTypes.func,
    values: PropTypes.object,
    setFieldValue: PropTypes.func,
    setFieldTouched: PropTypes.func,
  }),
  arrayHelpers: PropTypes.object,
  index: PropTypes.number,
  fieldsName: PropTypes.string,
  isCommitting: PropTypes.bool,
  edit: PropTypes.bool,
  links: PropTypes.shape({
  })
};

export default compose(
  memo,
)(NumericFieldForm);
