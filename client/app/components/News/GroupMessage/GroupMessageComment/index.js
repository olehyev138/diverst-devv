/**
 *
 * Group Message Comment Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import { Card, CardContent } from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
});

export function GroupMessageComment(props) {
  /* Render a single group message comment */

  const { comment } = props;

  return (
    <Card>
      <CardContent>
        <p>{comment.content}</p>
      </CardContent>
    </Card>
  );
}

GroupMessageComment.propTypes = {
  comment: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessageComment);
