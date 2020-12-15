/**
 *
 * AdminGroupList List
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';
import { injectIntl, intlShape } from 'react-intl';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { Button, Box, Grid, Fade } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';
import ReorderIcon from '@material-ui/icons/Reorder';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';
import { DroppableGroupList } from './DroppableGroupList';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';


const styles = theme => ({
  progress: {
    margin: theme.spacing(8),
  },
  groupListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
  optionButton: {
    margin: 5,
  },
  groupCard: {
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.primary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
  groupLink: {
    textTransform: 'none',
  },
  childGroupCard: {
    marginLeft: 24,
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.secondary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
  draggableCard: {
    cursor: 'grab',
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.primary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  }
});

export function AdminGroupList(props, context) {
  const { classes, defaultParams } = props;
  const [order, setOrder] = useState(false);
  const [save, setSave] = useState(false);

  useEffect(() => {
    setSave(false);
  }, [defaultParams.page]);

  return (
    <React.Fragment>
      <Fade
        in={!props.isDisplayingChildren}
        appear
        mountOnEnter
        unmountOnExit
        onExited={props.handleFinishExitTransition}
      >
        <Grid container spacing={3} justify='flex-end'>
          <Grid item>
            <Permission show={permission(props, 'groups_create')}>
              <Button
                variant='contained'
                to={ROUTES.admin.manage.groups.new.path()}
                color='primary'
                size='large'
                component={WrappedNavLink}
                startIcon={<AddIcon />}
                className={classes.optionButton}
              >
                <DiverstFormattedMessage {...messages.new} />
              </Button>
            </Permission>
            <Permission show={permission(props, 'groups_manage')}>
              <Button
                variant='contained'
                to={ROUTES.admin.manage.groups.categories.index.path()}
                color='primary'
                size='large'
                component={WrappedNavLink}
                className={classes.optionButton}
              >
                <DiverstFormattedMessage {...messages.allcategories} />
              </Button>
            </Permission>
            <Permission show={permission(props, 'groups_manage')}>
              { order ? (
                <Button
                  variant='contained'
                  color='primary'
                  size='large'
                  startIcon={<ReorderIcon />}
                  className={classes.optionButton}
                  onClick={() => {
                    setSave(true);
                    setOrder(false);
                  }
                  }
                >
                  <DiverstFormattedMessage {...messages.set_order} />
                </Button>
              ) : (
                <Button
                  variant='contained'
                  color='primary'
                  size='large'
                  startIcon={<ReorderIcon />}
                  className={classes.optionButton}
                  onClick={() => {
                    setSave(false);
                    setOrder(true);
                  }}
                >
                  <DiverstFormattedMessage {...messages.change_order} />
                </Button>
              )}
            </Permission>
          </Grid>
        </Grid>
      </Fade>
      <Box mb={1} />
      <DiverstLoader isLoading={props.isLoading}>
        <DroppableGroupList
          items={props.groups}
          positions={props.positions}
          classes={classes}
          draggable={order}
          save={save}
          handleParentExpand={props.handleParentExpand}
          updateGroupPositionBegin={props.updateGroupPositionBegin}
          deleteGroupBegin={props.deleteGroupBegin}
          currentPage={defaultParams.page}
          importAction={props.importAction}
          intl={props.intl}
          rowsPerPage={defaultParams.count}
          customTexts={props.customTexts}
        />
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isLoading}
        handlePagination={props.handlePagination}
        page={defaultParams.page}
        rowsPerPage={defaultParams.count}
        count={props.groupTotal}
      />
    </React.Fragment>
  );
}

AdminGroupList.propTypes = {
  intl: intlShape.isRequired,
  defaultParams: PropTypes.object,
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  groups: PropTypes.array,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  updateGroupPositionBegin: PropTypes.func,
  handleParentExpand: PropTypes.func,
  handleFinishExitTransition: PropTypes.func,
  isDisplayingChildren: PropTypes.bool,
  handlePagination: PropTypes.func,
  positions: PropTypes.array,
  importAction: PropTypes.func,
  customTexts: PropTypes.object
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles),
)(AdminGroupList);
