import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import { Box, Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import GroupMessageComment from 'components/News/GroupMessage/GroupMessageComment';
import GroupMessageCommentForm from 'components/News/GroupMessage/GroupMessageCommentForm';
import GroupMessageListItem from 'components/News/GroupMessage/GroupMessageListItem';

const styles = theme => ({});

export function GroupMessage(props) {
  /* Render a GroupMessage, its comments & a comment form */

  const { classes, ...rest } = props;
  const newsItem = dig(props, 'newsItem');
  const groupMessage = dig(newsItem, 'group_message');

  return (
    (groupMessage) ? (
      <React.Fragment>
        <GroupMessageListItem
          newsItem={newsItem}
        />
        <Box mb={4} />
        <GroupMessageCommentForm
          currentUserId={props.currentUserId}
          newsItem={props.newsItem}
          commentAction={props.commentAction}
          {...rest}
        />
        <Box mb={4} />
        <Typography variant='h6'>
          Comments
        </Typography>
        { /* eslint-disable-next-line arrow-body-style */ }
        {dig(groupMessage, 'comments') && groupMessage.comments.map((comment, i) => {
          return (
            <GroupMessageComment key={comment.id} comment={comment} />
          );
        })}
      </React.Fragment>
    ) : <React.Fragment />
  );
}

GroupMessage.propTypes = {
  classes: PropTypes.object,
  newsItem: PropTypes.object,
  currentUserId: PropTypes.number,
  commentAction: PropTypes.func,
  links: PropTypes.shape({
    groupMessageEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessage);
