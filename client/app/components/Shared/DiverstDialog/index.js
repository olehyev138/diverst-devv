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
  },
  content: {
    height: '100%',
    display: 'flex',
    flex: 1,
    flexFlow: 'column',
  },
};


export function DiverstDialog(props) {
  const { title, open, handleYes, textYes, handleNo, textNo, content, onClose, classes, paperProps, extraActions } = props;

  return (
    <Dialog
      open={open}
      onClose={onClose || handleNo}
      aria-labelledby='alert-dialog-title'
      aria-describedby='alert-dialog-description'
      PaperProps={{
        className: classes.paper,
        ...paperProps,
      }}
      className={classes.dialog}
    >
      {title && <DialogTitle id='alert-dialog-title'>{ title }</DialogTitle>}
      <DialogContent className={classes.content}>
        {content}
      </DialogContent>
      {(handleYes || handleNo || extraActions.length > 0) && (
        <DialogActions>
          {handleYes && (
            <Button onClick={handleYes} color='primary' autoFocus>
              {textYes}
            </Button>
          )}
          {handleNo && (
            <Button onClick={handleNo} color='primary'>
              {textNo}
            </Button>
          )}
          {extraActions.map(action => (
            <React.Fragment key={action.key}>
              <Button onClick={action.func} color={action.color || 'primary'}>
                {action.label}
              </Button>
            </React.Fragment>
          ))}
        </DialogActions>
      )}
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
  paperProps: PropTypes.object,
  extraActions: PropTypes.arrayOf(PropTypes.shape({
    key: PropTypes.string,
    func: PropTypes.func,
    label: PropTypes.node,
  })),
};

DiverstDialog.defaultProps = {
  extraActions: []
}

export default withStyles(styles)(DiverstDialog);
