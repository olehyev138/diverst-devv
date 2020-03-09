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
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl, Typography, Link, Box,
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';
import { injectIntl, intlShape } from 'react-intl';

const styles = theme => ({
});

export function NewsLinkListItem(props) {
  const { newsItem } = props;
  const newsItemId = newsItem.id;
  const newsLink = newsItem.news_link;
  const groupId = newsLink.group_id;
  const { links, intl } = props;
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
      </CardContent>
      {props.links && props.newsItem && (
        <CardActions>
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
          <Button
            size='small'
            to={links.newsLinkShow(props.groupId, newsItem.id)}
            component={WrappedNavLink}
          >
            {<DiverstFormattedMessage {...messages.comments} />}
          </Button>
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
          {!props.readonly && (
            <Button
              size='small'
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm(intl.formatMessage(messages.news_delete_confirm)))
                  props.deleteNewsLinkBegin(newsItem.news_link);
              }}
            >
              {<DiverstFormattedMessage {...messages.delete} />}
            </Button>
          )}
        </CardActions>
      )}
    </Card>
  );
}

NewsLinkListItem.propTypes = {
  intl: intlShape,
  newsLink: PropTypes.object,
  readonly: PropTypes.bool,
  groupId: PropTypes.number,
  newsItem: PropTypes.object,
  links: PropTypes.object,
  deleteNewsLinkBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
  archiveNewsItemBegin: PropTypes.func,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(NewsLinkListItem);
