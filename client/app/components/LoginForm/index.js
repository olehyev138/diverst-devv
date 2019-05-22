/**
 *
 * LoginForm
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
// import styled from 'styled-components';

/* TODO: input labels, validation with yup, disabled logic, logo, locale toggle  */

import { FormattedMessage } from 'react-intl';
import messages from './messages';

import { Formik } from 'formik';
import { Button, Card, CardActions, CardContent, Grid, TextField } from "@material-ui/core";

import Logo from 'components/Logo'

function LoginForm(props) {
  // TODO: load email field
  //const email = props.email;

  return (
    <Formik
      initialValues={{ email: '', password: ''}}
      onSubmit={props.onLogin}
      render={props => (
        <Grid container className="total-center" justify="center">
          <Grid item lg={4} md={6} sm={8} xs={12}>
            <Card>
              <Grid container spacing={0} direction='column' alignItems='center' justify='center'>
                <Grid item xs={3}>
                  <Logo/>
                </Grid>
              </Grid>
              <form onSubmit={props.handleSubmit}>
                <CardContent>
                  <TextField
                    onChange={props.handleChange}
                    autoFocus
                    fullWidth
                    disabled={false}
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
                    fullWidth
                    disabled={false}
                    id="password"
                    name="password"
                    type="password"
                    label={<FormattedMessage {...messages.password} />}
                    margin="normal"
                    autoComplete="off"
                  />
                </CardContent>
                <CardActions>
                  <Grid container>
                    <Grid item align="left" xs={4}>
                      <Button
                        type="submit"
                        color="primary"
                        size="small"
                      >
                        {<FormattedMessage {...messages.login} />}
                      </Button>
                    </Grid>
                    <Grid item align="right" xs={4}>
                      <Button
                        color="primary"
                        size="small"
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
  onLogin: PropTypes.func,
  email: PropTypes.string
};

export default memo(LoginForm);
