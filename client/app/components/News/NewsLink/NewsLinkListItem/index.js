/**
 *
 * News Link List Item Component
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

export function NewsLinkListItem(props) {
  const { newsLink } = props;

  return (
    <Card>
      <CardContent>
        <p>{newsLink.title}</p>
      </CardContent>
    </Card>
  );
}

NewsLinkListItem.propTypes = {
  newsLink: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles)
)(NewsLinkListItem);
