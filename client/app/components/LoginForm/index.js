/**
 *
 * LoginForm
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

/* TODO: input labels, validation with yup, disabled logic, logo, locale toggle  */

import { FormattedMessage } from 'react-intl';
import messages from './messages';
import { withStyles } from "@material-ui/core/styles";
import withWidth from '@material-ui/core/withWidth';
import { Formik } from 'formik';
import { Button, Card, CardActions, CardContent, Grid, TextField, Hidden } from "@material-ui/core";
import LockOpen from "@material-ui/icons/LockOpen";

import Logo from 'components/Logo';

const styles = theme => ({
  form: {
    width: '100%',
  },
});

function LoginForm(props) {
  const { classes, width } = props;

  return (
    <Formik
      initialValues={{ email: props.email, password: ''}}
      onSubmit={props.loginBegin}
      render={props => (
        <Card raised className={classes.form}>
          <form onSubmit={props.handleSubmit}>
            <CardContent>
              <Grid container spacing={0} direction='column' alignItems='center' justify='center'>
                <Grid item xs={12}>
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
                <Grid item xs={false} sm={4} />
                <Grid item align={ width === 'xs' ? "left" : "center" } xs={6} sm={4}>
                  <Button
                    type="submit"
                    color="primary"
                    size="large"
                    disabled={!props.values.email || !props.values.password}
                    variant="contained"
                  >
                    <Hidden xsDown>
                      <LockOpen />
                    </Hidden>
                    {<FormattedMessage {...messages.login} />}
                  </Button>
                </Grid>
                <Grid item align="right" xs={6} sm={4}>
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
      )}
    />
  );
}

LoginForm.propTypes = {
  loginBegin: PropTypes.func,
  email: PropTypes.string
};

export default compose(
  memo,
  withWidth(),
  withStyles(styles),
)(LoginForm);
