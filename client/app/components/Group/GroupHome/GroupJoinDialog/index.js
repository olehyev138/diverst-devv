import React from 'react';
import Dialog from '@material-ui/core/Dialog';
import PropTypes from 'prop-types';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogActions from '@material-ui/core/DialogActions';
import Button from '@material-ui/core/Button';

import messages from 'containers/User/HomePage/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

export default function GroupJoinDialog(props) {
  const { title, message, open, handleClose } = props;

  return (
    <Dialog
      open={open}
      onClose={handleClose}
      aria-labelledby="alert-dialog-title"
      aria-describedby="alert-dialog-description"
    >
      <DialogContent>
        <DialogContentText id="alert-dialog-description">
          Thanks for joining the group!
          Do you also want to join a subgroup?
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button onClick={handleClose} color="primary" autoFocus>
          Yes
        </Button>
        <Button onClick={handleClose} color="primary">
          No
        </Button>
      </DialogActions>
    </Dialog>
  );
}

GroupJoinDialog.propTypes = {
  title: PropTypes.string,
  message: PropTypes.string,
  open: PropTypes.bool,
  handleClose: PropTypes.func,
};
