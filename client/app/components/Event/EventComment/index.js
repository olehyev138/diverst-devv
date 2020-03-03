/**
 *
 * Event Comment Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import { Button, Card, CardActions, CardContent, Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import { formatDateTimeString, DateTime } from 'utils/dateTimeHelpers';
import classNames from "classnames";

const styles = theme => ({
  margin: {
    marginTop: 16,
    marginBottom: 16,
  }
});

export function EventComment(props) {
  const { classes, comment } = props;
  const today = new Date();

  return (
    <Card className={classes.margin}>
      <CardContent>
        <Typography variant='overline'>
          {(comment.user_id === props.currentUserId) ? 'You' : comment.user_name}
          &ensp;said:
        </Typography>
        <Typography variant='body1' color='textSecondary'>{comment.content}</Typography>
        <br />
        <Typography variant='overline'>
          at&ensp;
          {formatDateTimeString(comment.created_at, DateTime.DATETIME_FULL)}
        </Typography>
      </CardContent>
      <CardActions>
        <Button
          size='small'
          onClick={() => {
            /* eslint-disable-next-line no-alert, no-restricted-globals */
            if (confirm('Delete comment?'))
              props.deleteEventCommentBegin({ initiative_id: comment.initiative_id, id: comment.id });
          }}
        >
          Delete
        </Button>
      </CardActions>
    </Card>
  );
}

EventComment.propTypes = {
  classes: PropTypes.object,
  comment: PropTypes.object,
  deleteEventCommentBegin: PropTypes.func,
  event: PropTypes.object,
  currentUserId: PropTypes.number,
};

export default compose(
  memo,
  withStyles(styles)
)(EventComment);
