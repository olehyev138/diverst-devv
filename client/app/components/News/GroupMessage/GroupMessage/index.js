import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import { Box, Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import GroupMessageComment from 'components/News/GroupMessage/GroupMessageComment';
import GroupMessageCommentForm from 'components/News/GroupMessage/GroupMessageCommentForm';
import GroupMessageListItem from 'components/News/GroupMessage/GroupMessageListItem';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';

const styles = theme => ({});

export function GroupMessage(props) {
  const { classes, ...rest } = props;
  const newsItem = dig(props, 'newsItem');
  const groupMessage = dig(newsItem, 'group_message');

  return (
    <DiverstShowLoader isLoading={props.isFormLoading} isError={!props.isFormLoading && !groupMessage}>
      {groupMessage && (
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
          { /* eslint-disable-next-line arrow-body-style */}
          {dig(groupMessage, 'comments') && groupMessage.comments.map((comment, i) => {
            return (
              <GroupMessageComment
                key={comment.id}
                comment={comment}
                deleteGroupMessageCommentBegin={props.deleteGroupMessageCommentBegin}
                newsItem={props.newsItem}
                groupMessage={props.groupMessage}
              />
            );
          })}
        </React.Fragment>
      )}
    </DiverstShowLoader>
  );
}

GroupMessage.propTypes = {
  classes: PropTypes.object,
  newsItem: PropTypes.object,
  currentUserId: PropTypes.number,
  commentAction: PropTypes.func,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    groupMessageEdit: PropTypes.func
  }),
  deleteGroupMessageCommentBegin: PropTypes.func,
  groupMessage: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessage);
