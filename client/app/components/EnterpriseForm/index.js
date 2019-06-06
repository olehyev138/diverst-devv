/**
 *
 * EnterpriseForm
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
// import styled from 'styled-components';

import { FormattedMessage } from 'react-intl';
import {
  Button, Card, CardActions, CardContent, Grid, TextField, Hidden
} from '@material-ui/core';
import Search from '@material-ui/icons/Search';
import { Formik } from 'formik';
import { withStyles } from '@material-ui/core/styles';

import Logo from 'components/Logo';

import Box from '@material-ui/core/Box';

import messages from './messages';

const styles = theme => ({
  form: {
    width: '100%',
  },
});

function EnterpriseForm(props) {
  const { classes } = props;

  return (
    <Formik
      initialValues={{ email: '' }}
      onSubmit={props.findEnterpriseBegin}
      render={props => (
        <Card raised className={classes.form}>
          <form onSubmit={props.handleSubmit}>
            <CardContent>
              <Grid container spacing={0} direction='column' alignItems='center' justify='center'>
                <Grid item xs={6}>
                  <Logo coloredDefault imgClass='large-img' />
                </Grid>
              </Grid>
              <br />
              <TextField
                onChange={props.handleChange}
                autoFocus
                fullWidth
                disabled={false}
                id='email'
                name='email'
                label={<FormattedMessage {...messages.email} />}
                margin='normal'
                type='email'
                variant='outlined'
              />
            </CardContent>
            <CardActions>
              <Grid container alignItems='center' justify='center'>
                <Grid item align='center' xs={6}>
                  <Button
                    type='submit'
                    color='primary'
                    size='large'
                    variant='contained'
                    aria-hidden
                  >
                    <Hidden xsDown>
                      <Search />
                    </Hidden>
                    {<FormattedMessage {...messages.findCompany} />}
                  </Button>
                </Grid>
              </Grid>
            </CardActions>
            <br />
          </form>
        </Card>
      )}
    />
  );
}

EnterpriseForm.propTypes = {
  findEnterpriseBegin: PropTypes.func,
};

export default memo(withStyles(styles)(EnterpriseForm));
