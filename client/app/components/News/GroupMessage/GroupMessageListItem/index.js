/**
 *
 * Group Message List Item Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import {
  Button, Card, CardActions, CardContent
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/News/messages';

const styles = theme => ({
});

export function GroupMessageListItem(props) {
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
