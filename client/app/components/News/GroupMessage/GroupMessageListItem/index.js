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
import LocationOnIcon from '@material-ui/icons/LocationOn';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';
import CommentIcon from '@material-ui/icons/Comment';
import IconButton from '@material-ui/core/IconButton';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import { injectIntl, intlShape } from 'react-intl';
const styles = theme => ({
  root: {
    flexGrow: 1,
  },
  cardContent: {
    paddingBottom: 0,
  },
  centerVertically: {
    padding: 3,
  },
  cardActions: {
    padding: 3,
  },
  cardHeader: {
    paddingBottom: 0,
  }
});

export function GroupMessageListItem(props) {
  const { classes, newsItem, intl } = props;
  const newsItemId = newsItem.id;
  const groupMessage = newsItem.group_message;
  const groupId = groupMessage.group_id;

  return (
    <Card>
      <CardHeader
        className={classes.cardHeader}
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
        <Grid container justify='space-between'>
          <Grid item>
            <Typography variant='body2' color='textSecondary' className={classes.centerVertically}>
              {`Submitted by ${groupMessage.owner.first_name} ${groupMessage.owner.last_name}`}
            </Typography>
          </Grid>
          <Grid item>
            <Grid container>
              <Grid item>
                {props.pinNewsItemBegin && (
                  <IconButton
                    size='small'
                    component={WrappedNavLink}
                    onClick={() => {
                      props.pinNewsItemBegin({ id: newsItemId });
                    }}
                  >
                    <LocationOnIcon />
                  </IconButton>
                )}
                { props.links && (
                  <IconButton
                    // TODO : Change to actual post like action
                    size='small'
                    to={props.links.groupMessageShow(props.groupId, newsItem.id)}
                    component={WrappedNavLink}
                  >
                    <ThumbUpIcon />
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
              </Grid>
              <Grid item>
                <Typography variant='body2' color='textSecondary' className={classes.centerVertically} align='right'>
                  {formatDateTimeString(groupMessage.created_at)}
                </Typography>
              </Grid>
            </Grid>
          </Grid>
        </Grid>
      </CardContent>
      { props.links && (
        <CardActions className={classes.cardActions}>
          {!props.readonly && (
            <React.Fragment>
              <Button
                size='small'
                color='primary'
                to={props.links.groupMessageEdit(newsItem.id)}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.edit} />
              </Button>
              <Button
                size='small'
                color='primary'
                onClick={() => {
                  props.archiveNewsItemBegin({ id: newsItemId });
                }}
              >
                <DiverstFormattedMessage {...messages.archive} />
              </Button>
            </React.Fragment>
          )}

          {!props.readonly && props.newsItem.approved !== true && (
            <Button
              size='small'
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                props.updateNewsItemBegin({ approved: true, id: newsItemId, group_id: groupId });
              }}
            >
              <DiverstFormattedMessage {...messages.approve} />
            </Button>
          )}
          {!props.readonly && (
            <Button
              size='small'
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm(intl.formatMessage(messages.group_delete_confirm)))
                  props.deleteGroupMessageBegin(newsItem.group_message);
              }}
            >
              <DiverstFormattedMessage {...messages.delete} />
            </Button>
          )}
        </CardActions>
      )}
    </Card>
  );
}

GroupMessageListItem.propTypes = {
  classes: PropTypes.object,
  intl: intlShape,
  newsItem: PropTypes.object,
  readonly: PropTypes.bool,
  groupId: PropTypes.number,
  links: PropTypes.shape({
    groupMessageEdit: PropTypes.func,
    groupMessageShow: PropTypes.func
  }),
  deleteGroupMessageBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
  archiveNewsItemBegin: PropTypes.func,
  pinNewsItemBegin: PropTypes.func,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(GroupMessageListItem);
