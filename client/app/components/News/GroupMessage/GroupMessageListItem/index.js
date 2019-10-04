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

import { FormattedMessage } from 'react-intl';
import messages from 'containers/News/messages';

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
      {props.links && (
        <CardActions>
          <Button
            size='small'
            color='primary'
            to={props.links.groupMessageEdit(newsItem.id)}
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.edit} />
          </Button>
          <Button
            size='small'
            to={props.links.groupMessageIndex(newsItem.id)}
            component={WrappedNavLink}
          >
            Comments
          </Button>
        </CardActions>
      )}
    </Card>
  );
}

GroupMessageListItem.propTypes = {
  newsItem: PropTypes.object,
  links: PropTypes.shape({
    groupMessageEdit: PropTypes.func,
    groupMessageIndex: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessageListItem);
