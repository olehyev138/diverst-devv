import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import { Card, CardContent, Grid } from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import GroupMessageComment from 'components/News/GroupMessage/GroupMessageComment';
import GroupMessageCommentForm from 'components/News/GroupMessage/GroupMessageCommentForm';

const styles = theme => ({
  comment: {
    width: '100%',
  },
});

export function GroupMessage(props) {
  /* Render a GroupMessage, its comments & a comment form */

  const { classes } = props;
  const newsItem = dig(props, 'newsItem');
  const groupMessage = dig(newsItem, 'group_message');

  return (
    (groupMessage) ? (
      <React.Fragment>
        <Grid container spacing={3}>
          <Grid item className={classes.comment}>
            <Card>
              <CardContent>
                <p>{groupMessage.content}</p>
              </CardContent>
            </Card>
          </Grid>
          <Grid item className={classes.comment}>
            <GroupMessageCommentForm
              currentUserId={props.currentUserId}
              newsItem={props.newsItem}
              commentAction={props.commentAction}
            />
          </Grid>
          <Grid item className={classes.comment}>
            <Card>
              { /* eslint-disable-next-line arrow-body-style */ }
              {dig(groupMessage, 'comments') && groupMessage.comments.map((comment, i) => {
                return (
                  <Grid item key={comment.id} className={classes.comment}>
                    <GroupMessageComment comment={comment} />
                  </Grid>
                );
              })}
            </Card>
          </Grid>
        </Grid>
      </React.Fragment>
    ) : <React.Fragment />
  );
}

GroupMessage.propTypes = {
  classes: PropTypes.object,
  newsItem: PropTypes.object,
  currentUserId: PropTypes.number,
  commentAction: PropTypes.func,
  links: PropTypes.shape({
    groupMessageEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessage);
