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
  const { title, message } = props;

  const [open, setOpen] = React.useState(false);


  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

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
};

export default compose(
  memo,
)(DiverstPopup);
