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
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import WrappedNavLink from '../../../Shared/WrappedNavLink';

const styles = theme => ({
  centerVertically: {
    padding: 3,
  },
  cardContent: {
    paddingBottom: 0,
  },
});

export function SocialLinkListItem(props) {
  const { socialLink, classes } = props;
  const { newsItem } = props;
  const { links } = props;
  const newsItemId = newsItem.id;
  const groupId = socialLink.group_id;
  return (
    <Card>
      <CardContent className={classes.cardContent}>
        {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
        <Link href={socialLink.url} target='_blank'>
          <Typography variant='h6'>
            {socialLink.url}
          </Typography>
        </Link>
        <Grid container justify='space-between'>
          <Grid item>
            {socialLink.author ? (
              <Typography variant='body2' color='textSecondary' className={classes.centerVertically}>
                {`Submitted by ${socialLink.author.first_name} ${socialLink.author.last_name}`}
              </Typography>
            ) : null }
          </Grid>
          <Grid item>
            <Typography variant='body2' color='textSecondary' className={classes.centerVertically} align='right'>
              {formatDateTimeString(socialLink.created_at)}
            </Typography>
          </Grid>
        </Grid>
      </CardContent>
      <CardActions>
        {!props.readonly && (
          <Button
            size='small'
            color='primary'
            to={links.socialLinkEdit(newsItem.id)}
            component={WrappedNavLink}
          >
            <DiverstFormattedMessage {...messages.edit} />
          </Button>
        )}
        {!props.readonly && props.newsItem.approved !== true && (
          <Button
            size='small'
            onClick={() => {
              /* eslint-disable-next-line no-alert, no-restricted-globals */
              props.updateNewsItemBegin({ approved: true, id: newsItemId, group_id: groupId });
            }}
          >
            Approve
          </Button>
        )}
        {!props.readonly && (
          <Button
            size='small'
            onClick={() => {
              /* eslint-disable-next-line no-alert, no-restricted-globals */
              if (confirm('Delete social link?'))
                props.deleteSocialLinkBegin(newsItem.social_link);
            }}
          >
            Delete
          </Button>
        )}
      </CardActions>
    </Card>
  );
}

SocialLinkListItem.propTypes = {
  classes: PropTypes.object,
  socialLink: PropTypes.object,
  links: PropTypes.shape({
    socialLinkEdit: PropTypes.func,
  }),
  newsItem: PropTypes.object,
  readonly: PropTypes.bool,
  deleteSocialLinkBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(SocialLinkListItem);
