/**
 * NotFoundPage
 *
 * This is the page we show when the user visits a url that doesn't have a route
 *
 */

import React from 'react';
import { FormattedMessage } from 'react-intl';
import messages from './messages';

import { NavLink } from 'react-router-dom';
import { Grid, Button } from '@material-ui/core';

import logo from 'images/diverst.png';

export default function NotFound() {
  return (
    <div>
      <Grid container spacing={0} direction="column" alignItems="center"
            justify="center" style={{minHeight: '100vh', textAlign: "center"}}>
        <Grid item xs={6}>
          <img src={logo} alt="Diverst Logo" height="150" width="150"/>

          { /* <h1><FormattedMessage {...messages.header} /></h1> */ }
          <Button component={NavLink} to="/home">Home</Button>
        </Grid>
      </Grid>
    </div>
  );
}
