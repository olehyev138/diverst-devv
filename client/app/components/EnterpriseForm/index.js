/**
 *
 * EnterpriseForm
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
// import styled from 'styled-components';

import { FormattedMessage } from 'react-intl';
import messages from './messages';
import {Button, Card, CardActions, CardContent, Grid, TextField} from "@material-ui/core";
import {Formik} from "formik";

import Logo from 'components/Logo'

function EnterpriseForm(props) {
  return (
    <Formik
      initialValues={{ email: '' }}
      onSubmit={props.findEnterpriseBegin}
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
                    label={<FormattedMessage {...messages.email} />}
                    margin="normal"
                    type="email"
                    autoComplete="off"
                  />
                </CardContent>
                <CardActions>
                  <Grid container alignItems="center" justify="center">
                    <Grid item align="center" xs={4}>
                      <Button
                        type="submit"
                        color="primary"
                        size="small"
                      >
                        {<FormattedMessage {...messages.findCompany }/>}
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

EnterpriseForm.propTypes = {
  findEnterpriseBegin: PropTypes.func,
};

export default memo(EnterpriseForm);
