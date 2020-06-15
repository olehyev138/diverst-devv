import React from 'react';
import Dialog from '@material-ui/core/Dialog';
import PropTypes from 'prop-types';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogActions from '@material-ui/core/DialogActions';
import Button from '@material-ui/core/Button';

export function DiverstDialog(props) {
  const { title, open, handleYes, textYes, handleNo, textNo, content } = props;

  return (
    <Dialog
      open={open}
      onClose={handleNo}
      aria-labelledby='alert-dialog-title'
      aria-describedby='alert-dialog-description'
    >
      <DialogContent>
        {title && <DialogTitle id='alert-dialog-title'>{ title }</DialogTitle>}
        <DialogContentText id='alert-dialog-description'>
          {content}
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        {handleYes && (
          <Button onClick={handleYes} color='primary' autoFocus>
            {textYes}
          </Button>
        )}
        {handleNo && (
          <Button onClick={handleNo} color='primary' autoFocus>
            {textNo}
          </Button>
        )}
      </DialogActions>
    </Dialog>
  );
}

DiverstDialog.propTypes = {
  title: PropTypes.string,
  open: PropTypes.bool,
  handleYes: PropTypes.func,
  textYes: PropTypes.string,
  handleNo: PropTypes.func,
  textNo: PropTypes.string,
  content: PropTypes.any,
};

export default DiverstDialog;
