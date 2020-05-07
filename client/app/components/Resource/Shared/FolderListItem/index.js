import React, { memo, useState } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Typography, Grid, Button, Card, CardContent, Link, Divider, CardActions, CardActionArea, CircularProgress
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import PublicIcon from '@material-ui/icons/Public';
import FolderIcon from '@material-ui/icons/Folder';
import LockIcon from '@material-ui/icons/Lock';
import OpenInNewIcon from '@material-ui/icons/OpenInNew';
import FileIcon from '@material-ui/icons/Description';
import DownloadIcon from '@material-ui/icons/GetApp';

import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import folderMessages from 'containers/Resource/Folder/messages';
import resourceMessages from 'containers/Resource/Resource/messages';

import { injectIntl, intlShape } from 'react-intl';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  link: {
    textDecoration: 'none !important',
  },
  arrowRight: {
    color: theme.custom.colors.grey,
    marginRight: 8,
  },
  deleteButton: {
    color: theme.palette.error.main,
  },
  downloadProgress: {
    verticalAlign: 'middle',
  },
});

export function FolderListItem(props) {
  const { classes } = props;
  const item = dig(props, 'item');
  const isResource = dig(props, 'isResource');

  let linkProps;
  if (isResource)
    if (item.file_file_path)
      linkProps = {
        disabled: props.isDownloadingFileData,
        onClick: () => {
          props.setFileName(item.file_file_name);
          props.getFileDataBegin(item.file_file_path);
        },
      };
    else
      linkProps = {
        href: item.url,
        target: '_blank',
        rel: 'noopener',
        className: classes.folderLink,
      };
  else
    linkProps = {
      component: WrappedNavLink,
      to: props.links.folderShow(item),
      className: classes.folderLink,
    };

  return (
    <React.Fragment>
      {item && (
        <Card>
          <Link {...linkProps} className={classes.link}>
            <CardActionArea disabled={props.isDownloadingFileData}>
              <CardContent>
                <Grid container spacing={1} alignItems='center'>
                  <Grid item>
                    {/* eslint-disable-next-line no-nested-ternary */}
                    {isResource
                      ? item.resource_type === 'file' ? (
                        <FileIcon />
                      ) : (
                        <PublicIcon />
                      )
                      : (
                        <React.Fragment>
                          <FolderIcon />
                          {item.password_protected && (
                            <LockIcon />
                          )}
                        </React.Fragment>
                      )}
                  </Grid>

                  <Grid item>
                    <Typography color='primary' variant='h6' component='h2'>
                      {isResource ? item.title : item.name}
                    </Typography>
                  </Grid>

                  {isResource && (
                    <Grid item xs>
                      {item.resource_type === 'file' ? (
                        <DownloadIcon color='secondary' />
                      ) : (
                        <OpenInNewIcon color='secondary' fontSize='small' />
                      )}
                    </Grid>
                  )}

                  {isResource && item.resource_type === 'file' && props.isDownloadingFileData && props.fileName && (
                    <Grid item>
                      <CircularProgress size={30} color='primary' className={classes.downloadProgress} />
                    </Grid>
                  )}
                </Grid>
              </CardContent>
            </CardActionArea>
            <Divider />
          </Link>
          <CardActions>
            <Permission show={permission(item, 'update?')}>
              <Button
                color='primary'
                className={classes.folderLink}
                component={WrappedNavLink}
                to={isResource ? props.links.resourceEdit(item) : props.links.folderEdit(item)}
              >
                <DiverstFormattedMessage {...(isResource ? resourceMessages.edit : folderMessages.edit)} />
              </Button>
            </Permission>
            {(isResource) && (
              <Permission show={permission(props.currentGroup, 'resources_manage?')}>
                <Button
                  className={classes.folderLink}
                  color='primary'
                  onClick={() => {
                    props.archiveResourceBegin({
                      id: item.id,
                    });
                  }}
                >
                  <DiverstFormattedMessage {...resourceMessages.archive} />
                </Button>
              </Permission>
            )}
            {(isResource || !item.password_protected) && (
              <Permission show={permission(item, 'destroy?')}>
                <Button
                  className={classNames(classes.folderLink, classes.deleteButton)}
                  onClick={() => {
                    // eslint-disable-next-line no-restricted-globals,no-alert
                    if (confirm(props.intl.formatMessage(isResource ? resourceMessages.confirm_delete : folderMessages.confirm_delete)))
                      props.deleteAction({
                        id: item.id,
                        folder: isResource ? item.folder : item,
                      });
                  }}
                >
                  <DiverstFormattedMessage {...(isResource ? resourceMessages.delete : folderMessages.delete)} />
                </Button>
              </Permission>
            )}
          </CardActions>
        </Card>
      )}
    </React.Fragment>
  );
}

FolderListItem.propTypes = {
  classes: PropTypes.object,
  item: PropTypes.object,
  currentGroup: PropTypes.object,
  isResource: PropTypes.bool,
  deleteAction: PropTypes.func,
  archiveResourceBegin: PropTypes.func,
  intl: intlShape.isRequired,
  links: PropTypes.shape({
    folderShow: PropTypes.func,
    folderEdit: PropTypes.func,
    resourceEdit: PropTypes.func,
  }),
  isDownloadingFileData: PropTypes.bool,
  getFileDataBegin: PropTypes.func,
  fileName: PropTypes.string,
  setFileName: PropTypes.func,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(FolderListItem);
