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

import {
  Box, Tab, Paper, Card, CardContent, Grid, Link, Typography, Button, Hidden,
} from '@material-ui/core';

import KeyboardArrowRightIcon from '@material-ui/icons/KeyboardArrowRight';

import FolderIcon from '@material-ui/icons/Folder';
import LockIcon from '@material-ui/icons/Lock';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Resource/Folder/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

const styles = theme => ({
  folderListItem: {
    width: '100%',
  },
  arrowRight: {
    color: theme.custom.colors.grey,
  },
  divider: {
    color: theme.custom.colors.lightGrey,
    backgroundColor: theme.custom.colors.lightGrey,
    border: 'none',
    height: '1px',
  },
  folderLink: {
    '&:hover': {
      textDecoration: 'none',
    },
    '&:hover h2': {
      textDecoration: 'underline',
    },
  },
  dateText: {
    fontWeight: 'bold',
  }
});

export function FoldersList(props, context) {
  const { classes, intl } = props;

  const routeContext = useContext(RouteContext);

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to={props.links.folderNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            <DiverstFormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={2} />

      <Grid container spacing={3}>
        { /* eslint-disable-next-line arrow-body-style */}
        {props.folders && Object.values(props.folders).map((item, i) => {
          return (
            <Grid item key={item.id} className={classes.folderListItem}>
              {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
              <Card>
                <CardContent>
                  <Grid container spacing={1} justify='space-between' alignItems='center'>
                    <Grid item xs>
                      <Link
                        className={classes.folderLink}
                        component={WrappedNavLink}
                        to={props.links.folderShow(item)}
                      >
                        <Grid container spacing={1}>
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
                      <hr className={classes.divider} />
                      <React.Fragment>
                        <Button
                          className={classes.folderLink}
                          component={WrappedNavLink}
                          to={props.links.folderEdit(item)}
                        >
                          <Typography color='textSecondary'>
                            <DiverstFormattedMessage {...messages.edit} />
                          </Typography>
                        </Button>

                        { !item.password_protected && (
                          <Button
                            className={classes.folderLink}
                            onClick={() => {
                              // eslint-disable-next-line no-restricted-globals,no-alert
                              if (confirm(props.intl.formatMessage(messages.confirm_delete)))
                                props.deleteFolderBegin({
                                  id: item.id,
                                  folder: item,
                                });
                            }}
                          >
                            <Typography color='error'>
                              <DiverstFormattedMessage {...messages.delete} />
                            </Typography>
                          </Button>
                        )}
                        <Box pb={1} />
                      </React.Fragment>
                    </Grid>
                    <Hidden xsDown>
                      <Grid item>
                        <KeyboardArrowRightIcon className={classes.arrowRight} />
                      </Grid>
                    </Hidden>
                  </Grid>
                </CardContent>
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
      {props.folders && props.folders.length > 0 && (
        <DiverstPagination
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
  links: PropTypes.object,
  deleteFolderBegin: PropTypes.func,
};

export default compose(
  injectIntl,
  withStyles(styles),
  memo,
)(FoldersList);
