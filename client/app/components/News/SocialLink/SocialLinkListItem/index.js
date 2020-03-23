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
import { injectIntl, intlShape } from 'react-intl';
import IconButton from '@material-ui/core/IconButton';
import LocationOnIcon from '@material-ui/icons/LocationOn';
import LocationOnOutlinedIcon from '@material-ui/icons/LocationOnOutlined';
import Permission from '../../../Shared/DiverstPermission';
import { permission } from '../../../../utils/permissionsHelpers';
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
  const { links, intl } = props;
  const newsItemId = newsItem.id;
  const groupId = socialLink.group_id;

  const { is_pinned: defaultPinned } = newsItem;
  const [pinned, setPinned] = useState(defaultPinned);

  function pin() {
    setPinned(true);
  }

  function unpin() {
    setPinned(false);
  }

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
            <Grid container>
              <Grid item>
                <Permission show={props.pinNewsItemBegin && permission(props.currentGroup, 'events_manage?')}>
                  <IconButton
                    size='small'
                    onClick={() => {
                      if (pinned)
                        props.unpinNewsItemBegin({ id: newsItemId });
                      else
                        props.pinNewsItemBegin({ id: newsItemId });
                    }}
                  >
                    { pinned ? <LocationOnIcon /> : <LocationOnOutlinedIcon />}
                  </IconButton>
                </Permission>
              </Grid>
              <Grid item>
                <Typography variant='body2' color='textSecondary' className={classes.centerVertically} align='right'>
                  {formatDateTimeString(socialLink.created_at)}
                </Typography>
              </Grid>
            </Grid>
          </Grid>
        </Grid>
      </CardContent>
      <Permission show={props.links && permission(newsItem, 'update?')}>
        <CardActions>
          {!props.readonly && (
            <React.Fragment>
              <Button
                size='small'
                color='primary'
                to={links.socialLinkEdit(newsItem.id)}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.edit} />
              </Button>
              <Permission show={props.links && permission(props.currentGroup, 'events_manage?')}>
                <Button
                  size='small'
                  color='primary'
                  onClick={() => {
                    props.archiveNewsItemBegin({ id: newsItemId });
                  }}
                >
                  <DiverstFormattedMessage {...messages.archive} />
                </Button>
              </Permission>
              <Permission show={permission(newsItem, 'destroy?')}>
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
              </Permission>
            </React.Fragment>
          )}
          <Permission show={!props.readonly && !props.newsItem.approved && permission(props.currentGroup, 'events_manage?')}>
            <Button
              size='small'
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                props.updateNewsItemBegin({ approved: true, id: newsItemId, group_id: groupId });
              }}
            >
              {<DiverstFormattedMessage {...messages.approve} />}
            </Button>
          </Permission>
        </CardActions>
      </Permission>
    </Card>
  );
}

SocialLinkListItem.propTypes = {
  classes: PropTypes.object,
  intl: intlShape,
  socialLink: PropTypes.object,
  currentGroup: PropTypes.object,
  links: PropTypes.shape({
    socialLinkEdit: PropTypes.func,
  }),
  newsItem: PropTypes.object,
  readonly: PropTypes.bool,
  deleteSocialLinkBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
  archiveNewsItemBegin: PropTypes.func,
  pinNewsItemBegin: PropTypes.func,
  unpinNewsItemBegin: PropTypes.func,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(SocialLinkListItem);
