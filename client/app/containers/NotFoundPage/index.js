/**
 * NotFoundPage
 *
 * This is the page we show when the user visits a url that doesn't have a route
 *
 */

import React from 'react';
import { FormattedMessage } from 'react-intl';

import { Grid, Button } from '@material-ui/core';
import { NavLink } from 'react-router-dom';

import logo from 'images/diverst.png';

export class NotFoundPage extends React.PureComponent {
  render() {
    return (
      <div>
        <Grid container spacing={0} direction="column" alignItems="center"
              justify="center" style={{minHeight: '100vh', textAlign: "center"}}>
          <Grid item xs={6}>
            <img src={logo} alt="Diverst Logo" height="150" width="150"/>
            <h1>TEMP</h1>
            { /* TODO: implement */ }
            <Button>Home</Button>
          </Grid>
        </Grid>
      </div>
    );
  }
}

export default NotFoundPage;
