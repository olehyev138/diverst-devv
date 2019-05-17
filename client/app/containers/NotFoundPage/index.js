/*
 * LoginPage
 *
 * This is the first thing users see of our App, at the "/login" route
 */

import React from "react";
import { FormattedMessage } from "react-intl";

import Grid from "@material-ui/core/Grid";
import Button from "@material-ui/core/Button";

import messages from "./messages";

import logo from "images/diverst.png";

/* eslint-disable react/prefer-stateless-function */
export class NotFoundPage extends React.PureComponent {

    render() {
        return (
        <div>
          <Grid container spacing={0} direction="column" alignItems="center" justify="center" style={{minHeight: '100vh', textAlign: "center"}}>
            <Grid item xs={6}>
              <img src={logo} alt="Diverst Logo" height="150" width="150"/>
              
              <h1><FormattedMessage {...messages.header} /></h1>
              <Button>Home</Button>
            </Grid>   
          </Grid>
        </div>
        );
    }
}

export default NotFoundPage;