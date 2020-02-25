/**
 *
 * SnackbarProviderWrapper
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import { SnackbarProvider } from 'notistack';

import { IconButton } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import CloseIcon from '@material-ui/icons/Close';

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

const SlideTransition = props => <Slide {...props} direction='up' />;

function SnackbarProviderWrapper(props) {
  /* eslint-disable-next-line no-shadow */
  const SlideTransition = props => <Slide {...props} direction='up' />;

  const notistackRef = React.createRef();

  return (
    <SnackbarProvider
      maxSnack={3}
      preventDuplicate
      ref={notistackRef}
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
      action={key => (
        <IconButton
          key='close'
          aria-label='close'
          color='inherit'
          onClick={() => notistackRef.current.closeSnackbar(key)}
        >
          <CloseIcon />
        </IconButton>
      )}
    >
      {props.children}
    </SnackbarProvider>
  );
}

SnackbarProviderWrapper.propTypes = {
  children: PropTypes.node.isRequired,
  classes: PropTypes.object,
  closeSnackbar: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles),
)(SnackbarProviderWrapper);
