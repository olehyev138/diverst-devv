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
import { Box, Divider, Grid, Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import DiverstLoader from 'components/Shared/DiverstLoader';
import { injectIntl, intlShape } from 'react-intl';
import { addScript } from 'utils/domHelper';
import renderNewsItem from 'utils/newsItemRender';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';

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
    addScript('https://www.instagram.com/embed.js');
    addScript('https://cdn.embedly.com/widgets/platform.js');
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
      try {
        window.FB.XFBML.parse();
        // eslint-disable-next-line no-empty
      } catch (e) {}
    if (window.twttr && window.twttr.ready())
      window.twttr.widgets.load();

    return () => {};
  }, [props.newsItems]);

  const { classes } = props;

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
                {renderNewsItem(item, props, true)}
              </Grid>
            );
          })}
          {props.newsItems && props.newsItems.length <= 0 && (
            <React.Fragment>
              <Grid item sm>
                <Box mt={3} />
                <Typography variant='h6' align='center' color='textSecondary'>
                  <DiverstFormattedMessage {...messages.emptySection} />
                </Typography>
              </Grid>
            </React.Fragment>
          )}
        </Grid>
      </DiverstLoader>
    </React.Fragment>
  );
}

NewsFeed.propTypes = {
  intl: intlShape.isRequired,
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
  unlikeNewsItemBegin: PropTypes.func,
  likeNewsItemBegin: PropTypes.func,
  enableLikes: PropTypes.bool,
  customTexts: PropTypes.object,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(NewsFeed);
