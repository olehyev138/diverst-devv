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
import { injectIntl, intlShape } from 'react-intl';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';

const styles = theme => ({
  margin: {
    marginTop: 16,
    marginBottom: 16,
  }
});

export function GroupMessageComment(props) {
  const { classes, comment, newsItem, intl } = props;

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
            if (confirm(intl.formatMessage(messages.group_delete_confirm)))
              props.deleteGroupMessageCommentBegin({ group_id: newsItem.group_message.group_id, id: comment.id });
          }}
        >
          {<DiverstFormattedMessage {...messages.delete} />}
        </Button>
      </CardActions>
    </Card>
  );
}

GroupMessageComment.propTypes = {
  intl: intlShape,
  classes: PropTypes.object,
  comment: PropTypes.object,
  deleteGroupMessageCommentBegin: PropTypes.func,
  newsItem: PropTypes.object,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(GroupMessageComment);
