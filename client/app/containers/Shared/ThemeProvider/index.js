/**
 *
 * ThemeProvider
 *
 */

import React, { memo, useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import { MuiThemeProvider, createMuiTheme } from '@material-ui/core/styles';

import { selectEnterprise } from 'containers/Shared/App/selectors';

import SnackbarProviderWrapper from 'components/Shared/SnackbarProviderWrapper';

import App from 'containers/Shared/App/Loadable';

// Date/time pickers
import { MuiPickersUtilsProvider } from '@material-ui/pickers';
import LuxonUtils from '@date-io/luxon';

export const DEFAULT_BRANDING_COLOR = '7b77c9';
export const DEFAULT_CHARTS_COLOR = '8a8a8a';

export function ThemeProvider(props) {
  const { enterprise } = props;

  const [defaultTheme] = useState(createMuiTheme());

  const buildTheme = (brandingColor, graphsColor) => createMuiTheme({
    palette: {
      type: 'light',
      background: {
        default: '#f5f5f5',
      },
      primary: {
        main: `#${brandingColor}`,
        main25: `#${brandingColor}40`,
        main50: `#${brandingColor}80`,
        main75: `#${brandingColor}C0`,
      },
      secondary: {
        main: '#5a5a5a',
      },
      tertiary: {
        main: '#9d9e9f',
      },
      graphs: {
        main: `#${graphsColor}`
      },
      error: {
        main: '#D32F2F',
      },
      warning: {
        main: '#ffa000',
      },
      info: {
        main: `#${brandingColor}`,
      },
      success: {
        main: '#43a047',
        lightBackground: '#8bcf8e',
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
        offBlack: '#333333',
        darkGrey: '#4c4c4c',
        grey: '#a7a8a9',
        lightGrey: '#dedfe0',
      },
    },
  });

  // Defaults
  const [brandingColor, setBrandingColor] = useState(DEFAULT_BRANDING_COLOR);
  const [graphsColor, setGraphsColor] = useState(DEFAULT_CHARTS_COLOR);

  const [theme, setTheme] = useState(buildTheme(brandingColor, graphsColor));

  useEffect(() => {
    if (enterprise && enterprise.theme)
      setTheme(buildTheme(enterprise.theme.branding_color, enterprise.theme.charts_color));
  }, [enterprise]);

  return (
    <MuiThemeProvider theme={theme}>
      <SnackbarProviderWrapper>
        <MuiPickersUtilsProvider utils={LuxonUtils}>
          <App />
        </MuiPickersUtilsProvider>
      </SnackbarProviderWrapper>
    </MuiThemeProvider>
  );
}

ThemeProvider.propTypes = {
  enterprise: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise(),
});

const withConnect = connect(
  mapStateToProps,
);

export default compose(
  withConnect,
  memo,
)(ThemeProvider);
