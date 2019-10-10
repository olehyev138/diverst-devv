/**
 *
 *  TextField Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Divider
} from '@material-ui/core';


import messages from 'containers/GlobalSettings/Field/messages';

/* Important constant for each field form - tells backend which field subclass to load */
const FIELD_TYPE = 'TextField';

/* eslint-disable object-curly-newline */
export function TextFieldFormInner({ handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='title'
            name='title'
            value={values.title}
            label={<DiverstFormattedMessage {...messages.title} />}
          />
        </CardContent>
        <Divider />
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            Submit
          </Button>
          <Button
            onClick={props.cancelAction}
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

      render={formikProps => <TextFieldFormInner {...props} {...formikProps} />}
    />
  );
}

TextFieldForm.propTypes = {
  fieldAction: PropTypes.func,
  field: PropTypes.object,
};

TextFieldFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  cancelAction: PropTypes.func,
  values: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  links: PropTypes.shape({
  })
};

export default compose(
  memo,
)(TextFieldForm);
