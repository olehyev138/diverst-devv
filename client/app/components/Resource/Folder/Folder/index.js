import React, { memo, useState } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button, Box, Card, CardContent, Link, Hidden, Divider
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import PublicIcon from '@material-ui/icons/Public';
import FolderIcon from '@material-ui/icons/Folder';
import LockIcon from '@material-ui/icons/Lock';

import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import Pagination from 'components/Shared/Pagination';

import messages from 'containers/Resource/Folder/messages';
import resourceMessages from 'containers/Resource/Resource/messages';

import { FormattedMessage, injectIntl, intlShape } from 'react-intl';

import { formatDateTimeString, DateTime } from 'utils/dateTimeHelpers';
import KeyboardArrowRightIcon from '@material-ui/core/SvgIcon/SvgIcon';

const styles = theme => ({
  folderListItem: {
    width: '100%',
  },
  padding: {
    padding: theme.spacing(3, 2),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  data: {
    '&:not(:last-of-type)': { // Prevent last data item from adding bottom padding
      paddingBottom: theme.spacing(3),
    },
  },
  buttons: {
    marginLeft: 20,
    float: 'right',
  },
  deleteButton: {
    backgroundColor: theme.palette.error.main,
  },
});

export function Folder(props) {
  /* Render an Folder */

  const [foldPage, setFoldPage] = useState(0);
  const [resPage, setResPage] = useState(0);

  const [rowsPerFoldPage, setRowsPerFoldPage] = useState(5);
  const [rowsPerResPage, setRowsPerResPage] = useState(5);

  const { classes } = props;
  const folder = dig(props, 'folder');

  const handleFolderChangePage = (folder, newPage) => {
    setFoldPage(newPage);
    props.handleFolderPagination({ count: rowsPerFoldPage, page: newPage });
  };

  const handleFolderChangeRowsPerPage = (folder) => {
    const topIndex = rowsPerFoldPage * foldPage;
    setRowsPerFoldPage(+folder.target.value);
    const newPage = Math.ceil(topIndex / +folder.target.value);
    setFoldPage(newPage);
    props.handleFolderPagination({ count: +folder.target.value, newPage });
  };

  const handleResourceChangePage = (resource, newPage) => {
    setResPage(newPage);
    props.handleResourcePagination({ count: rowsPerResPage, page: newPage });
  };

  const handleResourceChangeRowsPerPage = (resource) => {
    const topIndex = rowsPerResPage * foldPage;
    setRowsPerResPage(+resource.target.value);
    const newPage = Math.ceil(topIndex / +resource.target.value);
    setResPage(newPage);
    props.handleResourcePagination({ count: +resource.target.value, newPage });
  };

  return (
    (folder) ? (
      <React.Fragment>
        {/* Buttons */}
        <Grid container spacing={1}>
          <Grid item>
            <Typography color='primary' variant='h5' component='h2' className={classes.title}>
              {folder.name}
            </Typography>
          </Grid>
          <Grid item sm>
            <Button
              variant='contained'
              to={{
                pathname: props.links.folderEdit(folder.id),
                fromFolder: {
                  folder,
                  action: 'edit'
                },
              }}
              color='primary'
              size='large'
              component={WrappedNavLink}
              className={classes.buttons}
            >
              <FormattedMessage {...messages.edit} />
            </Button>
          </Grid>

          <Grid item>
            <Button
              variant='contained'
              to={{
                pathname: props.links.folderNew,
                fromFolder: {
                  folder,
                  action: 'new'
                },
              }}
              color='primary'
              size='large'
              component={WrappedNavLink}
              className={classes.buttons}
            >
              <FormattedMessage {...messages.show.addFolder} />
            </Button>
          </Grid>

          <Grid item>
            <Button
              variant='contained'
              to={{
                pathname: props.links.resourceNew,
                fromFolder: {
                  folder,
                  action: 'new'
                },
              }}
              color='primary'
              size='large'
              component={WrappedNavLink}
              className={classes.buttons}
            >
              <FormattedMessage {...messages.show.addResource} />
            </Button>
          </Grid>

          <Grid item>
            <Button
              variant='contained'
              color='primary'
              size='large'
              className={classNames(classes.buttons, classes.deleteButton)}
              onClick={() => {
                // eslint-disable-next-line no-restricted-globals,no-alert
                if (confirm(props.intl.formatMessage(messages.confirm_delete)))
                  props.deleteFolderBegin({
                    id: folder.id,
                    folder,
                  });
              }}
            >
              <FormattedMessage {...messages.delete} />
            </Button>
          </Grid>
        </Grid>
        {/* Parent */}
        <Grid container spacing={3}>
          <Grid item>
            <Button
              variant='contained'
              to={folder.parent_id ? props.links.folderShow(folder.parent_id) : props.links.foldersIndex}
              color='primary'
              size='large'
              component={WrappedNavLink}
            >
              <FormattedMessage {...messages.show.parent} />
            </Button>
          </Grid>
        </Grid>
        <Box mb={2} />

        <Divider />

        <Box mb={2} />
        {/* Sub Folders */}
        <Grid container spacing={1}>
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
                          to={props.links.folderShow(item.id)}
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
                            to={props.links.folderEdit(item.id)}
                          >
                            <Typography color='textSecondary'>
                              <FormattedMessage {...messages.edit} />
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
                                <FormattedMessage {...messages.delete} />
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
        </Grid>
        {props.folders && props.folders.length > 0 && (
          <Pagination
            page={foldPage}
            rowsPerPage={rowsPerFoldPage}
            count={props.foldersTotal}
            onChangePage={handleFolderChangePage}
            onChangeRowsPerPage={handleFolderChangeRowsPerPage}
          />
        )}
        {props.folders && props.folders.length > 0
        && props.resources && props.resources.length > 0 && (
          <React.Fragment>
            <Box pb={2} />
            <Divider variant='middle' />
            <Box pb={2} />
          </React.Fragment>
        )}

        { /* Resources */ }
        <Grid container spacing={1}>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.resources && Object.values(props.resources).map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.folderListItem}>
                {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                <Card>
                  <CardContent>
                    <Grid container spacing={1} justify='space-between' alignItems='center'>
                      <Grid item xs>
                        { item.url && (
                          <Link
                            href={item.url}
                            target='_blank'
                            rel='noopener'
                          >
                            <Grid container spacing={1}>
                              <Grid item>
                                <PublicIcon />
                              </Grid>
                              <Grid item xs>
                                <Typography color='primary' variant='h6' component='h2'>
                                  {item.title}
                                </Typography>
                              </Grid>
                            </Grid>
                          </Link>
                        )}
                        <hr className={classes.divider} />
                        <React.Fragment>
                          <Button
                            className={classes.folderLink}
                            component={WrappedNavLink}
                            to={props.links.resourceEdit(item.id)}
                          >
                            <Typography color='textSecondary'>
                              <FormattedMessage {...resourceMessages.edit} />
                            </Typography>
                          </Button>

                          <Button
                            className={classes.folderLink}
                            onClick={() => {
                              // eslint-disable-next-line no-restricted-globals,no-alert
                              if (confirm(props.intl.formatMessage(resourceMessages.confirm_delete)))
                                props.deleteResourceBegin({
                                  id: item.id,
                                  folder: item.folder,
                                });
                            }}
                          >
                            <Typography color='error'>
                              <FormattedMessage {...resourceMessages.delete} />
                            </Typography>
                          </Button>
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
        </Grid>
        {props.resources && props.resources.length > 0 && (
          <Pagination
            page={resPage}
            rowsPerPage={rowsPerResPage}
            count={props.resourcesTotal}
            onChangePage={handleResourceChangePage}
            onChangeRowsPerPage={handleResourceChangeRowsPerPage}
          />
        )}

        {props.folders && props.folders.length <= 0
        && props.resources && props.resources.length <= 0 && (
          <React.Fragment>
            <Grid item sm>
              <Box mt={3} />
              <Typography variant='h6' align='center' color='textSecondary'>
                <FormattedMessage {...messages.show.empty} />
              </Typography>
            </Grid>
          </React.Fragment>
        )}
      </React.Fragment>
    ) : (
      <React.Fragment />
    )
  );
}

Folder.propTypes = {
  deleteFolderBegin: PropTypes.func,
  deleteResourceBegin: PropTypes.func,
  classes: PropTypes.object,
  folder: PropTypes.object,
  folders: PropTypes.array,
  foldersTotal: PropTypes.number,
  resources: PropTypes.array,
  resourcesTotal: PropTypes.number,
  currentUserId: PropTypes.number,
  handleFolderPagination: PropTypes.func,
  handleResourcePagination: PropTypes.func,
  intl: intlShape.isRequired,
  links: PropTypes.shape({
    foldersIndex: PropTypes.string,
    folderNew: PropTypes.string,
    folderShow: PropTypes.func,
    folderEdit: PropTypes.func,
    resourceEdit: PropTypes.func,
    resourceNew: PropTypes.string,
  })
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(Folder);
