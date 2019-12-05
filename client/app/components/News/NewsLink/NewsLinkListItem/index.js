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
  const { newsItem } = props;
  const newsLink = newsItem.news_link;
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
              {`Submitted by ${newsLink.author.first_name} ${newsLink.author.last_name}`}
            </Typography>
          </React.Fragment>
        ) : <React.Fragment />
        }
        {props.links && props.newsItem &&(
          <CardActions>
            <Button
              size='small'
              color='primary'
              to={props.links.newsLinkEdit(newsItem.id)}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.edit} />
            </Button>
            <Button
              size='small'
              to={links.newsLinkShow(props.groupId, newsItem.id)}
              component={WrappedNavLink}
            >
              Comments
            </Button>
          </CardActions>
        )}

      </CardContent>
    </Card>
  );
}

NewsLinkListItem.propTypes = {
  newsLink: PropTypes.object,
  readonly: PropTypes.bool,
  groupId: PropTypes.number,
  newsItem: PropTypes.object,
  links: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(NewsLinkListItem);
