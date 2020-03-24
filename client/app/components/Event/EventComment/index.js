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
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Event/messages';
import Permission from "../../Shared/DiverstPermission";
import {permission} from "../../../utils/permissionsHelpers";

const styles = theme => ({
  margin: {
    marginTop: 16,
    marginBottom: 16,
  }
});

export function EventComment(props) {
  const { classes, comment, intl } = props;

  return (
    <Card className={classes.margin}>
      <CardContent>
        <Typography variant='overline'>
          {(comment.user_id === props.currentUserId) ? intl.formatMessage(messages.comment.you) : comment.user_name}
          &ensp;
          {intl.formatMessage(messages.comment.said)}
        </Typography>
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
  intl: intlShape,
  classes: PropTypes.object,
  comment: PropTypes.object,
  deleteEventCommentBegin: PropTypes.func,
  event: PropTypes.object,
  currentUserId: PropTypes.number,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(EventComment);
