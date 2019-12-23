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
import {Field, Formik, Form, getIn} from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Divider, Box, Grid
} from '@material-ui/core';


import messages from 'containers/GlobalSettings/Field/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

/* Important constant for each field form - tells backend which field subclass to load */
const FIELD_TYPE = 'NumericField';

/* eslint-disable object-curly-newline */
export function TextFieldFormInner({ handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            onChange={value => setFieldValue('title', value.target.value)}
            fullWidth
            required
            disabled={props.isCommitting}
            id={`title:${values.id}`}
            name={`title:${values.id}`}
            value={values.title}
            label={<DiverstFormattedMessage {...messages.title} />}
          />
          <Box mb={2} />
          <Grid container>
            <Grid item xs={6} md={6}>
              <TextField
                id={`min:${values.id}`}
                name={`min:${values.id}`}
                type='number'
                fullWidth
                margin='normal'
                label={<DiverstFormattedMessage {...messages.min} />}
                value={values.min}
                onChange={value => setFieldValue('min', value.target.value)}
                {...props}
              />
            </Grid>
            <Grid item xs={6} md={6}>
              <TextField
                id={`max:${values.id}`}
                name={`max:${values.id}`}
                type='number'
                fullWidth
                margin='normal'
                label={<DiverstFormattedMessage {...messages.max} />}
                value={values.max}
                onChange={value => setFieldValue('max', value.target.value)}
                {...props}
              />
            </Grid>
          </Grid>
        </CardContent>
        <Divider />
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            {
              props.edit
                ? (<DiverstFormattedMessage {...messages.update} />)
                : (<DiverstFormattedMessage {...messages.create} />)
            }
          </DiverstSubmit>
          <Button
            onClick={props.cancelAction}
            disabled={props.isCommitting}
          >
            <DiverstFormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function TextFieldForm(props) {
  const initialValues = {
    title: dig(props, 'field', 'title') || '',
    min: dig(props, 'field', 'min') || '',
    max: dig(props, 'field', 'max') || '',
    id: dig(props, 'field', 'id') || '',
    type: FIELD_TYPE
  };

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.fieldAction(values);
      }}
    >
      {formikProps => <TextFieldFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

TextFieldForm.propTypes = {
  fieldAction: PropTypes.func,
  field: PropTypes.object,
  isCommitting: PropTypes.bool,
};

TextFieldFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  cancelAction: PropTypes.func,
  values: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  edit: PropTypes.bool,
  links: PropTypes.shape({
  })
};

export default compose(
  memo,
)(TextFieldForm);
