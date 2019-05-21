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

import { useInjectReducer } from 'utils/injectReducer';
import makeSelectThemeProvider from './selectors';
import reducer from './reducer';

import { MuiThemeProvider, createMuiTheme } from '@material-ui/core/styles';
import { makeSelectPrimary, makeSelectSecondary } from "./selectors";
import { loggedIn, setCurrentUser, setEnterprise } from "containers/App/actions";
import { changePrimary, changeSecondary } from "./actions";

import AuthService from "utils/authService";


export function ThemeProvider() {
  useInjectReducer({ key: 'themeProvider', reducer });

  return <div />;
}

export class ThemeProvider extends React.PureComponent {
  componentDidMount() {
    // Try and get the JWT token from storage. If it doesn"t exist
    // we"re done. The user must login again.

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
      dispatch(setCurrentUser(user));
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
