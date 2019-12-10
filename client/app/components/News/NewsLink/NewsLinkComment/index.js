import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import { Button, Card, CardContent, Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  margin: {
    marginTop: 16,
    marginBottom: 16,
  }
});

export function NewsLinkComment(props) {
  /* Render a single group message comment */

  const { classes, comment, newsItem } = props;
  return (
    <Card className={classes.margin}>
      <CardContent>
        <Typography variant='body1'>{comment.content}</Typography>
        <Typography variant='body2'>{comment.author.name}</Typography>
      </CardContent>
      <Button
        size='small'
        onClick={() => {
          /* eslint-disable-next-line no-alert, no-restricted-globals */
          if (confirm('Delete news link?'))
            props.deleteNewsLinkCommentBegin({
              group_id: newsItem.news_link.group_id,
              id: comment.id });
        }}
      >
        Delete
      </Button>
    </Card>
  );
}

NewsLinkComment.propTypes = {
  classes: PropTypes.object,
  comment: PropTypes.object,
  deleteNewsLinkCommentBegin: PropTypes.func,
  newsItem: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(NewsLinkComment);
