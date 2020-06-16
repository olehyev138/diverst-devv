import React from 'react';
import Dialog from '@material-ui/core/Dialog';
import PropTypes from 'prop-types';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogActions from '@material-ui/core/DialogActions';
import Button from '@material-ui/core/Button';
import { withStyles } from '@material-ui/core';

const styles = {
  dialog: {
    overflowY: 'scroll',
    overflowX: 'hidden',
  },
  paper: {
    overflow: 'hidden',
    margin: 'auto',
    maxHeight: '85%',
    minHeight: '85%',
    minWidth: '40%',
  },
  content: {
    height: '100%',
    display: 'flex',
    flexFlow: 'column',
  },
};


export function DiverstDialog(props) {
  const { title, open, handleYes, textYes, handleNo, textNo, content, subTitle, classes } = props;

  return (
    <Dialog
      open={open}
      onClose={handleNo}
      aria-labelledby='alert-dialog-title'
      aria-describedby='alert-dialog-description'
      PaperProps={{
        className: classes.paper
      }}
      className={classes.dialog}
    >
      <DialogContent className={classes.content}>
        {title && <DialogTitle id='alert-dialog-title'>{ title }</DialogTitle>}
        {subTitle && <DialogContentText id='alert-dialog-title'>{ subTitle }</DialogContentText>}
        <div
          style={{
            flex: 1,
            display: 'flex',
            flexFlow: 'column'
          }}
        >
          {content}
        </div>
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
  title: PropTypes.node,
  subTitle: PropTypes.node,
  open: PropTypes.bool,
  handleYes: PropTypes.func,
  textYes: PropTypes.node,
  handleNo: PropTypes.func,
  textNo: PropTypes.node,
  content: PropTypes.any,
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(DiverstDialog);
