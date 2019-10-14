import React from 'react';
import Dialog from '@material-ui/core/Dialog';
import PropTypes from 'prop-types';

export default function DiverstDialog(props) {
  const [open, setOpen] = React.useState(false);

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  return (
    <div>
      <Dialog open={open} onClose={handleClose} aria-labelledby='form-dialog-title' {...props}>
        { props.children }
      </Dialog>
    </div>
  );
}

DiverstDialog.propTypes = {
  children: PropTypes.any,
};
