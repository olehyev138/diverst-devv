/**
 *
 * Group Message Comment Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import { Button, Card, CardActions, CardContent, Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  margin: {
    marginTop: 16,
    marginBottom: 16,
  }
});

export function GroupMessageComment(props) {
  const { classes, comment, newsItem } = props;

  return (
    <Card className={classes.margin}>
      <CardContent>
        <Typography variant='body1'>{comment.content}</Typography>
        <Typography variant='body2'>{comment.author.first_name}</Typography>
      </CardContent>
      <CardActions>
        <Button
          size='small'
          onClick={() => {
            /* eslint-disable-next-line no-alert, no-restricted-globals */
            if (confirm('Delete group message?'))
              props.deleteGroupMessageCommentBegin({ group_id: newsItem.group_message.group_id, id: comment.id });
          }}
        >
          Delete
        </Button>
      </CardActions>
    </Card>
  );
}

GroupMessageComment.propTypes = {
  classes: PropTypes.object,
  comment: PropTypes.object,
  deleteGroupMessageCommentBegin: PropTypes.func,
  newsItem: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessageComment);