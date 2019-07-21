/**
 *
 * Social Link List Item Component
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

export function SocialLinkListItem(props) {
  const { socialLink } = props;

  return (
    <Card>
      <CardContent>
        <p>{socialLink.url}</p>
      </CardContent>
    </Card>
  );
}

SocialLinkListItem.propTypes = {
  socialLink: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles)
)(SocialLinkListItem);
