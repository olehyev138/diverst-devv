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
  Box, Backdrop, Paper,
  Grid, Tab, Typography, Card
} from '@material-ui/core';
import { SpeedDial, SpeedDialAction, SpeedDialIcon } from '@material-ui/lab';
import { withStyles } from '@material-ui/core/styles';
import MessageIcon from '@material-ui/icons/Message';
import NewsIcon from '@material-ui/icons/Description';
import SocialIcon from '@material-ui/icons/Share';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';
import { injectIntl, intlShape } from 'react-intl';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import { addScript } from 'utils/domHelper';
import renderNewsItem from 'utils/newsItemRender';

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
      try {
        window.FB.XFBML.parse();
        // eslint-disable-next-line no-empty
      } catch (e) {}
    if (window.twttr && window.twttr.ready())
      window.twttr.widgets.load();

    return () => {};
  }, [props.newsItems]);


  const actions = [
    {
      icon: <MessageIcon />,
      name: <DiverstFormattedMessage {...messages.group_message} />,
      linkPath: props.links.groupMessageNew,
    },
    {
      icon: <NewsIcon />,
      name: <DiverstFormattedMessage {...messages.news_link} />,
      linkPath: props.links.newsLinkNew,
    },
  ];

  if (permission(props.currentGroup, 'social_link_create?'))
    actions.push({
      icon: <SocialIcon />,
      name: <DiverstFormattedMessage {...messages.social_link} />,
      linkPath: props.links.socialLinkNew,
    });

  const { classes } = props;
  const [speedDialOpen, setSpeedDialOpen] = React.useState(false);

  const handleSpeedDialOpen = () => setSpeedDialOpen(true);
  const handleSpeedDialClose = () => setSpeedDialOpen(false);

  return (
    <React.Fragment>
      {!props.readonly && (
        <React.Fragment>
          <Backdrop open={speedDialOpen} className={classes.backdrop} />
          <Permission show={permission(props.currentGroup, 'news_create?')}>
            <SpeedDial
              ariaLabel={props.intl.formatMessage(messages.add)}
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
                  key={action.linkPath}
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
            <Box className={classes.floatSpacer} />
          </Permission>
          <Permission show={permission(props.currentGroup, 'news_manage?')}>
            <Paper>
              <ResponsiveTabs
                value={props.currentTab}
                onChange={props.handleChangeTab}
                indicatorColor='primary'
                textColor='primary'
              >
                <Tab label={<DiverstFormattedMessage {...messages.approved} />} />
                <Tab label={<DiverstFormattedMessage {...messages.pending} />} />
              </ResponsiveTabs>
            </Paper>
          </Permission>
        </React.Fragment>
      )}
      <br />
      <DiverstLoader isLoading={props.isLoading}>
        <Grid container>
          { /* eslint-disable-next-line arrow-body-style */ }
          {props.newsItems && Object.values(props.newsItems).map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.newsItem}>
                <Card>
                  {renderNewsItem(item, props)}
                </Card>
                <Box mb={3} />
              </Grid>
            );
          })}
        </Grid>
      </DiverstLoader>
      {!props.isLoading && props.newsItems && Object.values(props.newsItems).length <= 0 && (
        <React.Fragment>
          <Grid item sm>
            <Box mt={3} />
            <Typography variant='h6' align='center' color='textSecondary'>
              <DiverstFormattedMessage {...messages.no_news[props.pending ? 'pending' : 'approved']} />
            </Typography>
          </Grid>
        </React.Fragment>
      )}
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
  pending: PropTypes.bool,
  deleteGroupMessageBegin: PropTypes.func,
  deleteNewsLinkBegin: PropTypes.func,
  deleteSocialLinkBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
  archiveNewsItemBegin: PropTypes.func,
  pinNewsItemBegin: PropTypes.func,
  unpinNewsItemBegin: PropTypes.func,
  likeNewsItemBegin: PropTypes.func,
  unlikeNewsItemBegin: PropTypes.func,
  currentGroup: PropTypes.object,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(NewsFeed);
