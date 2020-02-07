import React, { memo, useState } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button, Box, Card, CardContent, Link, Hidden, Divider, CardActions
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';
import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import GoToParentIcon from '@material-ui/icons/SubdirectoryArrowLeft';
import PublicIcon from '@material-ui/icons/Public';
import FolderIcon from '@material-ui/icons/Folder';
import LockIcon from '@material-ui/icons/Lock';

import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import DiverstPagination from 'components/Shared/DiverstPagination';

import messages from 'containers/Resource/Folder/messages';
import resourceMessages from 'containers/Resource/Resource/messages';

import { injectIntl, intlShape } from 'react-intl';

import KeyboardArrowRightIcon from '@material-ui/core/SvgIcon/SvgIcon';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstLoader from 'components/Shared/DiverstLoader';

import FolderListItem from 'components/Resource/Shared/FolderListItem';
import DiverstShowLoader from 'components/Shared/DiverstShowLoader';

const styles = theme => ({
  folderListItem: {
    width: '100%',
  },
  parentIcon: {
    transform: 'rotate(90deg)',
  },
  padding: {
    padding: theme.spacing(3, 2),
  },
  title: {
    fontWeight: 'bold',
    wordBreak: 'keep-all',
  },
  arrowRight: {
    color: theme.custom.colors.grey,
    marginRight: 8,
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  data: {
    '&:not(:last-of-type)': { // Prevent last data item from adding bottom padding
      paddingBottom: theme.spacing(3),
    },
  },
  deleteButton: {
    backgroundColor: theme.palette.error.main,
  },
  deleteTextButton: {
    color: theme.palette.error.main,
  },
});

export function Folder(props) {
  const { classes } = props;
  const folder = dig(props, 'folder');

  return (
    <DiverstShowLoader isLoading={props.isFormLoading} isError={!props.isFormLoading && !folder}>
      {folder && (
        <React.Fragment>
          {/* Buttons */}
          <Grid container spacing={3} alignItems='center' justify='flex-end'>
            <Grid item xs>
              <Typography color='primary' variant='h5' component='h2' className={classes.title}>
                {folder.name}
              </Typography>
            </Grid>

            <Grid item>
              <Button
                variant='contained'
                to={props.links.resourceNew}
                color='primary'
                size='large'
                component={WrappedNavLink}
                className={classes.buttons}
                startIcon={<AddIcon />}
              >
                <DiverstFormattedMessage {...messages.show.addResource} />
              </Button>
            </Grid>

            <Grid item>
              <Button
                variant='contained'
                to={props.links.folderNew}
                color='primary'
                size='large'
                component={WrappedNavLink}
                className={classes.buttons}
                startIcon={<AddIcon />}
              >
                <DiverstFormattedMessage {...messages.show.addFolder} />
              </Button>
            </Grid>

            <Grid item>
              <Button
                variant='contained'
                to={{
                  pathname: props.links.folderEdit(folder),
                  fromFolder: {
                    folder,
                    action: 'edit'
                  },
                }}
                color='primary'
                size='large'
                component={WrappedNavLink}
                className={classes.buttons}
                startIcon={<EditIcon />}
              >
                <DiverstFormattedMessage {...messages.edit} />
              </Button>
            </Grid>

            <Grid item>
              <Button
                variant='contained'
                color='primary'
                size='large'
                className={classNames(classes.buttons, classes.deleteButton)}
                startIcon={<DeleteIcon />}
                onClick={() => {
                  // eslint-disable-next-line no-restricted-globals,no-alert
                  if (confirm(props.intl.formatMessage(messages.confirm_delete)))
                    props.deleteFolderBegin({
                      id: folder.id,
                      folder,
                    });
                }}
              >
                <DiverstFormattedMessage {...messages.delete} />
              </Button>
            </Grid>
          </Grid>
          <Box mb={2} />
          <Divider />
          <Box mb={2} />
          <DiverstLoader isLoading={props.isLoading}>
            {/* Parent */}
            <Grid container spacing={3}>
              <Grid item>
                <Button
                  variant='contained'
                  to={props.links.parentFolder}
                  color='primary'
                  size='large'
                  component={WrappedNavLink}
                  startIcon={<GoToParentIcon className={classes.parentIcon} />}
                >
                  <DiverstFormattedMessage {...messages.show.parent} />
                </Button>
              </Grid>
            </Grid>
            <Box mb={2} />
            {/* Sub Folders */}
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
            </Grid>

            {props.folders && props.folders.length <= 0
            && props.resources && props.resources.length <= 0 && (
              <React.Fragment>
                <Grid item sm>
                  <Box mt={3} />
                  <Typography variant='h6' align='center' color='textSecondary'>
                    <DiverstFormattedMessage {...messages.show.empty} />
                  </Typography>
                </Grid>
              </React.Fragment>
            )}
          </DiverstLoader>
          {props.folders && props.folders.length > 0 && (
            <DiverstPagination
              isLoading={props.isLoading}
              count={props.foldersTotal}
              handlePagination={props.handleFolderPagination}
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

          <DiverstLoader isLoading={props.isLoading}>
            { /* Resources */}
            <Grid container spacing={3}>
              { /* eslint-disable-next-line arrow-body-style */}
              {props.resources && Object.values(props.resources).map((item, i) => {
                return (
                  <Grid item key={item.id} className={classes.folderListItem}>
                    <FolderListItem
                      item={item}
                      isResource
                      deleteAction={props.deleteResourceBegin}
                      archiveResourceBegin={props.archiveResourceBegin}
                      links={props.links}
                    />
                  </Grid>
                );
              })}
            </Grid>
          </DiverstLoader>
          {props.resources && props.resources.length > 0 && (
            <DiverstPagination
              isLoading={props.isLoading}
              count={props.resourcesTotal}
              handlePagination={props.handleResourcePagination}
            />
          )}
        </React.Fragment>
      )}
    </DiverstShowLoader>
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
  archiveResourceBegin: PropTypes.func,
  intl: intlShape.isRequired,
  isLoading: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    foldersIndex: PropTypes.string,
    folderNew: PropTypes.object,
    parentFolder: PropTypes.string,
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
