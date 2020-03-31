/**
 *
 * News Feed Component
 *
 */

import React, {
  memo, useEffect,
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import {
  Box, Divider,
  Grid,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import MessageIcon from '@material-ui/icons/Message';
import NewsIcon from '@material-ui/icons/Description';
import SocialIcon from '@material-ui/icons/Share';
import GroupMessageListItem from 'components/News/GroupMessage/GroupMessageListItem';
import NewsLinkListItem from 'components/News/NewsLink/NewsLinkListItem';
import SocialLinkListItem from 'components/News/SocialLink/SocialLinkListItem';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';
import { injectIntl, intlShape } from 'react-intl';
import { addScript } from 'utils/domHelper';

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
  floatSpacer: {
    display: 'flex',
    width: '100%',
    marginBottom: 20,
  },
});

export function NewsFeed(props) {
  useEffect(() => {
    addScript('https://platform.twitter.com/widgets.js');
    addScript('http://www.instagram.com/embed.js');
    addScript('http://cdn.embedly.com/widgets/platform.js');
    addScript(
      'https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v6.0',
      { async: 1, defer: 1, crossorigin: 'anonymous' }
    );

    return () => {};
  }, []);

  useEffect(() => {
    if (window.instgrm)
      window.instgrm.Embeds.process();
    if (window.FB)
      window.FB.XFBML.parse();
    if (window.twttr && window.twttr.ready())
      window.twttr.widgets.load();

    return () => {};
  }, [props.newsItems]);

  const { classes } = props;

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
          archiveNewsItemBegin={props.archiveNewsItemBegin}
          pinNewsItemBegin={props.pinNewsItemBegin}
          unpinNewsItemBegin={props.unpinNewsItemBegin}
        />
      );
    else if (item.news_link) // eslint-disable-line no-else-return
      return (
        <NewsLinkListItem
          links={props.links}
          newsLink={item.news_link}
          newsItem={item}
          groupId={item.news_feed.group_id}
          readonly={props.readonly}
          deleteNewsLinkBegin={props.deleteNewsLinkBegin}
          updateNewsItemBegin={props.updateNewsItemBegin}
          archiveNewsItemBegin={props.archiveNewsItemBegin}
          pinNewsItemBegin={props.pinNewsItemBegin}
          unpinNewsItemBegin={props.unpinNewsItemBegin}
        />
      );
    else if (item.social_link)
      return (
        <SocialLinkListItem
          socialLink={item.social_link}
          links={props.links}
          newsItem={item}
          small
          groupId={item.news_feed.group_id}
          readonly={props.readonly}
          deleteSocialLinkBegin={props.deleteSocialLinkBegin}
          updateNewsItemBegin={props.updateNewsItemBegin}
          archiveNewsItemBegin={props.archiveNewsItemBegin}
          pinNewsItemBegin={props.pinNewsItemBegin}
          unpinNewsItemBegin={props.unpinNewsItemBegin}
        />
      );

    return undefined;
  };

  return (
    <React.Fragment>
      <DiverstLoader isLoading={props.isLoading}>
        <Grid container>
          { /* eslint-disable-next-line arrow-body-style */ }
          {props.newsItems && Object.values(props.newsItems).map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.newsItem}>
                <Box mb={1} />
                <Divider />
                <Box mb={1} />
                {renderNewsItem(item)}
              </Grid>
            );
          })}
        </Grid>
      </DiverstLoader>
    </React.Fragment>
  );
}

NewsFeed.propTypes = {
  intl: intlShape,
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
  archiveNewsItemBegin: PropTypes.func,
  pinNewsItemBegin: PropTypes.func,
  unpinNewsItemBegin: PropTypes.func,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(NewsFeed);
