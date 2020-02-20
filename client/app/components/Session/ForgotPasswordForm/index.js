/**
 *
 * ForgotPasswordForm
 *
 */

import React, { memo, useEffect, useRef } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { FormattedMessage } from 'react-intl';

import { Field, Formik, Form } from 'formik';
import * as Yup from 'yup';

import { withStyles } from '@material-ui/core/styles';
import withWidth from '@material-ui/core/withWidth';

import { Button, Card, CardActions, CardContent, Grid, TextField, Hidden, Box } from '@material-ui/core';

import messages from 'containers/Session/LoginPage/messages';

import Logo from 'components/Shared/Logo';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { ROUTES } from 'containers/Shared/Routes/constants';

const styles = theme => ({
  card: {
    width: '100%',
    borderColor: theme.palette.primary.main,
  },
  cardContent: {
    textAlign: 'center',
  },
  cardActions: {
    paddingTop: 4,
    paddingLeft: 16,
    paddingRight: 16,
    paddingBottom: 16,
  },
  submitButtonLabel: {
    minWidth: 'max-content',
  },
});

/* eslint-disable indent, object-curly-newline */
export function ForgotPasswordFormInner({
 handleSubmit, handleChange, handleBlur, errors,
 touched, values, classes, width, ...rest
}) {
  return (
    <Box boxShadow={4} borderRadius={4} width='80%'>
      <Card raised className={classes.card} variant='outlined'>
        <Form noValidate>
          <CardContent className={classes.cardContent}>
            <Logo coloredDefault maxHeight='60px' />
            <Box pb={2} />
            <Field
              component={TextField}
              onChange={handleChange}
              onBlur={handleBlur}
              value={values.email}
              autoFocus={!values.email}
              fullWidth
              disabled={rest.isLoggingIn}
              variant='outlined'
              id='email'
              name='email'
              type='email'
              label={<FormattedMessage {...messages.email} />}
              margin='none'
              autoComplete='off'
              error={errors.email && touched.email}
              helperText={errors.email && touched.email ? errors.email : null}
            />
          </CardContent>
          <CardActions className={classes.cardActions}>
            <Grid container spacing={2} alignItems='center'>
              <Grid item xs={false} sm={3} />
              <Grid item align='center' xs={12} sm={6}>
                <Button
                  classes={{
                    label: classes.submitButtonLabel
                  }}
                  type='submit'
                  color='primary'
                  size='large'
                  disabled={!values.email || !values.password || rest.isLoggingIn}
                  variant='contained'
                >
                  Reset Password
                </Button>
              </Grid>
              <Grid item align={width === 'xs' ? 'center' : 'right'} xs={12} sm={3}>
                <Button
                  component={WrappedNavLink}
                  to={ROUTES.session.login.path()}
                  color='primary'
                  size='small'
                  variant='text'
                  disabled={rest.isLoggingIn}
                >
                  {<FormattedMessage {...messages.login} />}
                </Button>
              </Grid>
            </Grid>
          </CardActions>
        </Form>
      </Card>
    </Box>
  );
}

function ForgotPasswordForm(props, context) {
  const { classes, width } = props;
  const { intl } = context;

  const ForgotPasswordFormSchema = Yup.object().shape({
    email: Yup
      .string()
      .email(intl.formatMessage(messages.invalidEmail)),
  });

  return (
    <Formik
      initialValues={{
        email: props.email,
      }}
      validateOnBlur={false}
      validateOnChange={false}
      validationSchema={ForgotPasswordFormSchema}
      onSubmit={(values, actions) => {
        props.loginBegin(values);
      }}
    >
      {formikProps => <ForgotPasswordFormInner {...props} {...formikProps} classes={classes} width={width} />}
    </Formik>
  );
}

ForgotPasswordFormInner.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  setFieldValue: PropTypes.func,
  errors: PropTypes.object,
  touched: PropTypes.object,
  values: PropTypes.object,
  isLoggingIn: PropTypes.bool,
  loginSuccess: PropTypes.bool,
};

ForgotPasswordForm.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  loginBegin: PropTypes.func,
  email: PropTypes.string,
  isLoggingIn: PropTypes.bool,
  loginSuccess: PropTypes.bool,
};

ForgotPasswordForm.contextTypes = {
  intl: PropTypes.object.isRequired,
};

// without memo
export const StyledForgotPasswordForm = compose(
  withWidth(),
  withStyles(styles),
)(ForgotPasswordForm);

export default compose(
  memo,
  withWidth(),
  withStyles(styles),
)(ForgotPasswordForm);
