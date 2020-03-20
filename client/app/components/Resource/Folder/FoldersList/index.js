/**
 *
 * Folders List Component
 *
 */

import React, { memo, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import withStyles from '@material-ui/core/styles/withStyles';
import classNames from 'classnames';

import {
  Box, Tab, Paper, Card, CardContent, Grid, Link, Typography, Button, Hidden, CardActions, Divider
} from '@material-ui/core';

import KeyboardArrowRightIcon from '@material-ui/icons/KeyboardArrowRight';

import AddIcon from '@material-ui/icons/Add';
import FolderIcon from '@material-ui/icons/Folder';
import LockIcon from '@material-ui/icons/Lock';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Resource/Folder/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstLoader from 'components/Shared/DiverstLoader';

import FolderListItem from 'components/Resource/Shared/FolderListItem';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  folderListItem: {
    width: '100%',
  },
  arrowRight: {
    color: theme.custom.colors.grey,
    marginRight: 8,
  },
  folderLink: {
    '&:hover': {
      textDecoration: 'none',
    },
    '&:hover h2': {
      textDecoration: 'underline',
    },
  },
  folderDeleteLink: {
    color: theme.palette.error.main,
  },
  dateText: {
    fontWeight: 'bold',
  },
  floatRight: {
    float: 'right',
  },
  floatSpacer: {
    display: 'flex',
    width: '100%',
    marginBottom: 24,
  },
});

export function FoldersList(props, context) {
  const { classes, intl } = props;

  const routeContext = useContext(RouteContext);

  return (
    <React.Fragment>
      <Permission show={permission(props.currentGroup, 'resources_create?')} className={classes.floatRight}>
        <Button
          className={classes.floatRight}
          variant='contained'
          to={props.links.folderNew}
          color='primary'
          size='large'
          component={WrappedNavLink}
          startIcon={<AddIcon />}
        >
          <DiverstFormattedMessage {...messages.new} />
        </Button>
      </Permission>
      <Box className={classes.floatSpacer} />

      <DiverstLoader isLoading={props.isLoading}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.folders && Object.values(props.folders).map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.folderListItem}>
                <FolderListItem
                  item={item}
                  deleteAction={props.deleteFolderBegin}
                  links={props.links}
                />
              </Grid>
            );
          })}
          {props.folders && props.folders.length <= 0 && (
            <React.Fragment>
              <Grid item sm>
                <Box mt={3} />
                <Typography variant='h6' align='center' color='textSecondary'>
                  <DiverstFormattedMessage {...messages.index.emptySection} />
                </Typography>
              </Grid>
            </React.Fragment>
          )}
          {props.folders == null && (
            <React.Fragment>
              <Grid item sm>
                <Box mt={3} />
                <Typography variant='h6' align='center' color='textSecondary'>
                  <DiverstFormattedMessage {...messages.index.loading} />
                </Typography>
              </Grid>
            </React.Fragment>
          )}
        </Grid>
      </DiverstLoader>
      {props.folders && props.folders.length > 0 && (
        <DiverstPagination
          isLoading={props.isLoading}
          count={props.foldersTotal}
          handlePagination={props.handlePagination}
        />
      )}
    </React.Fragment>
  );
}

FoldersList.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  folders: PropTypes.array,
  foldersTotal: PropTypes.number,
  currentTab: PropTypes.number,
  handleChangeTab: PropTypes.func,
  handlePagination: PropTypes.func,
  isLoading: PropTypes.bool,
  links: PropTypes.object,
  deleteFolderBegin: PropTypes.func,
  currentGroup: PropTypes.object,
};

export default compose(
  injectIntl,
  withStyles(styles),
  memo,
)(FoldersList);
