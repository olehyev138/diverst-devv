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

import Logo from 'components/Shared/Logo';

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
export function LoginFormInner({
                                 handleSubmit, handleChange, handleBlur, errors,
                                 touched, values, classes, width
                               }) {
  return (
    <Card raised className={classes.card}>
      <Form
        noValidate
      >
        <CardContent>
          <Logo coloredDefault maxHeight='45px' />
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

  // Use React hook (as this is a functional component) to merge local validation errors with API validation errors
  useEffect(() => {
    if (form.current)
      form.current.setErrors({ ...form.current.state.errors, ...props.formErrors });
  });

  const Form = React.forwardRef((props, ref) => {
    const clone = Object.assign({}, props);
    delete clone.children;

    return (
      <Formik
        {...clone}
      >
        {/* eslint-disable-next-line react/prop-types */}
        {props.children}
      </Formik>
    );
  });

  return (
    <Form
      ref={form}
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
      {props => <LoginFormInner {...props} classes={classes} width={width} />}
    </Form>
  );
}

LoginFormInner.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  errors: PropTypes.object,
  touched: PropTypes.object,
  values: PropTypes.object
};

LoginForm.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  loginBegin: PropTypes.func,
  email: PropTypes.string,
  formErrors: PropTypes.shape({
    email: PropTypes.string,
    password: PropTypes.string,
  }),
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
