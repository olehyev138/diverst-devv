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
  TextField, Hidden, FormControl, Link, Typography, Box,
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';

const styles = theme => ({
});

export function SocialLinkListItem(props) {
  const { socialLink } = props;

  return (
    <Card>
      <CardContent>
        {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
        <Link href={socialLink.url} target='_blank'>
          <Typography variant='h6'>
            {socialLink.url}
          </Typography>
        </Link>
        {socialLink.author ? (
          <React.Fragment>
            <Box mb={2} />
            <Typography variant='body2' color='textSecondary'>
              {`Submitted by ${socialLink.author.first_name} ${socialLink.owner.last_name}`}
            </Typography>
          </React.Fragment>
        ) : <React.Fragment />
        }
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
