import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button, Box, Card, CardContent, Link, Hidden, Divider
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';
import PublicIcon from '@material-ui/icons/Public';
import FolderIcon from '@material-ui/icons/Folder';

import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Resource/Folder/messages';
import { FormattedMessage } from 'react-intl';

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

  const { classes } = props;
  const folder = dig(props, 'folder');

  return (
    (folder) ? (
      <React.Fragment>
        <Grid container spacing={3}>
          <Grid item>
            <Typography color='primary' variant='h5' component='h2' className={classes.title}>
              {folder.name}
            </Typography>
          </Grid>
          <Grid item sm>
            <Button
              variant='contained'
              to={props.links.folderEdit(folder.id)}
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
              to={props.links.folderNew}
              color='primary'
              size='large'
              component={WrappedNavLink}
            >
              <FormattedMessage {...messages.show.addFolder} />
            </Button>
          </Grid>
        </Grid>
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
                          <Link
                            className={classes.folderLink}
                            component={WrappedNavLink}
                            to={props.links.folderEdit(item.id)}
                          >
                            <Typography color='textSecondary'>
                              <FormattedMessage {...messages.edit} />
                            </Typography>
                          </Link>

                          <Link
                            className={classes.folderLink}
                            component={WrappedNavLink}
                            to={props.links.folderEdit(item.id)}
                          >
                            <Typography color='error'>
                              <FormattedMessage {...messages.delete} />
                            </Typography>
                          </Link>
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
        {props.folders && props.folders.length > 0
        && props.resources && props.resources.length > 0 && (
          <React.Fragment>
            <Box pb={2} />
            <Divider variant='middle' />
            <Box pb={2} />
          </React.Fragment>
        )}
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
                          <Link
                            className={classes.folderLink}
                            component={WrappedNavLink}
                            to={props.links.resourceEdit(item.id)}
                          >
                            <Typography color='textSecondary'>
                              {'TODO MESSAGES: Edit Resource'}
                            </Typography>
                          </Link>

                          <Link
                            className={classes.folderLink}
                            component={WrappedNavLink}
                            to={props.links.resourceEdit(item.id)}
                          >
                            <Typography color='error'>
                              {'TODO MESSAGES: Delete Resource'}
                            </Typography>
                          </Link>
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
        {props.folders && props.folders.length <= 0
        && props.resources && props.resources.length <= 0 && (
          <React.Fragment>
            <Grid item sm>
              <Box mt={3} />
              <Typography variant='h6' align='center' color='textSecondary'>
                {'TODO MESSAGES: There are currently no Resources or Sub-Folders'}
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
  classes: PropTypes.object,
  folder: PropTypes.object,
  folders: PropTypes.array,
  resources: PropTypes.array,
  currentUserId: PropTypes.number,
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
  withStyles(styles)
)(Folder);
