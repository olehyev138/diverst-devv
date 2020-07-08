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
import signUpMessages from 'containers/User/SignUpPage/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import FieldInputForm from 'components/Shared/Fields/FieldInputForm/Loadable';
import Scrollbar from 'components/Shared/Scrollbar';
import Container from '@material-ui/core/Container';
import Logo from 'components/Shared/Logo';
import { FormattedMessage } from 'react-intl';
import LargeSponsorCard from 'components/Branding/Sponsor/SponsorCard/large';

/* eslint-disable object-curly-newline */
export function SignUpFormInner({ formikProps, buttonText, errors, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  const { user, groups, enterprise, ...rest } = props;

  return (
    <Scrollbar>
      <Container>
        { enterprise.sponsors.length > 0 && (
          <React.Fragment>
            <LargeSponsorCard
              sponsor={enterprise.sponsors[0]}
              single
              noAsync
            />
            <Box mb={2} />
          </React.Fragment>
        )}
        <DiverstFormLoader isLoading={props.isLoading} isError={!props.user}>
          <Card>
            <Form>
              <CardContent>
                <Logo coloredDefault maxHeight='60px' />
                <Box pb={2} />
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
                  InputProps={{
                    readOnly: true,
                  }}
                />
                <Field
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  required
                  type='password'
                  disabled={props.isCommitting}
                  margin='normal'
                  id='password'
                  name='password'
                  value={values.password}
                  label={<DiverstFormattedMessage {...signUpMessages.password} />}
                />
                <Field
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  required
                  type='password'
                  disabled={props.isCommitting}
                  margin='normal'
                  id='password_confirmation'
                  name='password_confirmation'
                  value={values.password_confirmation}
                  label={<DiverstFormattedMessage {...signUpMessages.passwordConfirmation} />}
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
                  {<FormattedMessage {...signUpMessages.activate} />}
                </DiverstSubmit>
              </CardActions>
            </Form>
          </Card>
        </DiverstFormLoader>
      </Container>
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
    field_data: { default: [], customKey: 'fieldData' },
    group_ids: { default: [] },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, ['time_zone']);
        props.submitAction({ token: props.token, ...payload });
      }}
    >
      {formikProps => <SignUpFormInner {...props} formikProps={formikProps} errors={props.errors} />}
    </Formik>
  );
}

SignUpForm.propTypes = {
  submitAction: PropTypes.func,
  user: PropTypes.object,
  groups: PropTypes.arrayOf(PropTypes.object),
  enterprise: PropTypes.object,
  isCommitting: PropTypes.bool,
  isLoading: PropTypes.bool,
  token: PropTypes.string,
  buttonText: PropTypes.string,
  errors: PropTypes.object,
  links: PropTypes.shape({
    usersIndex: PropTypes.string,
    usersPath: PropTypes.func,
  })
};

SignUpFormInner.propTypes = {
  ...SignUpForm.propTypes,
  formikProps: PropTypes.object,
};

export default compose(
  memo,
)(SignUpForm);
