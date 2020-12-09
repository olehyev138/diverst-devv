import React, { memo } from 'react';
import { connect } from 'react-redux';
import Dialog from '@material-ui/core/Dialog';
import PropTypes from 'prop-types';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogActions from '@material-ui/core/DialogActions';
import Divider from '@material-ui/core/Divider';
import Button from '@material-ui/core/Button';
import Box from '@material-ui/core/Box';
import { withStyles } from '@material-ui/core';
import { injectIntl, intlShape } from 'react-intl';
import { createStructuredSelector } from 'reselect';
import { selectCustomText } from 'containers/Shared/App/selectors';
import { compose } from 'redux';

import Scrollbar from 'components/Shared/Scrollbar';

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
    paddingTop: '10px !important',
    height: '100%',
    display: 'flex',
    flex: 1,
    flexFlow: 'column',
  },
  scrollbarContent: {
    display: 'flex',
    flexDirection: 'column',
    flex: 1,
    height: '100%',
  },
};


export function DiverstDialog(props) {
  const { title, titleDivider, open, handleYes, textYes, handleNo, textNo, content, classes, paperProps, actionsDivider, extraActions } = props;

  return (
    <Dialog
      open={open}
      onClose={handleNo}
      aria-labelledby='alert-dialog-title'
      aria-describedby='alert-dialog-description'
      PaperProps={{
        className: classes.paper,
        ...paperProps,
      }}
      className={classes.dialog}
    >
      {title && <DialogTitle id='alert-dialog-title'>{ title.id ? props.intl.formatMessage(title, props.customText) : title }</DialogTitle>}
      {titleDivider && <Divider />}
      <Scrollbar useFlexContainer>
        <Box className={classes.scrollbarContent}>
          <DialogContent className={classes.content}>
            {content.id ? props.intl.formatMessage(content, props.customText) : content}
          </DialogContent>
        </Box>
      </Scrollbar>
      {actionsDivider && <Divider />}
      {(handleYes || handleNo || extraActions.length > 0) && (
        <DialogActions>
          {handleYes && textYes && (
            <Button onClick={handleYes} color='primary' autoFocus>
              {textYes.id ? props.intl.formatMessage(textYes, props.customText) : textYes}
            </Button>
          )}
          {handleNo && textNo && (
            <Button onClick={handleNo} color='primary'>
              {textNo.id ? props.intl.formatMessage(textNo, props.customText) : textNo}
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
  title: PropTypes.object,
  subTitle: PropTypes.node,
  titleDivider: PropTypes.bool,
  open: PropTypes.bool,
  handleYes: PropTypes.func,
  textYes: PropTypes.node,
  handleNo: PropTypes.func,
  textNo: PropTypes.object,
  customText: PropTypes.object,
  content: PropTypes.any,
  classes: PropTypes.object.isRequired,
  paperProps: PropTypes.object,
  actionsDivider: PropTypes.bool,
  extraActions: PropTypes.arrayOf(PropTypes.shape({
    key: PropTypes.string,
    func: PropTypes.func,
    label: PropTypes.node,
  })),
  intl: intlShape.isRequired,
};

DiverstDialog.defaultProps = {
  extraActions: []
};

const mapStateToProps = createStructuredSelector({
  customText: selectCustomText(),
});

const withConnect = connect(
  mapStateToProps,
);

export default compose(
  injectIntl,
  withStyles(styles),
  memo,
  withConnect
)(DiverstDialog);
