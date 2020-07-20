/**
 *
 * Event Comment Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import { Avatar, Button, Card, CardActions, CardContent, CardHeader, Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Event/messages';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
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

export function EventComment(props) {
  const { classes, comment, intl } = props;

  return (
    <Card className={classes.margin}>
      <CardHeader
        className={classes.cardHeader}
        avatar={(
          <Avatar>
            { comment.user.avatar ? (
              <DiverstImg
                data={comment.user.avatar_data}
                contentType={comment.user.avatar_content_type}
              />
            ) : (
              comment.user.first_name[0]
            )}
          </Avatar>
        )}
        title={`${(comment.user_id === props.currentUserId) ? intl.formatMessage(messages.comment.you) : `${comment.user_name}`}`.concat(' ').concat(`${
          intl.formatMessage(messages.comment.said)}`)}
        titleTypographyProps={{ variant: 'overline', display: 'inline' }}
      />
      <CardContent>
        <Typography
          variant='body1'
          color='textSecondary'
          gutterBottom
          style={{
            whiteSpace: 'pre-line'
          }}
        >
          {comment.content}
        </Typography>
        <Typography variant='body1'>
          {comment.time_since_creation}
          &ensp;
          {intl.formatMessage(messages.comment.ago)}
        </Typography>
      </CardContent>
      <Permission show={permission(comment, 'destroy?')}>
        <CardActions>
          <Button
            size='small'
            onClick={() => {
              /* eslint-disable-next-line no-alert, no-restricted-globals */
              if (confirm(intl.formatMessage(messages.comment.deleteconfirm)))
                props.deleteEventCommentBegin({ initiative_id: comment.initiative_id, id: comment.id });
            }}
          >
            {intl.formatMessage(messages.comment.delete)}
          </Button>
        </CardActions>
      </Permission>

    </Card>
  );
}

EventComment.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  comment: PropTypes.object,
  deleteEventCommentBegin: PropTypes.func,
  currentUserId: PropTypes.number,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(EventComment);
