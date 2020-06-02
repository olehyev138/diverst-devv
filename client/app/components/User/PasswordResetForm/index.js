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
import passwordResetMessages from 'containers/User/PasswordResetPage/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import FieldInputForm from 'components/Shared/Fields/FieldInputForm/Loadable';
import Scrollbar from 'components/Shared/Scrollbar';
import Container from '@material-ui/core/Container';
import Logo from 'components/Shared/Logo';
import { FormattedMessage } from 'react-intl';

/* eslint-disable object-curly-newline */
export function PasswordResetFormInner({ formikProps, buttonText, errors, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  return (
    <Scrollbar>
      <Container>
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
                  disabled
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
                  label={<DiverstFormattedMessage {...passwordResetMessages.password} />}
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
                  label={<DiverstFormattedMessage {...passwordResetMessages.passwordConfirmation} />}
                />
              </CardContent>
              <Divider />
              <CardActions>
                <DiverstSubmit isCommitting={props.isCommitting}>
                  {<FormattedMessage {...passwordResetMessages.changePassword} />}
                </DiverstSubmit>
              </CardActions>
            </Form>
          </Card>
        </DiverstFormLoader>
      </Container>
    </Scrollbar>
  );
}

export function PasswordResetForm(props) {
  const user = dig(props, 'user');

  const initialValues = buildValues(user, {
    email: { default: '' },
    password: '',
    password_confirmation: '',
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, []);
        props.submitAction({ token: props.token, ...payload });
      }}
    >
      {formikProps => <PasswordResetFormInner {...props} formikProps={formikProps} errors={props.errors} />}
    </Formik>
  );
}

PasswordResetForm.propTypes = {
  submitAction: PropTypes.func,
  user: PropTypes.object,
  isCommitting: PropTypes.bool,
  isLoading: PropTypes.bool,
  token: PropTypes.string,
  errors: PropTypes.object,
};

PasswordResetFormInner.propTypes = {
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
)(PasswordResetForm);
