/**
 *
 * Group Message List Item Component
 *
 */
import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import {
  Button, Card, CardActions, CardContent, Typography, CardHeader, Avatar, Box
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import DiverstLike from '../../../Shared/DiverstLike';

import { injectIntl, intlShape } from 'react-intl';
const styles = theme => ({
});

export function GroupMessageListItem(props) {
  const { newsItem, intl } = props;
  const newsItemId = newsItem.id;
  const groupMessage = newsItem.group_message;
  const groupId = groupMessage.group_id;

  return (
    <Card>
      <CardHeader
        avatar={(
          <Avatar>
            {/* Replace this with the user icon */}
            {String.fromCharCode(65 + Math.floor(Math.random() * 26))}
          </Avatar>
        )}
        title={groupMessage.subject}
        subheader={formatDateTimeString(groupMessage.created_at)}
      />
      <CardContent>
        <Typography gutterBottom>
          {groupMessage.content}
        </Typography>
        <Typography variant='body2' color='textSecondary'>
          {`Submitted by ${groupMessage.owner.first_name} ${groupMessage.owner.last_name}`}
        </Typography>
      </CardContent>
      { props.links && (
        <CardActions>
          {!props.readonly && (
            <Button
              size='small'
              color='primary'
              to={props.links.groupMessageEdit(newsItem.id)}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.edit} />
            </Button>
          )}
          <Button
            size='small'
            to={props.links.groupMessageShow(props.groupId, newsItem.id)}
            component={WrappedNavLink}
          >
            <DiverstFormattedMessage {...messages.comments} />
          </Button>
          {!props.readonly && props.newsItem.approved !== true && (
            <Button
              size='small'
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                props.updateNewsItemBegin({ approved: true, id: newsItemId, group_id: groupId });
              }}
            >
              <DiverstFormattedMessage {...messages.approve} />
            </Button>
          )}
          {!props.readonly && (
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
          )}
        </CardActions>
      )}
      <DiverstLike
        isLiked={newsItem.current_user_likes}
        newsFeedLinkId={newsItem.id}
        totalLikes={newsItem.total_likes}
        likeNewsItemBegin={props.likeNewsItemBegin}
        unlikeNewsItemBegin={props.unlikeNewsItemBegin}
      />
    </Card>
  );
}

GroupMessageListItem.propTypes = {
  intl: intlShape,
  newsItem: PropTypes.object,
  readonly: PropTypes.bool,
  groupId: PropTypes.number,
  links: PropTypes.shape({
    groupMessageEdit: PropTypes.func,
    groupMessageShow: PropTypes.func
  }),
  deleteGroupMessageBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
  likeNewsItemBegin: PropTypes.func,
  unlikeNewsItemBegin: PropTypes.func,

};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(GroupMessageListItem);
