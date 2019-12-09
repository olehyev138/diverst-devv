/**
 *
 * Email Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';
import { DateTime } from 'luxon';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Grid, Divider,
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/GlobalSettings/Email/Email/messages';
import { buildValues } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

/* eslint-disable object-curly-newline */
export function EmailFormInner({
  handleSubmit, handleChange, handleBlur, values, touched, errors,
  buttonText, setFieldValue, setFieldTouched, setFieldError,
  ...props
}) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={!props.email}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              onChange={handleChange}
              disabled={props.isCommitting}
              required
              fullWidth
              id='subject'
              name='subject'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.form.subject} />}
              value={values.subject}
            />
            <Field
              component={TextField}
              onChange={handleChange}
              disabled={props.isCommitting}
              required
              fullWidth
              id='content'
              name='content'
              multiline
              rows={8}
              variant='outlined'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.form.content} />}
              value={values.content}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              <DiverstFormattedMessage {...messages.form.update} />
            </DiverstSubmit>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function EmailForm(props) {
  const email = dig(props, 'email');

  const initialValues = buildValues(email, {
    subject: { default: '' },
    content: { default: '' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.emailAction(values);
      }}

      render={formikProps => <EmailFormInner {...props} {...formikProps} />}
    />
  );
}

EmailForm.propTypes = {
  edit: PropTypes.bool,
  emailAction: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

EmailFormInner.propTypes = {
  edit: PropTypes.bool,
  email: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  touched: PropTypes.object,
  errors: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  setFieldError: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    emailsIndex: PropTypes.string,
    emailEdit: PropTypes.string,
  })
};

export default compose(
  memo,
)(EmailForm);
