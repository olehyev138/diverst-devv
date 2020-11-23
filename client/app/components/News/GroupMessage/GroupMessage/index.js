import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';

import { Box, Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import NewsComment from 'components/News/NewsComment';
import GroupMessageCommentForm from 'components/News/GroupMessage/GroupMessageCommentForm';
import GroupMessageListItem from 'components/News/GroupMessage/GroupMessageListItem';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';
import messages from 'containers/News/messages';
import DiverstFormattedMessage from '../../../Shared/DiverstFormattedMessage';

const styles = theme => ({});

export function GroupMessage(props) {
  const { classes, ...rest } = props;
  const newsItem = props?.newsItem;
  const groupMessage = newsItem?.group_message;

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
            <DiverstFormattedMessage {...messages.comments} />
          </Typography>
          { /* eslint-disable-next-line arrow-body-style */}
          {groupMessage?.comments && groupMessage.comments.map((comment, i) => {
            return (
              <NewsComment
                key={comment.id}
                comment={comment}
                deleteCommentAction={props.deleteGroupMessageCommentBegin}
                newsItem={props.newsItem}
                customTexts={props.customTexts}
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
  customTexts: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessage);
