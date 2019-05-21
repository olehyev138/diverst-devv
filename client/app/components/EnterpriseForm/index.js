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

function EnterpriseForm(props) {
  return (
    <Formik
      initialValues={{ email: '' }}
      onSubmit={props.onFindEnterprise}
      render={props => (
        <Grid container className="total-center" justify="center">
          <Grid item lg={4} md={6} sm={8} xs={12}>
            <Card>
              <form onSubmit={props.handleSubmit}>
                <CardContent>
                  <TextField
                    onChange={props.handleChange}
                    autoFocus
                    fullWidth
                    disabled={false}
                    id="email"
                    name="email"
                    margin="normal"
                    type="email"
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
                        Find Company
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
  onFindEnterprise: PropTypes.func,
};

export default memo(EnterpriseForm);
