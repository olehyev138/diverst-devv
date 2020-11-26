/**
 *
 * News Link List Item Component
 *updateSocialLinkBegin: PropTypes.func,
 */
import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux/';

import {
  Button, Card, CardActions, CardHeader, CardContent, Grid,
  TextField, Hidden, FormControl, Typography, Link, Box, CardMedia,
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';

import IconButton from '@material-ui/core/IconButton';
import ThumbUpIcon from '@material-ui/icons/ThumbUp';
import CommentIcon from '@material-ui/icons/Comment';
import ImageIcon from '@material-ui/icons/Image';
import LocationOnIcon from '@material-ui/icons/LocationOn';
import LocationOnOutlinedIcon from '@material-ui/icons/LocationOnOutlined';

import { formatDateTimeString } from 'utils/dateTimeHelpers';
import DiverstImg from 'components/Shared/DiverstImg';
import Carousel from 'react-material-ui-carousel';
import DiverstLike from '../../../Shared/DiverstLike';

import { injectIntl, intlShape } from 'react-intl';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  cardHeader: {
    paddingBottom: 0,
  },
  centerVertically: {
    padding: 3,
  },
  // Theme for the description box
  descriptionBox: {
    paddingLeft: 6,
  },
  cardActions: {
    padding: 3,
  },
  cardContent: {
    paddingBottom: 0,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function NewsLinkListItem(props) {
  const { classes, newsItem } = props;
  const newsItemId = newsItem.id;
  const newsLink = newsItem.news_link;
  const groupId = newsLink.group_id;
  const { links, intl } = props;
  // TODO : Change the newslink.description condition to render on image presence

  const { is_pinned: defaultPinned } = newsItem;
  const [pinned, setPinned] = useState(defaultPinned);

  function pin() {
    setPinned(true);
  }

  function unpin() {
    setPinned(false);
  }

  return (
    <React.Fragment>
      <CardHeader
        className={classes.cardHeader}
        title={<Link href={newsLink.url} target='_blank'>{newsLink.title}</Link>}
        titleTypographyProps={{ variant: 'body1', color: 'primary' }}
      >
      </CardHeader>
      <CardContent className={classes.cardContent}>
        { !newsLink.description ? (
          <Grid container>
            <Grid item xs={12} md={4}>
              <Carousel
                className={classes.centerVertically}
                autoPlay={false}
              >
              </Carousel>
            </Grid>
            <Grid item xs={12} md={8}>
              <Typography gutterBottom className={classes.descriptionBox}>
                {newsLink.description}
              </Typography>
            </Grid>
          </Grid>
        )
          : (
            <Typography gutterBottom className={classes.descriptionBox}>
              {newsLink.description}
            </Typography>
          )
        }

        <Grid container justify='space-between'>
          <Grid item>
            {newsLink.author ? (
              <Typography variant='body2' color='textSecondary' className={classes.centerVertically}>
                {`Submitted by ${newsLink.author.first_name} ${newsLink.author.last_name}`}
              </Typography>
            ) : null }
          </Grid>
          <Grid item>
            <Grid container>
              <Grid item>
                {props.enableLikes && (
                  <DiverstLike
                    isLiked={newsItem.current_user_likes}
                    newsFeedLinkId={newsItem.id}
                    totalLikes={newsItem.total_likes}
                    likeNewsItemBegin={props.likeNewsItemBegin}
                    unlikeNewsItemBegin={props.unlikeNewsItemBegin}
                  />
                )}
                { props.pinNewsItemBegin && (
                  <Permission show={permission(props.currentGroup, 'news_manage?')}>
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
                )}
                { props.pinNewsItemBegin && (
                  <Permission show={permission(newsItem, 'show?')}>
                    <IconButton
                      size='small'
                      to={props.links.newsLinkShow(props.groupId, newsItem.id)}
                      component={WrappedNavLink}
                    >
                      <CommentIcon />
                    </IconButton>
                  </Permission>
                )}
              </Grid>
              <Grid item>
                <Typography variant='body2' color='textSecondary' className={classes.centerVertically} align='right'>
                  {formatDateTimeString(newsLink.created_at)}
                </Typography>
              </Grid>
            </Grid>
          </Grid>
        </Grid>
      </CardContent>
      { props.links && props.newsItem && (
        <Permission show={permission(newsItem, 'update?')}>
          <CardActions className={classes.cardActions}>
            {!props.readonly && (
              <React.Fragment>
                <Button
                  size='small'
                  color='primary'
                  to={props.links.newsLinkEdit(newsItem.id)}
                  component={WrappedNavLink}
                >
                  <DiverstFormattedMessage {...messages.edit} />
                </Button>
                <Permission show={permission(props.currentGroup, 'news_manage?')}>
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
                    className={classes.errorButton}
                    onClick={() => {
                      /* eslint-disable-next-line no-alert, no-restricted-globals */
                      if (confirm(intl.formatMessage(messages.deleteNewsLink, props.customTexts)))
                        props.deleteNewsLinkBegin(newsItem.news_link);
                    }}
                  >
                    <DiverstFormattedMessage {...messages.delete} />
                  </Button>
                </Permission>
              </React.Fragment>
            )}
            <Permission show={!props.readonly && !props.newsItem.approved && permission(props.currentGroup, 'news_manage?')}>
              <Button
                size='small'
                onClick={() => {
                  /* eslint-disable-next-line no-alert, no-restricted-globals */
                  props.approveNewsItemBegin({ id: newsItemId });
                }}
              >
                {<DiverstFormattedMessage {...messages.approve} />}
              </Button>
            </Permission>
          </CardActions>
        </Permission>
      )}
    </React.Fragment>
  );
}

NewsLinkListItem.propTypes = {
  classes: PropTypes.object,
  intl: intlShape.isRequired,
  newsLink: PropTypes.object,
  currentGroup: PropTypes.object,
  readonly: PropTypes.bool,
  groupId: PropTypes.number,
  newsItem: PropTypes.object,
  links: PropTypes.object,
  deleteNewsLinkBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
  archiveNewsItemBegin: PropTypes.func,
  unpinNewsItemBegin: PropTypes.func,
  pinNewsItemBegin: PropTypes.func,
  likeNewsItemBegin: PropTypes.func,
  unlikeNewsItemBegin: PropTypes.func,
  approveNewsItemBegin: PropTypes.func,
  enableLikes: PropTypes.bool,
  customTexts: PropTypes.object,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(NewsLinkListItem);
