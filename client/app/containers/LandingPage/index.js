/*
 * HomePage
 *
 * This is the first thing users see of our App, at the "/" route
 */

import React from "react";
import { connect } from "react-redux";
import { compose } from "redux";
import { createStructuredSelector } from "reselect";
import { Link } from 'react-router-dom';

import injectReducer from "utils/injectReducer";
import injectSaga from "utils/injectSaga";
import reducer from "./reducer";
import "./index.css";
import logo from "images/favicon.png";

import Typography from '@material-ui/core/Typography';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Grid from '@material-ui/core/Grid';
import Button from '@material-ui/core/Button';

/* eslint-disable react/prefer-stateless-function */
export class LandingPage extends React.PureComponent {

  componentDidMount() {}

  render() {
    return (
      <div>
        <AppBar position="static" style={{ background: 'transparent', boxShadow: 'none'}}>
          <Toolbar>
            <Grid container>
              <Grid item>
                <img src={logo} alt="diverst Logo" />
              </Grid>

              <Grid item style={{marginTop: 15, marginLeft: 15, flex: 1}} >
                <Typography variant="title" color="primary">
                  Diverst
                </Typography>
              </Grid>

              <Grid item>
                <div>
                  <Button color="primary">
                    <Link to="/login">Login</Link>
                  </Button>
                </div>
              </Grid>
            </Grid>
          </Toolbar>
        </AppBar>
      </div>
    );
  }
}


LandingPage.propTypes = {
};

export function mapDispatchToProps(dispatch, ownProps) {
  return {
  };
}

const mapStateToProps = createStructuredSelector({
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

const withReducer = injectReducer({ key: "landing", reducer });

export default compose(
  withReducer,
  withConnect,
)(LandingPage);
