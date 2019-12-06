/**
 *
 * Group Message Comment Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import {Button, Card, CardActions, CardContent, Typography} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import WrappedNavLink from "../../../Shared/WrappedNavLink";
import DiverstFormattedMessage from "../../../Shared/DiverstFormattedMessage";
import messages from "../../../../containers/News/messages";

const styles = theme => ({
  margin: {
    marginTop: 16,
    marginBottom: 16,
  }
});

export function GroupMessageComment(props) {
  /* Render a single group message comment */

  const { classes, comment, newsItem, groupMessage} = props;
  console.log(newsItem.group_message.group_id);
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
            if (confirm('Delete group message?'))
              props.deleteGroupMessageCommentBegin( {group_id: newsItem.group_message.group_id , id: comment.id} );
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
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessageComment);
