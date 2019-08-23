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

import { MuiThemeProvider, createMuiTheme } from '@material-ui/core/styles';

import { makeSelectPrimary, makeSelectSecondary } from './selectors';

import SnackbarProviderWrapper from 'components/Shared/SnackbarProviderWrapper';

import App from 'containers/Shared/App/Loadable';

export class ThemeProvider extends React.PureComponent {
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
        info: {
          main: primary,
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

const withConnect = connect(
  mapStateToProps,
);

export default compose(
  withConnect,
  memo,
)(ThemeProvider);
