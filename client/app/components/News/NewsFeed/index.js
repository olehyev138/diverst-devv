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

import Pagination from 'components/Shared/DiverstPagination';

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
      linkPath: props.links.groupMessageNew,
    },
    {
      icon: <SocialIcon />,
      name: 'Social Link',
      linkPath: props.links.groupMessageNew,
    },
  ];

  const { classes } = props;
  const [speedDialOpen, setSpeedDialOpen] = React.useState(false);

  const handleSpeedDialOpen = () => setSpeedDialOpen(true);
  const handleSpeedDialClose = () => setSpeedDialOpen(false);

  /* Check news_feed_link type & render appropriate list item component */
  const renderNewsItem = (item) => {
    if (item.group_message)
      return (<GroupMessageListItem links={props.links} newsItem={item} />);
    else if (item.news_link) // eslint-disable-line no-else-return
      return (<NewsLinkListItem newsLink={item.news_link} />);
    else if (item.social_link)
      return (<SocialLinkListItem socialLink={item.social_link} />);

    return undefined;
  };

  return (
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
      <Pagination
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
  links: PropTypes.shape({
    groupMessageNew: PropTypes.string
  })
};

export default compose(
  memo,
  withStyles(styles)
)(NewsFeed);
