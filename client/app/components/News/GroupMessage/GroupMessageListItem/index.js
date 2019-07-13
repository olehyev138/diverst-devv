/**
 *
 * Group Message List Item Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';
import { FormattedMessage } from 'react-intl';
import messages from 'containers/News/messages';

const styles = theme => ({
});

export function GroupMessageListItem(props) {
  const { groupMessage } = props;

  return (
    <Card>
      <CardContent>
        <p>{groupMessage.content}</p>
      </CardContent>
    </Card>
  );
}

GroupMessageListItem.propTypes = {
  groupMessage: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessageListItem);
