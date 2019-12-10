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

const styles = theme => ({
});

export function GroupMessageListItem(props) {
  const { newsItem } = props;
  const groupMessage = newsItem.group_message;
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
      { props.links && !props.readonly && (
        <CardActions>
          <Button
            size='small'
            color='primary'
            to={props.links.groupMessageEdit(newsItem.id)}
            component={WrappedNavLink}
          >
            <DiverstFormattedMessage {...messages.edit} />
          </Button>
          <Button
            size='small'
            to={props.links.groupMessageShow(props.groupId, newsItem.id)}
            component={WrappedNavLink}
          >
            Comments
          </Button>
          <Button
            size='small'
            onClick={() => {
              /* eslint-disable-next-line no-alert, no-restricted-globals */
              if (confirm('Delete group message?'))
                props.deleteGroupMessageBegin(newsItem.group_message);
            }}
            // component={WrappedNavLink}
          >
            Delete
          </Button>
        </CardActions>
      )}
    </Card>
  );
}

GroupMessageListItem.propTypes = {
  newsItem: PropTypes.object,
  readonly: PropTypes.bool,
  groupId: PropTypes.number,
  links: PropTypes.shape({
    groupMessageEdit: PropTypes.func,
    groupMessageShow: PropTypes.func
  }),
  deleteGroupMessageBegin: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessageListItem);
