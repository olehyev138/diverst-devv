/**
 *
 * Social Link List Item Component
 *
 */
import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl, Link, Typography, Box,
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import DiverstLike from 'components/Shared/DiverstLike';
import { injectIntl, intlShape } from 'react-intl';
import IconButton from '@material-ui/core/IconButton';
import LocationOnIcon from '@material-ui/icons/LocationOn';
import LocationOnOutlinedIcon from '@material-ui/icons/LocationOnOutlined';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import DiverstHTMLEmbedder from 'components/Shared/DiverstHTMLEmbedder';

const styles = theme => ({
  centerVertically: {
    padding: 3,
  },
  cardContent: {
    paddingBottom: 0,
  },
});

export function SocialLinkListItem(props) {
  const { socialLink, classes } = props;
  const { newsItem } = props;
  const { links, intl } = props;
  const newsItemId = newsItem.id;
  const groupId = socialLink.group_id;

  const { is_pinned: defaultPinned } = newsItem;
  const [pinned, setPinned] = useState(defaultPinned);

  function pin() {
    setPinned(true);
  }

  function unpin() {
    setPinned(false);
  }

  const embeddedCode = (
    <DiverstHTMLEmbedder
      html={props.small ? socialLink.small_embed_code : socialLink.embed_code}
      gridProps={{
        spacing: 0,
        direction: 'column',
        alignItems: 'center',
        justify: 'center',
      }}
      interweaveProps={{
        allowList: ['iframe', 'div', 'blockquote', 'h4', 'a', 'p']
      }}
    />
  );

  const rawLink = (
    <Link href={socialLink.url} target='_blank'>
      <Typography variant='h6'>
        {socialLink.url}
      </Typography>
    </Link>
  );

  const author = (
    socialLink.author ? (
      <Grid item>
        <Typography variant='body2' color='textSecondary' className={classes.centerVertically}>
          {`Submitted by ${socialLink.author.first_name} ${socialLink.author.last_name}`}
        </Typography>
      </Grid>
    ) : null
  );

  const pinButtons = (
    <Grid item>
      <DiverstLike
        isLiked={newsItem.current_user_likes}
        newsFeedLinkId={newsItem.id}
        totalLikes={newsItem.total_likes}
        likeNewsItemBegin={props.likeNewsItemBegin}
        unlikeNewsItemBegin={props.unlikeNewsItemBegin}
      />
      {props.pinNewsItemBegin && (
        <Permission show={permission(props.currentGroup, 'events_manage?')}>
          <IconButton
            size='small'
            onClick={() => {
              if (pinned)
                props.unpinNewsItemBegin({ id: newsItemId });
              else
                props.pinNewsItemBegin({ id: newsItemId });
            }}
          >
            { pinned ? <LocationOnIcon /> : <LocationOnOutlinedIcon />}
          </IconButton>
        </Permission>
      )}
    </Grid>
  );

  const date = (
    <Grid item>
      <Typography variant='body2' color='textSecondary' className={classes.centerVertically} align='right'>
        {formatDateTimeString(socialLink.created_at)}
      </Typography>
    </Grid>
  );

  const actions = (
    <Permission show={permission(newsItem, 'update?')}>
      <CardActions>
        {!props.readonly && (
          <React.Fragment>
            <Button
              size='small'
              color='primary'
              to={links.socialLinkEdit(newsItem.id)}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.edit} />
            </Button>
            <Permission show={permission(props.currentGroup, 'news_manage?')}>
              <Button
                size='small'
                color='primary'
                onClick={() => {
                  props.archiveNewsItemBegin({ id: newsItemId });
                }}
              >
                <DiverstFormattedMessage {...messages.archive} />
              </Button>
            </Permission>
            <Permission show={permission(newsItem, 'destroy?')}>
              <Button
                size='small'
                onClick={() => {
                  /* eslint-disable-next-line no-alert, no-restricted-globals */
                  if (confirm('Delete social link?'))
                    props.deleteSocialLinkBegin(newsItem.social_link);
                }}
              >
                Delete
              </Button>
            </Permission>
          </React.Fragment>
        )}
        {!props.readonly && props.newsItem.approved !== true && (
          <Permission show={permission(props.currentGroup, 'news_manage?')}>
            <Button
              size='small'
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                props.approveNewsItemBegin({ id: newsItemId, group_id: groupId });
              }}
            >
              {<DiverstFormattedMessage {...messages.approve} />}
            </Button>
          </Permission>
        )}
      </CardActions>
    </Permission>
  );

  return (
    <React.Fragment>
      <CardContent className={classes.cardContent}>
        { socialLink.embed_code ? embeddedCode : rawLink }
        <Grid container justify='space-between'>
          { author }
          <Grid item>
            <Grid container alignItems='center'>
              {pinButtons}
              {date}
            </Grid>
          </Grid>
        </Grid>
      </CardContent>
      { actions }
    </React.Fragment>
  );
}

SocialLinkListItem.propTypes = {
  classes: PropTypes.object,
  intl: intlShape,
  socialLink: PropTypes.object,
  currentGroup: PropTypes.object,
  links: PropTypes.shape({
    socialLinkEdit: PropTypes.func,
  }),
  newsItem: PropTypes.object,
  readonly: PropTypes.bool,
  small: PropTypes.bool,
  deleteSocialLinkBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
  archiveNewsItemBegin: PropTypes.func,
  pinNewsItemBegin: PropTypes.func,
  unpinNewsItemBegin: PropTypes.func,
  likeNewsItemBegin: PropTypes.func,
  unlikeNewsItemBegin: PropTypes.func,
  approveNewsItemBegin: PropTypes.func,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(SocialLinkListItem);
