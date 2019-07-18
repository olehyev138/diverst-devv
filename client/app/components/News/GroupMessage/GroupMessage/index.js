import React, {
  memo, useRef, useState, useEffect, useContext
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux/';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';

import dig from 'object-dig';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { pathId, fillPath, routeContext } from 'utils/routeHelpers';

import { ROUTES } from 'containers/Shared/Routes/constants';
import { FormattedMessage } from 'react-intl';
import messages from 'containers/News/messages';

import GroupMessageComment from 'components/News/GroupMessage/GroupMessageComment';
import GroupMessageCommentForm from 'components/News/GroupMessage/GroupMessageCommentForm';

const styles = theme => ({
  comment: {
    width: '100%',
  },
});

export function GroupMessage(props) {
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
