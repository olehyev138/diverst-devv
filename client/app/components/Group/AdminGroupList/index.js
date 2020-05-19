/**
 *
 * AdminGroupList List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';
import { injectIntl, intlShape } from 'react-intl';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse, Box, CircularProgress, Hidden,
  Dialog, DialogContent
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import { Formik, Form, Field } from 'formik';

import AddIcon from '@material-ui/icons/Add';
import ReorderIcon from '@material-ui/icons/Reorder';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import { DroppableList } from '../../Shared/DragAndDrop/DroppableLocations/DroppableList';

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
  const { classes, defaultParams, intl } = props;
  const [order, setOrder] = useState(false);
  const [save, setSave] = useState(false);
  const [expandedGroups, setExpandedGroups] = useState({});

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to={ROUTES.admin.manage.groups.new.path()}
            color='primary'
            size='large'
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.new} />
          </Button>
          { order ? (
            <Button
              variant='contained'
              color='primary'
              size='large'
              startIcon={<ReorderIcon />}
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
              onClick={() => {
                setSave(false);
                setOrder(true);
              }}
            >
              <DiverstFormattedMessage {...messages.change_order} />
            </Button>
          )
          }
        </Grid>
      </Grid>
      <Box mb={1} />
      <DiverstLoader isLoading={props.isLoading}>
        <DroppableList
          items={props.groups}
          classes={classes}
          draggable={order}
          save={save}
          updateGroupPositionBegin={props.updateGroupPositionBegin}
          currentPage={defaultParams.page}
          importAction={props.importAction}
        />
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isLoading}
        handlePagination={props.handlePagination}
        rowsPerPage={defaultParams.count}
        count={props.groupTotal}
      />
    </React.Fragment>
  );
}

AdminGroupList.propTypes = {
  intl: intlShape,
  defaultParams: PropTypes.object,
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  groups: PropTypes.array,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  updateGroupPositionBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  importAction: PropTypes.func,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles),
)(AdminGroupList);
