/**
 *
 * ThemeProvider
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import  injectReducer  from 'utils/injectReducer';

import { MuiThemeProvider, createMuiTheme } from '@material-ui/core/styles';

import { makeSelectPrimary, makeSelectSecondary } from "./selectors";
import { changePrimary, changeSecondary } from "./actions";
import reducer from './reducer';

import App from "containers/App/Loadable";
import { loggedIn, setUser, setEnterprise } from "containers/App/actions";
import AuthService from "utils/authService";

const axios = require("axios");


export class ThemeProvider extends React.PureComponent {
  componentDidMount() {
    // Try and get the JWT token from storage. If it doesn"t exist
    // we"re done. The user must login again.

    // TODO:
    //    - why is this done here? what does it do?
    //    - why is theme provider around app and not app around theme provider (material ui suggests the latter)

    var jwt = AuthService.getJwt();
    var enterprise = AuthService.getEnterprise();

    if (jwt) {
      AuthService.setValue(jwt, "_diverst.twj");
      axios.defaults.headers.common['Diverst-UserToken'] = jwt;

      const user = JSON.parse(window.atob(jwt.split('.')[1]));
      this.props.loggedIn(jwt, user, enterprise || user.enterprise);
    }
  }

  render() {
    const { primary, secondary } = this.props;
    const theme = createMuiTheme({
      palette: {
        primary: {
          main: primary,
        },
        secondary: {
          main: secondary,
        },
      },
    });

    return (
      <MuiThemeProvider theme={theme}>
        <App>
        </App>
      </MuiThemeProvider>
    );
  }
}

ThemeProvider.propTypes = {
  primary: PropTypes.string,
  secondary: PropTypes.string
};

const mapStateToProps = createStructuredSelector({
  primary: makeSelectPrimary(),
  secondary: makeSelectSecondary(),
});

function mapDispatchToProps(dispatch, ownProps) {
  return {
    loggedIn: function(token, user, enterprise) {
      dispatch(loggedIn(token));
      dispatch(setUser(user));
      dispatch(setEnterprise(enterprise));

      if (user.enterprise.theme) {
        dispatch(changePrimary(user.enterprise.theme.primary_color));
        dispatch(changeSecondary(user.enterprise.theme.secondary_color));
      }
    },
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ThemeProvider);
