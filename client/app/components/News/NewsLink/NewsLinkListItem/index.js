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
  TextField, Hidden, FormControl, Typography, Link, Box,
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';

const styles = theme => ({
});

export function NewsLinkListItem(props) {
  const { newsLink } = props;
  const { newsItem } = props;
  const { links } = props;

  return (
    <Card>
      <CardContent>
        {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
        <Link href={newsLink.url} target='_blank'>
          <Typography>
            {newsLink.title}
          </Typography>
        </Link>
        <Box mb={2} />
        <Typography variant='body2' color='textSecondary'>
          {newsLink.description}
        </Typography>
        {newsLink.author ? (
          <React.Fragment>
            <Box mb={2} />
            <Typography variant='body2' color='textSecondary'>
              {`Submitted by ${newsLink.author.first_name} ${newsLink.owner.last_name}`}
            </Typography>
          </React.Fragment>
        ) : <React.Fragment />
        }
        <CardActions>
          <Button
            size='small'
            color='primary'
            to={links.newsLinkEdit(newsLink.id)}
            component={WrappedNavLink}
          >
            <DiverstFormattedMessage {...messages.edit} />
          </Button>
        </CardActions>
      </CardContent>
    </Card>
  );
}

NewsLinkListItem.propTypes = {
  newsLink: PropTypes.object,
  readonly: PropTypes.bool,
  newsItem: PropTypes.object,
  links: PropTypes.shape({
    newsLinkEdit: PropTypes.func,
  })
};

export default compose(
  memo,
  withStyles(styles)
)(NewsLinkListItem);
