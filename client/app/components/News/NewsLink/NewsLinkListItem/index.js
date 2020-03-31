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
    <Card>
      <CardHeader
        className={classes.cardHeader}
        title={<Link href={newsLink.url} target='_blank'>{newsLink.title}</Link>}
        titleTypographyProps={{ color: 'primary' }}
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
                <DiverstLike
                  isLiked={newsItem.current_user_likes}
                  newsFeedLinkId={newsItem.id}
                  totalLikes={newsItem.total_likes}
                  likeNewsItemBegin={props.likeNewsItemBegin}
                  unlikeNewsItemBegin={props.unlikeNewsItemBegin}
                />
                {props.pinNewsItemBegin && (
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
                )}
                { props.links && (
                  <IconButton
                    size='small'
                    to={props.links.newsLinkShow(props.groupId, newsItem.id)}
                    component={WrappedNavLink}
                  >
                    <CommentIcon />
                  </IconButton>
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
      {props.links && props.newsItem && (
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
              <Button
                size='small'
                color='primary'
                onClick={() => {
                  props.archiveNewsItemBegin({ id: newsItemId });
                }}
              >
                <DiverstFormattedMessage {...messages.archive} />
              </Button>
              <Button
                size='small'
                onClick={() => {
                  /* eslint-disable-next-line no-alert, no-restricted-globals */
                  if (confirm('Delete news link?'))
                    props.deleteNewsLinkBegin(newsItem.news_link);
                }}
              >
                Delete
              </Button>
            </React.Fragment>
          )}
          {!props.readonly && props.newsItem.approved !== true && (
            <Button
              size='small'
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                props.updateNewsItemBegin({ approved: true, id: newsItemId, group_id: groupId });
              }}
            >
              {<DiverstFormattedMessage {...messages.approve} />}
            </Button>
          )}
        </CardActions>
      )}
    </Card>
  );
}

NewsLinkListItem.propTypes = {
  classes: PropTypes.object,
  intl: intlShape,
  newsLink: PropTypes.object,
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
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(NewsLinkListItem);
