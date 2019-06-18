/**
 *
 * LoginForm
 *
 */

import React, { memo, useRef, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { FormattedMessage } from 'react-intl';

import { Field, Formik, Form } from 'formik';
import * as Yup from 'yup';

import { withStyles } from '@material-ui/core/styles';
import withWidth from '@material-ui/core/withWidth';
import {
  Button, Card, CardActions, CardContent, Grid, TextField, Hidden
} from '@material-ui/core';
import LockOpen from '@material-ui/icons/LockOpen';

/* TODO: input labels, validation with yup, disabled logic, logo, locale toggle  */

import messages from 'containers/Session/LoginPage/messages';

import Logo from 'components/Shared/Logo/index';

const styles = theme => ({
  card: {
    width: '100%',
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
export function LoginFormInner({ handleChange, handleBlur, errors,
                               touched, values, classes, width }) {
  return (
    <Card raised className={classes.card}>
      <Form
        noValidate
      >
        <CardContent>
          <Grid container spacing={0} direction='column' alignItems='center' justify='center'>
            <Grid item xs={12}>
              <Logo coloredDefault imgClass='large-img' />
            </Grid>
          </Grid>
          <br />
          <Field
            component={TextField}
            onChange={handleChange}
            onBlur={handleBlur}
            value={values.email}
            autoFocus={!values.email}
            fullWidth
            disabled={false}
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
            onChange={handleChange}
            onBlur={handleBlur}
            value={values.password}
            autoFocus={!!values.email}
            fullWidth
            disabled={false}
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
                disabled={!values.email || !values.password}
                variant='contained'
              >
                <Hidden xsDown>
                  <LockOpen />
                </Hidden>
                {<FormattedMessage {...messages.login} />}
              </Button>
            </Grid>
            <Grid item align='right' xs={8} sm={4}>
              <Button
                color='primary'
                size='small'
                variant='text'
              >
                {<FormattedMessage {...messages.forgotPassword} />}
              </Button>
            </Grid>
          </Grid>
        </CardActions>
      </Form>
    </Card>
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

  const form = useRef();

  useEffect(() => {
    if (form.current)
      form.current.setFieldError('password', props.passwordError);
  });

  return (
    <Formik
      ref={form}
      initialValues={{
        email: props.email,
        password: ''
      }}
      validateOnBlur={false}
      validateOnChange={false}
      validationSchema={LoginFormSchema}
      onSubmit={(values, actions) => {
        actions.setFieldError('password', props.passwordError);
        props.loginBegin(values);
      }}
      render={props => <LoginFormInner {...props} classes={classes} width={width} />}
    />
  );
}

LoginFormInner.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  errors: PropTypes.object,
  touched: PropTypes.bool,
  values: PropTypes.object
};

LoginForm.propTypes = {
  classes: PropTypes.object,
  loginBegin: PropTypes.func,
  email: PropTypes.string,
  passwordError: PropTypes.string,
  width: PropTypes.string,
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
