import React, { memo, useState } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button, Box, Card, CardContent, Link, Hidden, Divider, CardActions, CardActionArea
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import PublicIcon from '@material-ui/icons/Public';
import FolderIcon from '@material-ui/icons/Folder';
import LockIcon from '@material-ui/icons/Lock';
import OpenInNew from '@material-ui/icons/OpenInNew';

import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import folderMessages from 'containers/Resource/Folder/messages';
import resourceMessages from 'containers/Resource/Resource/messages';

import { injectIntl, intlShape } from 'react-intl';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

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
});

export function FolderListItem(props) {
  const { classes } = props;
  const item = dig(props, 'item');
  const isResource = dig(props, 'isResource');

  const linkProps = isResource ? {
    href: item.url,
    target: '_blank',
    rel: 'noopener',
    className: classes.folderLink,
  } : {
    component: WrappedNavLink,
    to: props.links.folderShow(item),
    className: classes.folderLink,
  };
  return (
    <React.Fragment>
      {item && (
        <Card>
          <Link {...linkProps} className={classes.link}>
            <CardActionArea>
              <CardContent>
                <Grid container spacing={1} alignItems='center'>
                  <Grid item>
                    {isResource ? (
                      <React.Fragment>
                        <PublicIcon />
                      </React.Fragment>
                    ) : (
                      <React.Fragment>
                        <FolderIcon />
                        {item.password_protected && (
                          <LockIcon />
                        )}
                      </React.Fragment>
                    )}
                  </Grid>
                  <Grid item xs={!(isResource && item.url)}>
                    <Typography color='primary' variant='h6' component='h2'>
                      {isResource ? item.title : item.name}
                    </Typography>
                  </Grid>
                  {isResource && item.url && (
                    <Grid item xs>
                      <OpenInNew color='secondary' fontSize='small' />
                    </Grid>
                  )}
                </Grid>
              </CardContent>
            </CardActionArea>
            <Divider />
          </Link>
          <CardActions>
            <Button
              color='primary'
              className={classes.folderLink}
              component={WrappedNavLink}
              to={isResource ? props.links.resourceEdit(item) : props.links.folderEdit(item)}
            >
              <DiverstFormattedMessage {...(isResource ? resourceMessages.edit : folderMessages.edit)} />
            </Button>
            {(isResource) && (
              <Button
                className={classes.folderLink}
                color='primary'
                onClick={() => {
                  alert("click")
                }}
              >
                <DiverstFormattedMessage {...resourceMessages.archive} />
              </Button>
)}
            {(isResource || !item.password_protected) && (
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
  isResource: PropTypes.bool,
  deleteAction: PropTypes.func,
  intl: intlShape.isRequired,
  links: PropTypes.shape({
    folderShow: PropTypes.func,
    folderEdit: PropTypes.func,
    resourceEdit: PropTypes.func,
  })
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(FolderListItem);
