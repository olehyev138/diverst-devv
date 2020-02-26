/**
 *
 * Group Message List Item Component
 *
 */
import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import {
  Button, Card, CardActions, CardContent, Typography, CardHeader, Avatar, Grid, Box
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import ThumbUpIcon from '@material-ui/icons/ThumbUp';


import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';
import CommentIcon from '@material-ui/icons/Comment';
import IconButton from '@material-ui/core/IconButton';
import { formatDateTimeString } from 'utils/dateTimeHelpers';

const styles = theme => ({
  cardContent: {
    paddingBottom: 0,
  },
  centerVertically: {
    padding: 3,
  },
  cardActions: {
    padding: 3,
  }
});

export function GroupMessageListItem(props) {
  const { classes, newsItem } = props;
  const newsItemId = newsItem.id;
  const groupMessage = newsItem.group_message;
  const groupId = groupMessage.group_id;
  return (
    <Card>
      <CardHeader
        avatar={(
          <Avatar>
            {/* Replace this with the user icon */}
            {String.fromCharCode(65 + Math.floor(Math.random() * 26))}
          </Avatar>
        )}
        title={groupMessage.subject}
        titleTypographyProps={{ variant: 'h5', display: 'inline' }}
      />
      <CardContent className={classes.cardContent}>
        <Typography gutterBottom>
          {groupMessage.content}
        </Typography>
        <Grid container>
          <Grid item xs={9}>
            <Typography variant='body2' color='textSecondary' className={classes.centerVertically}>
              {`Submitted by ${groupMessage.owner.first_name} ${groupMessage.owner.last_name}`}
            </Typography>
          </Grid>
          <Grid item xs={3}>
            <Box display="flex" justifyContent="flex-end">
              { props.links && (
                <IconButton
                  //TODO : Change to actual post like action
                  size='small'
                  to={props.links.groupMessageShow(props.groupId, newsItem.id)}
                  component={WrappedNavLink}
                >
                  <ThumbUpIcon/>
                </IconButton>
              )}
              { props.links && (
                <IconButton
                  size='small'
                  to={props.links.groupMessageShow(props.groupId, newsItem.id)}
                  component={WrappedNavLink}
                >
                  <CommentIcon />
                </IconButton>
              )}
              <Typography variant='body2' color='textSecondary' className={classes.centerVertically} >
                {formatDateTimeString(groupMessage.created_at)}
              </Typography>
            </Box>
          </Grid>
        </Grid>
      </CardContent>
      { props.links && (
        <CardActions className={classes.cardActions}>
          {!props.readonly && (
            <Button
              size='small'
              color='primary'
              to={props.links.groupMessageEdit(newsItem.id)}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.edit} />
            </Button>
          )}

          {!props.readonly && props.newsItem.approved !== true && (
            <Button
              size='small'
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                props.updateNewsItemBegin({ approved: true, id: newsItemId, group_id: groupId });
              }}
            >
              Approve
            </Button>
          )}
          {!props.readonly && (
            <Button
              size='small'
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete group message?'))
                  props.deleteGroupMessageBegin(newsItem.group_message);
              }}
            >
              Delete
            </Button>
          )}
        </CardActions>
      )}
    </Card>
  );
}

GroupMessageListItem.propTypes = {
  newsItem: PropTypes.object,
  readonly: PropTypes.bool,
  groupId: PropTypes.number,
  links: PropTypes.shape({
    groupMessageEdit: PropTypes.func,
    groupMessageShow: PropTypes.func
  }),
  deleteGroupMessageBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessageListItem);
