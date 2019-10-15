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

const styles = theme => ({
  folderListItem: {
    width: '100%',
  },
  arrowRight: {
    color: theme.custom.colors.grey,
    marginRight: 8,
  },
  divider: {
    marginTop: 12,
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
      <Box className={classes.floatSpacer} />

      <DiverstLoader isLoading={props.isLoading}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.folders && Object.values(props.folders).map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.folderListItem}>
                {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                <Card>
                  <Grid container spacing={1} justify='space-between' alignItems='center'>
                    <Grid item xs>
                      <CardContent>
                        <Link
                          className={classes.folderLink}
                          component={WrappedNavLink}
                          to={props.links.folderShow(item)}
                        >
                          <Grid container spacing={1} alignItems='center'>
                            <Grid item>
                              <FolderIcon />
                              { item.password_protected && (
                                <LockIcon />
                              )}
                            </Grid>
                            <Grid item xs>
                              <Typography color='primary' variant='h6' component='h2'>
                                {item.name}
                              </Typography>
                            </Grid>
                          </Grid>
                        </Link>
                        <Divider className={classes.divider} />
                      </CardContent>
                      <CardActions>
                        <Button
                          size='small'
                          color='primary'
                          className={classes.folderLink}
                          component={WrappedNavLink}
                          to={props.links.folderEdit(item)}
                        >
                          <DiverstFormattedMessage {...messages.edit} />
                        </Button>

                        { !item.password_protected && (
                          <Button
                            size='small'
                            className={classNames(classes.folderLink, classes.folderDeleteLink)}
                            onClick={() => {
                              // eslint-disable-next-line no-restricted-globals,no-alert
                              if (confirm(props.intl.formatMessage(messages.confirm_delete)))
                                props.deleteFolderBegin({
                                  id: item.id,
                                  folder: item,
                                });
                            }}
                          >
                            <DiverstFormattedMessage {...messages.delete} />
                          </Button>
                        )}
                      </CardActions>
                    </Grid>
                    <Hidden xsDown>
                      <Grid item>
                        <KeyboardArrowRightIcon className={classes.arrowRight} />
                      </Grid>
                    </Hidden>
                  </Grid>
                </Card>
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
                  Loading...
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
};

export default compose(
  injectIntl,
  withStyles(styles),
  memo,
)(FoldersList);
