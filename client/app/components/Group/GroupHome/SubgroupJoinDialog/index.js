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

export default function SubgroupJoinDialog(props) {
  const { title, message, open, handleNo, handleYes } = props;

  return (
    <Dialog
      open={open}
      onClose={handleNo}
      aria-labelledby='alert-dialog-title'
      aria-describedby='alert-dialog-description'
    >
      <DialogContent>
        <DialogContentText id='alert-dialog-description'>
          Subgroups
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button onClick={handleYes} color='primary' autoFocus>
          Yes
        </Button>
        <Button onClick={handleNo} color='primary'>
          No
        </Button>
      </DialogActions>
    </Dialog>
  );
}

SubgroupJoinDialog.propTypes = {
  title: PropTypes.string,
  message: PropTypes.string,
  open: PropTypes.bool,
  handleYes: PropTypes.func,
  handleNo: PropTypes.func,
};
