/**
 *
 *  NumericField Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Divider, Box, Grid
} from '@material-ui/core';


import messages from 'containers/Shared/Field/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import { Toggles } from 'components/Shared/Fields/FieldForms/Toggles';
import { buildValues } from 'utils/formHelpers';

/* Important constant for each field form - tells backend which field subclass to load */
const FIELD_TYPE = 'NumericField';

/* eslint-disable object-curly-newline */
export function NumericFieldFormInner(props) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, ...rest } = props;
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
          <Grid container spacing={2}>
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
              />
            </Grid>
          </Grid>
          <Toggles {...props} />
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

export function NumericFieldForm(props) {
  const initialValues = buildValues(props.field, {
    title: { default: '' },
    min: { default: '' },
    max: { default: '' },
    id: { default: '' },
    show_on_vcard: { default: true },
    alternative_layout: { default: false },
    private: { default: false },
    required: { default: false },
    add_to_member_list: { default: false },
    type: { default: FIELD_TYPE },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.fieldAction(values);
      }}
    >
      {formikProps => <NumericFieldFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

NumericFieldForm.propTypes = {
  fieldAction: PropTypes.func,
  field: PropTypes.object,
  isCommitting: PropTypes.bool,
  currentEnterprise: PropTypes.object,
};

NumericFieldFormInner.propTypes = {
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
)(NumericFieldForm);