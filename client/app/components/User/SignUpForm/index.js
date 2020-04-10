/**
 *
 * User Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form, ErrorMessage } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField,
  Divider, Typography, Box
} from '@material-ui/core';

import Select from 'components/Shared/DiverstSelect';
import messages from 'containers/User/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import FieldInputForm from 'components/Shared/Fields/FieldInputForm/Loadable';
import Scrollbar from 'components/Shared/Scrollbar';

/* eslint-disable object-curly-newline */
export function SignUpFormInner({ formikProps, buttonText, errors, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  return (
    <Scrollbar>
      <DiverstFormLoader isLoading={props.isLoading} isError={!props.user}>
        <Card>
          <Form>
            <CardContent>
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                required
                disabled={props.isCommitting}
                margin='normal'
                id='email'
                name='email'
                value={values.email}
                label={<DiverstFormattedMessage {...messages.email} />}
              />
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                required
                disabled={props.isCommitting}
                margin='normal'
                id='password'
                name='password'
                value={values.password}
                label='Password'
              />
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                required
                disabled={props.isCommitting}
                margin='normal'
                id='password_confirmation'
                name='password_confirmation'
                value={values.password_confirmation}
                label='Password Confirmation'
              />
              <Box mb={1} />
              <Divider />
              <Box mb={1} />
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                required
                disabled={props.isCommitting}
                margin='normal'
                id='first_name'
                name='first_name'
                value={values.first_name}
                label={<DiverstFormattedMessage {...messages.first_name} />}
              />
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                required
                disabled={props.isCommitting}
                margin='normal'
                id='last_name'
                name='last_name'
                value={values.last_name}
                label={<DiverstFormattedMessage {...messages.last_name} />}
              />
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                disabled={props.isCommitting}
                margin='normal'
                multiline
                rows={4}
                variant='outlined'
                id='biography'
                name='biography'
                value={values.biography}
                label={<DiverstFormattedMessage {...messages.biography} />}
              />
              <Field
                component={Select}
                fullWidth
                disabled={props.isCommitting}
                id='time_zone'
                name='time_zone'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.time_zone} />}
                value={values.time_zone}
                options={dig(props, 'user', 'timezones') || []}
                onChange={value => setFieldValue('time_zone', value)}
                onBlur={() => setFieldTouched('time_zone', true)}
              />
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                {buttonText}
              </DiverstSubmit>
            </CardActions>
          </Form>
        </Card>
      </DiverstFormLoader>
    </Scrollbar>
  );
}

export function SignUpForm(props) {
  const user = dig(props, 'user');

  const initialValues = buildValues(user, {
    email: { default: '' },
    first_name: { default: '' },
    last_name: { default: '' },
    biography: { default: '' },
    time_zone: { default: null },
    password: '',
    password_confirmation: '',
    field_data: { default: [], customKey: 'fieldData' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, ['time_zone']);
        props.submitAction({token: props.token, ...payload});
      }}
    >
      {formikProps => <SignUpFormInner {...props} formikProps={formikProps} errors={props.errors} />}
    </Formik>
  );
}

SignUpForm.propTypes = {
  submitAction: PropTypes.func,
  user: PropTypes.object,
  isCommitting: PropTypes.bool,
  isLoading: PropTypes.bool,
  token: PropTypes.string,
  errors: PropTypes.object,
};

SignUpFormInner.propTypes = {
  formikProps: PropTypes.object,
  errors: PropTypes.object,
  user: PropTypes.object,
  buttonText: PropTypes.string,
  isCommitting: PropTypes.bool,
  isLoading: PropTypes.bool,
  links: PropTypes.shape({
    usersIndex: PropTypes.string,
    usersPath: PropTypes.func,
  })
};

export default compose(
  memo,
)(SignUpForm);
