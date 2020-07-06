/**
 * Shared component to display comments for news items
 */

import React, { memo, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import { Avatar, Button, Card, CardActions, CardContent, CardHeader, Typography, Grid } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import { injectIntl, intlShape } from 'react-intl';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import DiverstImg from 'components/Shared/DiverstImg';

import { formatDateTimeString } from 'utils/dateTimeHelpers';

const styles = theme => ({
  cardHeader: {
    paddingBottom: 0,
  },
  margin: {
    marginTop: 16,
    marginBottom: 16,
  },
  centerVertically: {
    padding: 3,
  },
});

export function NewsComment(props) {
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
        <Grid container justify='space-between'>
          <Grid item>
          </Grid>
          <Grid item>
            <Typography variant='body2' color='textSecondary' className={classes.centerVertically}>{formatDateTimeString(comment.created_at)}</Typography>
          </Grid>
        </Grid>
      </CardContent>
      <Permission show={permission(comment, 'destroy?')}>
        <CardActions>
          <Button
            size='small'
            onClick={() => {
              /* eslint-disable-next-line no-alert, no-restricted-globals */
              if (confirm(intl.formatMessage(messages.group_delete_confirm)))
                props.deleteCommentAction({ group_id: newsItem.group_message.group_id, id: comment.id });
            }}
          >
            {<DiverstFormattedMessage {...messages.delete} />}
          </Button>
        </CardActions>
      </Permission>
    </Card>
  );
}

NewsComment.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  comment: PropTypes.object,
  deleteCommentAction: PropTypes.func,
  newsItem: PropTypes.object,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(NewsComment);
