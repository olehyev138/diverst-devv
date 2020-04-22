/**
 *
 *  DateField Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field } from 'formik';
import {
  TextField, Grid, IconButton, Typography
} from '@material-ui/core';


import messages from 'containers/Shared/Field/messages';
import DeleteIcon from '@material-ui/icons/Delete';

/* eslint-disable object-curly-newline */
export function DareFieldForm({ formikProps, arrayHelpers, index, fieldsName, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  const { remove } = arrayHelpers;

  return (
    <React.Fragment>
      <Grid container>
        <Grid item xs={12}>
          <Typography color='primary' variant='h6' component='h2'>
            <DiverstFormattedMessage {...messages.dateField} />
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
        </Grid>
        <Grid item xs={1}>
          <IconButton onClick={() => setFieldValue(`${fieldsName}[${index}]._destroy`, true)}>
            <DeleteIcon />
          </IconButton>
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

DareFieldForm.propTypes = {
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
)(DareFieldForm);
