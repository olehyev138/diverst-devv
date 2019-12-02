/**
 *
 * Group Message Comment Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import { Card, CardContent, Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  margin: {
    marginTop: 16,
    marginBottom: 16,
  }
});

export function GroupMessageComment(props) {
  const { classes, comment } = props;

  return (
    <Card className={classes.margin}>
      <CardContent>
        <Typography variant='body1'>{comment.content}</Typography>
        <Typography variant='body2'>{comment.author.first_name}</Typography>
      </CardContent>
    </Card>
  );
}

GroupMessageComment.propTypes = {
  classes: PropTypes.object,
  comment: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessageComment);
