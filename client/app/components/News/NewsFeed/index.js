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
  Button, Card, CardActions, CardContent, Grid, Tab, Typography,
} from '@material-ui/core';
import { SpeedDial, SpeedDialAction, SpeedDialIcon } from '@material-ui/lab';
import { withStyles } from '@material-ui/core/styles';
import MessageIcon from '@material-ui/icons/Message';
import NewsIcon from '@material-ui/icons/Description';
import SocialIcon from '@material-ui/icons/Share';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
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
      return (
        <GroupMessageListItem
          links={props.links}
          newsItem={item}
          readonly={props.readonly}
          groupId={item.news_feed.group_id}
          deleteGroupMessageBegin={props.deleteGroupMessageBegin}
          updateNewsItemBegin={props.updateNewsItemBegin}
        />
      );
    else if (item.news_link) // eslint-disable-line no-else-return
      return (
        <div>
          <NewsLinkListItem
            links={props.links}
            newsLink={item.news_link}
            newsItem={item}
            groupId={item.news_feed.group_id}
            readonly={props.readonly}
            deleteNewsLinkBegin={props.deleteNewsLinkBegin}
            updateNewsItemBegin={props.updateNewsItemBegin}
            likeNewsItemBegin={props.likeNewsItemBegin}
            unlikeNewsItemBegin={props.unlikeNewsItemBegin}

          />
        </div>
      );
    else if (item.social_link)
      return (
        <SocialLinkListItem
          socialLink={item.social_link}
          links={props.links}
          newsItem={item}
          groupId={item.news_feed.group_id}
          readonly={props.readonly}
          deleteSocialLinkBegin={props.deleteSocialLinkBegin}
          updateNewsItemBegin={props.updateNewsItemBegin}
        />
      );

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
          <Paper>
            <ResponsiveTabs
              value={props.currentTab}
              onChange={props.handleChangeTab}
              indicatorColor='primary'
              textColor='primary'
            >
              <Tab label='APPROVED' />
              <Tab label='PENDING APPROVAL' />
            </ResponsiveTabs>
          </Paper>
        </React.Fragment>
      )}
      <br />
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
  currentTab: PropTypes.number,
  handleChangeTab: PropTypes.func,
  classes: PropTypes.object,
  newsItems: PropTypes.array,
  newsItemsTotal: PropTypes.number,
  handlePagination: PropTypes.func,
  isLoading: PropTypes.bool,
  links: PropTypes.object,
  readonly: PropTypes.bool,
  deleteGroupMessageBegin: PropTypes.func,
  deleteNewsLinkBegin: PropTypes.func,
  deleteSocialLinkBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
  likeNewsItemBegin: PropTypes.func,
  unlikeNewsItemBegin: PropTypes.func,

};

export default compose(
  memo,
  withStyles(styles)
)(NewsFeed);
