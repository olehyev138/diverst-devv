/**
 *
 *  CheckboxField Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field } from 'formik';
import {
  IconButton, TextField, Box, Grid, Typography,
} from '@material-ui/core';

import DeleteIcon from '@material-ui/icons/Delete';
import messages from 'containers/Shared/Field/messages';

/* eslint-disable object-curly-newline */
export function CheckboxFieldForm({ formikProps, arrayHelpers, index, fieldsName, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  const { remove } = arrayHelpers;

  // `(.*):\$\{values.id\}`
  // `\$\{fieldsName\}[\$\{index\}].$1`

  return (
    <React.Fragment>
      <Grid container>
        <Grid item xs={12}>
          <Typography color='primary' variant='h6' component='h2'>
            <DiverstFormattedMessage {...messages.checkBoxField} />
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
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            multiline
            rows={3}
            variant='outlined'
            disabled={props.isCommitting}
            id={`${fieldsName}[${index}].options_text`}
            name={`${fieldsName}[${index}].options_text`}
            value={values[fieldsName][index].options_text}
            label={<DiverstFormattedMessage {...messages.options} />}
          />
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

CheckboxFieldForm.propTypes = {
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
)(CheckboxFieldForm);
