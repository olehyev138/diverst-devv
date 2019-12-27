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
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Divider
} from '@material-ui/core';


import messages from 'containers/Shared/Field/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

/* Important constant for each field form - tells backend which field subclass to load */
const FIELD_TYPE = 'DateField';

/* eslint-disable object-curly-newline */
export function DareFieldFormInner({ handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, ...props }) {
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

export function DareFieldForm(props) {
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
        props.fieldAction({ ...values, enterpriseId: props.currentEnterprise.id });
      }}
    >
      {formikProps => <DareFieldFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

DareFieldForm.propTypes = {
  fieldAction: PropTypes.func,
  field: PropTypes.object,
  isCommitting: PropTypes.bool,
  currentEnterprise: PropTypes.object,
};

DareFieldFormInner.propTypes = {
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
)(DareFieldForm);
