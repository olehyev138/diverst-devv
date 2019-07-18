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

const styles = theme => ({
});

export function GroupMessage(props, context) {
  const groupMessage = dig(props, 'newsItem', 'group_message');

  return (
    (groupMessage) ? (
      <Card>
        <CardContent>
          <p>{groupMessage.content}</p>
        </CardContent>
      </Card>
    ) : <React.Fragment />
  );
}

GroupMessage.propTypes = {
  newsItem: PropTypes.object,
  links: PropTypes.shape({
    groupMessageEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessage);
