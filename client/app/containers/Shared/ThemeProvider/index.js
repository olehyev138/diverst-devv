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

import injectReducer from 'utils/injectReducer';

import { MuiThemeProvider, createMuiTheme } from '@material-ui/core/styles';
import Slide from '@material-ui/core/Slide';

import { makeSelectPrimary, makeSelectSecondary } from './selectors';
import { changePrimary, changeSecondary } from './actions';
import reducer from './reducer';

import SnackbarProviderWrapper from 'components/Shared/SnackbarProviderWrapper';

import App from 'containers/Shared/App/Loadable';
import { loginSuccess, setUser, setEnterprise } from 'containers/Shared/App/actions';
import AuthService from 'utils/authService';

const axios = require('axios');

export class ThemeProvider extends React.PureComponent {
  componentDidMount() {
    // Try and get the JWT token from storage. If it doesn't exist
    // we're done. The user must login again.

    // TODO:
    //    - why is this done here? what does it do?
    //    - why is theme provider around app and not app around theme provider (material ui suggests the latter)

    const jwt = AuthService.getJwt();
    const enterprise = AuthService.getEnterprise();

    if (jwt) {
      AuthService.setValue(jwt, '_diverst.twj');
      axios.defaults.headers.common['Diverst-UserToken'] = jwt;

      const user = JSON.parse(window.atob(jwt.split('.')[1]));
      this.props.loginSuccess(jwt, user, enterprise || user.enterprise);
    }
  }

  render() {
    const defaultTheme = createMuiTheme();

    const { primary, secondary } = this.props;
    const theme = createMuiTheme({
      palette: {
        primary: {
          main: primary,
        },
        secondary: {
          main: secondary,
        },
        error: {
          main: '#d32f2f',
        },
        warning: {
          main: '#ffa000',
        },
        success: {
          main: '#43a047',
        },
      },
      typography: {
        useNextVariants: true,
      },
      mixins: {
        toolbar: {
          minHeight: 90,
          maxHeight: 90,
          [`${defaultTheme.breakpoints.up('xs')} and (orientation: landscape)`]: {
            minHeight: 56,
            maxHeight: 56,
          },
          [defaultTheme.breakpoints.up('sm')]: {
            minHeight: 90,
            maxHeight: 90,
          },
        },
      },
      // Custom theme additions & global styles should be placed here
      custom: {
        colors: {
          grey: '#a7a8a9',
          lightGrey: '#dedfe0',
        },
      },
    });

    return (
      <MuiThemeProvider theme={theme}>
        <SnackbarProviderWrapper>
          <App />
        </SnackbarProviderWrapper>
      </MuiThemeProvider>
    );
  }
}

ThemeProvider.propTypes = {
  primary: PropTypes.string,
  secondary: PropTypes.string,
  loginSuccess: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  primary: makeSelectPrimary(),
  secondary: makeSelectSecondary(),
});

function mapDispatchToProps(dispatch, ownProps) {
  return {
    loginSuccess(token, user, enterprise) {
      dispatch(loginSuccess(token));
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
