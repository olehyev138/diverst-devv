import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import { Avatar, Button, Card, CardContent, CardHeader, Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';
import { injectIntl, intlShape } from 'react-intl';
import DiverstImg from 'components/Shared/DiverstImg';

const styles = theme => ({
  cardHeader: {
    paddingBottom: 0,
  },
  margin: {
    marginTop: 16,
    marginBottom: 16,
  }
});

export function NewsLinkComment(props) {
  /* Render a single group message comment */

  const { classes, comment, newsItem, intl } = props;
  return (
    <Card className={classes.margin}>
      <CardHeader
        className={classes.cardHeader}
        avatar={(
          <Avatar>
            { comment.author.avatar ? (
              <DiverstImg
                data={comment.author.avatar_data}
              />
            ) : (
              comment.author.first_name[0]
            )}
          </Avatar>
        )}
        title={comment.author.name}
        titleTypographyProps={{ variant: 'overline', display: 'inline' }}
      />
      <CardContent>
        <Typography variant='body1'>{comment.content}</Typography>
      </CardContent>
      <Button
        size='small'
        onClick={() => {
          /* eslint-disable-next-line no-alert, no-restricted-globals */
          if (confirm(intl.formatMessage(messages.news_delete_confirm)))
            props.deleteNewsLinkCommentBegin({
              group_id: newsItem.news_link.group_id,
              id: comment.id });
        }}
      >
        <DiverstFormattedMessage {...messages.delete} />
      </Button>
    </Card>
  );
}

NewsLinkComment.propTypes = {
  intl: intlShape,
  classes: PropTypes.object,
  comment: PropTypes.object,
  deleteNewsLinkCommentBegin: PropTypes.func,
  newsItem: PropTypes.object,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(NewsLinkComment);
