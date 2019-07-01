/**
 *
 * SnackbarProviderWrapper
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import { SnackbarProvider } from 'notistack';
import { withStyles } from '@material-ui/core/styles';
import Slide from '@material-ui/core/Slide';
import PropTypes from 'prop-types';

const styles = theme => ({
  snackbarSuccess: {
    backgroundColor: theme.palette.success.main,
  },
  snackbarInfo: {
    backgroundColor: theme.palette.info.main,
  },
  snackbarWarning: {
    backgroundColor: theme.palette.warning.main,
  },
  snackbarError: {
    backgroundColor: theme.palette.error.main,
  }
});

function SnackbarProviderWrapper(props) {
  /* eslint-disable-next-line no-shadow */
  const SlideTransition = props => <Slide {...props} direction='up' />;

  return (
    <SnackbarProvider
      classes={{
        variantSuccess: props.classes.snackbarSuccess,
        variantInfo: props.classes.snackbarInfo,
        variantWarning: props.classes.snackbarWarning,
        variantError: props.classes.snackbarError,
      }}
      anchorOrigin={{
        vertical: 'bottom',
        horizontal: 'right',
      }}
      TransitionComponent={SlideTransition}
    >
      {props.children}
    </SnackbarProvider>
  );
}

SnackbarProviderWrapper.propTypes = {
  children: PropTypes.node.isRequired,
  classes: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(SnackbarProviderWrapper);
