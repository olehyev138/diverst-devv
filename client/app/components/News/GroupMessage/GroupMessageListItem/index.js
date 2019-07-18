/**
 *
 * Group Message List Item Component
 *
 */

import React, {
  memo, useRef, useState, useEffect, useContext
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux/';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';

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

const styles = theme => ({
});

export function GroupMessageListItem(props, context) {
  const { newsItem } = props;
  const groupMessage = newsItem.group_message;

  return (
    <Card>
      <CardContent>
        <p>{groupMessage.content}</p>
      </CardContent>
      <CardActions>
        <Button
          size='small'
          to={props.links.groupMessageEdit(newsItem.id)}
          component={WrappedNavLink}
        >
          <FormattedMessage {...messages.edit} />
        </Button>
        <Button
          size='small'
          to={props.links.groupMessageIndex(newsItem.id)}
          component={WrappedNavLink}
        >
          Comments
        </Button>
      </CardActions>
    </Card>
  );
}

GroupMessageListItem.propTypes = {
  newsItem: PropTypes.object,
  links: PropTypes.shape({
    groupMessageEdit: PropTypes.func,
    groupMessageIndex: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessageListItem);
