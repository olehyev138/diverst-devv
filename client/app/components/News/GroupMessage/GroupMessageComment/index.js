/**
 *
 * Group Message Comment Component
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

export function GroupMessageComment(props) {
  const { comment } = props;

  return (
    <Card>
      <CardContent>
        <p>{comment.content}</p>
      </CardContent>
      <CardActions>
        <Button
          size='small'
          to='/temp'
          component={WrappedNavLink}
        >
          Comment
        </Button>
      </CardActions>
    </Card>
  );
}

GroupMessageComment.propTypes = {
  comment: PropTypes.object,
  links: PropTypes.shape({
  })
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessageComment);
