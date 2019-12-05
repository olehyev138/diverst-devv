/**
 *
 * News Feed Component
 *
 */

import React, {
  memo, useRef, useState, useEffect, useContext
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Box, Backdrop, Paper, Link,
  Button, Card, CardActions, CardContent, Grid, Typography,
} from '@material-ui/core';
import { SpeedDial, SpeedDialAction, SpeedDialIcon } from '@material-ui/lab';
import { withStyles } from '@material-ui/core/styles';

import MessageIcon from '@material-ui/icons/Message';
import NewsIcon from '@material-ui/icons/Description';
import SocialIcon from '@material-ui/icons/Share';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import GroupMessageListItem from 'components/News/GroupMessage/GroupMessageListItem';
import NewsLinkListItem from 'components/News/NewsLink/NewsLinkListItem';
import SocialLinkListItem from 'components/News/SocialLink/SocialLinkListItem';

import DiverstPagination from 'components/Shared/DiverstPagination';

import DiverstLoader from 'components/Shared/DiverstLoader';

const styles = theme => ({
  newsItem: {
    width: '100%',
  },
  errorButton: {
    color: theme.palette.error.main,
  },
  backdrop: {
    zIndex: 1,
  },
  speedDial: {
    float: 'right',
    marginBottom: 28,
    '& *': {
      zIndex: 1,
    },
  },
  speedDialButton: {
    zIndex: 2,
  },
});

export function NewsFeed(props) {
  const actions = [
    {
      icon: <MessageIcon />,
      name: 'Group Message',
      linkPath: props.links.groupMessageNew,
    },
    {
      icon: <NewsIcon />,
      name: 'News Link',
      linkPath: props.links.newsLinkNew,
    },
    {
      icon: <SocialIcon />,
      name: 'Social Link',
      linkPath: props.links.socialLinkNew,
    },
  ];

  const { classes } = props;
  const [speedDialOpen, setSpeedDialOpen] = React.useState(false);

  const handleSpeedDialOpen = () => setSpeedDialOpen(true);
  const handleSpeedDialClose = () => setSpeedDialOpen(false);

  /* Check news_feed_link type & render appropriate list item component */
  const renderNewsItem = (item) => {
    if (item.group_message)
      return (<GroupMessageListItem links={props.links} newsItem={item} readonly={props.readonly} groupId={item.news_feed.group_id} />);
    else if (item.news_link) // eslint-disable-line no-else-return
      return (<NewsLinkListItem links={props.links} newsLink={item.news_link} newsItem={item} groupId={item.news_feed.group_id} readonly={props.readonly} />);
    else if (item.social_link)
      return (<SocialLinkListItem socialLink={item.social_link} links={props.links} newsItem={item} groupId={item.news_feed.group_id} readonly={props.readonly} />);

    return undefined;
  };

  return (
    <React.Fragment>
      {!props.readonly && (
        <React.Fragment>
          <Backdrop open={speedDialOpen} className={classes.backdrop} />
          <SpeedDial
            ariaLabel='Add Item'
            className={classes.speedDial}
            icon={<SpeedDialIcon />}
            onClose={handleSpeedDialClose}
            onOpen={handleSpeedDialOpen}
            open={speedDialOpen}
            direction='left'
            FabProps={{
              className: classes.speedDialButton
            }}
          >
            {actions.map(action => (
              <SpeedDialAction
                component={WrappedNavLink}
                to={action.linkPath}
                key={action.name}
                icon={action.icon}
                tooltipTitle={<Typography>{action.name}</Typography>}
                tooltipPlacement='bottom'
                onClick={handleSpeedDialClose}
                PopperProps={{
                  disablePortal: true,
                }}
              />
            ))}
          </SpeedDial>
        </React.Fragment>
      )}
      <DiverstLoader isLoading={props.isLoading}>
        <Grid container>
          { /* eslint-disable-next-line arrow-body-style */ }
          {props.newsItems && Object.values(props.newsItems).map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.newsItem}>
                {renderNewsItem(item)}
                <Box mb={3} />
              </Grid>
            );
          })}
        </Grid>
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isLoading}
        rowsPerPage={props.defaultParams.count}
        count={props.newsItemsTotal}
        handlePagination={props.handlePagination}
      />
    </React.Fragment>
  );
}

NewsFeed.propTypes = {
  defaultParams: PropTypes.object,
  classes: PropTypes.object,
  newsItems: PropTypes.array,
  newsItemsTotal: PropTypes.number,
  handlePagination: PropTypes.func,
  isLoading: PropTypes.bool,
  links: PropTypes.shape({
    groupMessageNew: PropTypes.string,
    newsLinkNew: PropTypes.string,
    socialLinkNew: PropTypes.string,

  }),
  readonly: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(NewsFeed);
