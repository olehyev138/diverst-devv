import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';

// This component is intended for creating a custom popup with a message and logout option

export function DiverstPopup(props) {
  const { title, message, open, handleClose } = props;

  return (
    <React.Fragment>
      <Dialog open={open} onClose={handleClose}>
        <DialogTitle>{ title }</DialogTitle>
      </Dialog>
    </React.Fragment>
  );
}

DiverstPopup.propTypes = {
  title: PropTypes.string,
  message: PropTypes.string,
  open: PropTypes.bool,
  handleClose: PropTypes.func,
};

export default compose(
  memo,
)(DiverstPopup);
