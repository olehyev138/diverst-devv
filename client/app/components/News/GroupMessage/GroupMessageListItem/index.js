/**
 *
 * Group Message List Item Component
 *
 */
import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import {
  Button, Card, CardActions, CardContent, Typography, CardHeader, Avatar, Grid, Box
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import ThumbUpIcon from '@material-ui/icons/ThumbUp';
import LocationOnIcon from '@material-ui/icons/LocationOn';
import LocationOnOutlinedIcon from '@material-ui/icons/LocationOnOutlined';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';
import CommentIcon from '@material-ui/icons/Comment';
import IconButton from '@material-ui/core/IconButton';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import DiverstLike from '../../../Shared/DiverstLike';

import { injectIntl, intlShape } from 'react-intl';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import DiverstImg from "components/Shared/DiverstImg";
const styles = theme => ({
  root: {
    flexGrow: 1,
  },
  cardContent: {
    paddingBottom: 0,
  },
  centerVertically: {
    padding: 3,
  },
  cardActions: {
    padding: 3,
  },
  cardHeader: {
    paddingBottom: 0,
  },
  embedTwitter: {
    width: '75%'
  }
});

export function GroupMessageListItem(props) {
  const { classes, newsItem, intl } = props;
  const newsItemId = newsItem.id;
  const groupMessage = newsItem.group_message;
  const groupId = groupMessage.group_id;

  const { is_pinned: defaultPinned } = newsItem;
  const [pinned, setPinned] = useState(defaultPinned);

  function pin() {
    setPinned(true);
  }

  function unpin() {
    setPinned(false);
  }

  return (
    <React.Fragment>
      <CardHeader
        className={classes.cardHeader}
        avatar={(
          <Avatar>
            { groupMessage.owner.avatar ? (
              <DiverstImg
                data={groupMessage.owner.avatar_data}
                maxWidth='100%'
                maxHeight='240px'
              />
            ) : (
              groupMessage.owner.first_name[0]
            )}
          </Avatar>
        )}
        title={groupMessage.subject}
        titleTypographyProps={{ variant: 'body1', display: 'inline' }}
      />
      <CardContent className={classes.cardContent}>
        <Typography gutterBottom>
          {groupMessage.content}
        </Typography>
        <Grid container justify='space-between'>
          <Grid item>
            <Typography variant='body2' color='textSecondary' className={classes.centerVertically}>
              {`Submitted by ${groupMessage.owner.first_name} ${groupMessage.owner.last_name}`}
            </Typography>
          </Grid>
          <Grid item>
            <Grid container>
              <Grid item>
                <DiverstLike
                  isLiked={newsItem.current_user_likes}
                  newsFeedLinkId={newsItem.id}
                  totalLikes={newsItem.total_likes}
                  likeNewsItemBegin={props.likeNewsItemBegin}
                  unlikeNewsItemBegin={props.unlikeNewsItemBegin}
                />
                {props.pinNewsItemBegin && (
                  <Permission show={permission(props.currentGroup, 'news_manage?')}>
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
                { props.links && (
                  <Permission show={permission(newsItem, 'show?')}>
                    <IconButton
                      size='small'
                      to={props.links.groupMessageShow(props.groupId, newsItem.id)}
                      component={WrappedNavLink}
                    >
                      <CommentIcon />
                    </IconButton>
                  </Permission>
                )}
              </Grid>
              <Grid item>
                <Typography variant='body2' color='textSecondary' className={classes.centerVertically} align='right'>
                  {formatDateTimeString(groupMessage.created_at)}
                </Typography>
              </Grid>
            </Grid>
          </Grid>
        </Grid>
      </CardContent>
      {props.links && (
        <Permission show={permission(newsItem, 'update?')}>
          <CardActions className={classes.cardActions}>
            {!props.readonly && (
              <React.Fragment>
                <Button
                  size='small'
                  color='primary'
                  to={props.links.groupMessageEdit(newsItem.id)}
                  component={WrappedNavLink}
                >
                  <DiverstFormattedMessage {...messages.edit} />
                </Button>
                <Permission show={permission(props.currentGroup, 'events_manage?')}>
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
              </React.Fragment>
            )}
            <Permission show={!props.readonly && permission(newsItem, 'destroy?')}>
              <Button
                size='small'
                onClick={() => {
                  /* eslint-disable-next-line no-alert, no-restricted-globals */
                  if (confirm(intl.formatMessage(messages.group_delete_confirm)))
                    props.deleteGroupMessageBegin(newsItem.group_message);
                }}
              >
                <DiverstFormattedMessage {...messages.delete} />
              </Button>
            </Permission>
            <Permission show={!props.readonly && !props.newsItem.approved && permission(props.currentGroup, 'events_manage?')}>
              <Button
                size='small'
                onClick={() => {
                  /* eslint-disable-next-line no-alert, no-restricted-globals */
                  props.updateNewsItemBegin({ approved: true, id: newsItemId, group_id: groupId });
                }}
              >
                <DiverstFormattedMessage {...messages.approve} />
              </Button>
            </Permission>
          </CardActions>
        </Permission>
      )}
    </React.Fragment>
  );
}

GroupMessageListItem.propTypes = {
  classes: PropTypes.object,
  intl: intlShape,
  newsItem: PropTypes.object,
  currentGroup: PropTypes.object,
  readonly: PropTypes.bool,
  groupId: PropTypes.number,
  links: PropTypes.shape({
    groupMessageEdit: PropTypes.func,
    groupMessageShow: PropTypes.func
  }),
  deleteGroupMessageBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
  archiveNewsItemBegin: PropTypes.func,
  pinNewsItemBegin: PropTypes.func,
  unpinNewsItemBegin: PropTypes.func,
  isPinned: PropTypes.bool,
  likeNewsItemBegin: PropTypes.func,
  unlikeNewsItemBegin: PropTypes.func,
};

export default compose(
  injectIntl,
  withStyles(styles)
)(GroupMessageListItem);
