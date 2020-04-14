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

export default function DiverstDialog(props) {
  const { title, message, open, handleclose } = props;

  return (
    <Dialog open={open} onClose={handleclose} aria-labelledby='form-dialog-title' {...props}>
      <DialogTitle>{ title }</DialogTitle>
      <DialogContent>
        <DialogContentText>
          { message }
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button color='primary' onClick={handleclose}><DiverstFormattedMessage {...messages.close} /></Button>
      </DialogActions>
    </Dialog>
  );
}

DiverstDialog.propTypes = {
  children: PropTypes.any,
  title: PropTypes.string,
  message: PropTypes.string,
  open: PropTypes.bool,
};
