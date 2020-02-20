/**
 *
 * LoginForm
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

import LockOpen from '@material-ui/icons/LockOpen';

import messages from 'containers/Session/LoginPage/messages';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import Logo from 'components/Shared/Logo';

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
export function LoginFormInner({
 handleSubmit, handleChange, handleBlur, errors,
 touched, values, classes, width, setFieldValue, ...rest
}) {
  const passwordRef = useRef();

  useEffect(() => {
    if (rest.loginSuccess === false) {
      setFieldValue('password', '');
      if (passwordRef.current)
        passwordRef.current.focus();
    }
  }, [rest.loginSuccess]);

  return (
    <Box boxShadow={4} borderRadius={4} width='100%'>
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
              margin='normal'
              autoComplete='off'
              error={errors.email && touched.email}
              helperText={errors.email && touched.email ? errors.email : null}
            />
            <Field
              component={TextField}
              inputRef={passwordRef}
              onChange={handleChange}
              onBlur={handleBlur}
              value={values.password}
              autoFocus={!!values.email}
              fullWidth
              disabled={rest.isLoggingIn}
              variant='outlined'
              id='password'
              name='password'
              type='password'
              label={<FormattedMessage {...messages.password} />}
              margin='normal'
              autoComplete='off'
              error={errors.password && touched.password}
              helperText={errors.password && touched.password ? errors.password : null}
            />
          </CardContent>
          <CardActions className={classes.cardActions}>
            <Grid container alignItems='center'>
              <Grid item xs={false} sm={4} />
              <Grid item align={width === 'xs' ? 'left' : 'center'} xs={4} sm={4}>
                <Button
                  classes={{
                    label: classes.submitButtonLabel
                  }}
                  type='submit'
                  color='primary'
                  size='large'
                  disabled={!values.email || !values.password || rest.isLoggingIn}
                  variant='contained'
                  startIcon={(
                    <Hidden xsDown>
                      <LockOpen />
                    </Hidden>
                  )}
                >
                  {<FormattedMessage {...messages.login} />}
                </Button>
              </Grid>
              <Grid item align='right' xs={8} sm={4}>
                <Button
                  component={WrappedNavLink}
                  to={ROUTES.session.forgotPassword.path()}
                  color='primary'
                  size='small'
                  variant='text'
                  disabled={rest.isLoggingIn}
                >
                  {<FormattedMessage {...messages.forgotPassword} />}
                </Button>
              </Grid>
            </Grid>
          </CardActions>
        </Form>
      </Card>
    </Box>
  );
}

function LoginForm(props, context) {
  const { classes, width } = props;
  const { intl } = context;

  const LoginFormSchema = Yup.object().shape({
    email: Yup
      .string()
      .email(intl.formatMessage(messages.invalidEmail)),
    password: Yup
      .string()
      .required(intl.formatMessage(messages.invalidPassword))
  });

  return (
    <Formik
      initialValues={{
        email: props.email,
        password: ''
      }}
      validateOnBlur={false}
      validateOnChange={false}
      validationSchema={LoginFormSchema}
      onSubmit={(values, actions) => {
        props.loginBegin(values);
      }}
    >
      {formikProps => <LoginFormInner {...props} {...formikProps} classes={classes} width={width} />}
    </Formik>
  );
}

LoginFormInner.propTypes = {
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

LoginForm.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  loginBegin: PropTypes.func,
  email: PropTypes.string,
  isLoggingIn: PropTypes.bool,
  loginSuccess: PropTypes.bool,
};

LoginForm.contextTypes = {
  intl: PropTypes.object.isRequired,
};

// without memo
export const StyledLoginForm = compose(
  withWidth(),
  withStyles(styles),
)(LoginForm);

export default compose(
  memo,
  withWidth(),
  withStyles(styles),
)(LoginForm);
