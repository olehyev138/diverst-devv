/**
 *
 * LoginForm
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';

/* TODO: input labels, validation with yup, disabled logic, logo, locale toggle  */

import { FormattedMessage } from 'react-intl';
import messages from './messages';

import { Formik } from 'formik';
import { Button, Card, CardActions, CardContent, Grid, TextField } from "@material-ui/core";
import LockOpen from "@material-ui/icons/LockOpen";

import Logo from 'components/Logo';

function LoginForm(props) {
  return (
    <Formik
      initialValues={{ email: props.email, password: ''}}
      onSubmit={props.loginBegin}
      render={props => (
        <Grid container className="total-center" justify="center">
          <Grid item lg={4} md={6} sm={8} xs={12}>
            <Card>
              <form onSubmit={props.handleSubmit}>
                <CardContent>
                  <Grid container spacing={0} direction='column' alignItems='center' justify='center'>
                    <Grid item xs={6}>
                      <Logo coloredDefault imgClass="large-img" />
                    </Grid>
                  </Grid>
                  <br />
                  <TextField
                    onChange={props.handleChange}
                    value={props.values.email}
                    autoFocus={!props.values.email}
                    fullWidth
                    disabled={false}
                    variant="outlined"
                    id="email"
                    name="email"
                    type="email"
                    label={<FormattedMessage {...messages.email}/>}
                    margin="normal"
                    autoComplete="off"
                  />
                  <TextField
                    onChange={props.handleChange}
                    onBlur={props.handleBlur}
                    value={props.values.password}
                    autoFocus={!!props.values.email}
                    fullWidth
                    disabled={false}
                    variant="outlined"
                    id="password"
                    name="password"
                    type="password"
                    label={<FormattedMessage {...messages.password} />}
                    margin="normal"
                    autoComplete="off"
                  />
                </CardContent>
                <CardActions>
                  <Grid container alignItems='center'>
                    <Grid item xs={3} />
                    <Grid item align="center" xs={6}>
                      <Button
                        type="submit"
                        color="primary"
                        size="large"
                        disabled={!props.values.email || !props.values.password}
                        variant="contained"
                      >
                        <LockOpen />
                        {<FormattedMessage {...messages.login} />}
                      </Button>
                    </Grid>
                    <Grid item align="right" xs={3}>
                      <Button
                        color="primary"
                        size="small"
                        variant="text"
                      >
                        {<FormattedMessage {...messages.forgotPassword} />}
                      </Button>
                    </Grid>
                  </Grid>
                </CardActions>
              </form>
            </Card>
          </Grid>
        </Grid>
      )}
    />
  );
}

LoginForm.propTypes = {
  loginBegin: PropTypes.func,
  email: PropTypes.string
};

export default memo(LoginForm);
