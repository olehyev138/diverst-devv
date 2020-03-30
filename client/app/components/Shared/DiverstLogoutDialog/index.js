import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import Button from '@material-ui/core/Button';

import messages from 'components/Shared/DiverstLogoutDialog/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

// This component is intended for creating a custom popup with a message and logout option

export function DiverstLogoutDialog(props) {
  const { title, message, open, handleClose } = props;

  return (
    <React.Fragment>
      <Dialog open={open} onClose={handleClose}>
        <DialogTitle>{ title }</DialogTitle>
        <DialogActions>
          <Button color='primary' onClick={handleClose}><DiverstFormattedMessage {...messages.later} /></Button>
          <Button color='primary'><DiverstFormattedMessage {...messages.logout} /></Button>
        </DialogActions>
      </Dialog>
    </React.Fragment>
  );
}

DiverstLogoutDialog.propTypes = {
  title: PropTypes.string,
  message: PropTypes.string,
  open: PropTypes.bool,
  handleClose: PropTypes.func,
};

export default compose(
  memo,
)(DiverstLogoutDialog);
