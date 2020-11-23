import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';

import { Box, Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import NewsComment from 'components/News/NewsComment';
import NewsLinkCommentForm from 'components/News/NewsLink/NewsLinkCommentForm';
import NewsLinkListItem from 'components/News/NewsLink/NewsLinkListItem';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';
import messages from 'containers/News/messages';
import DiverstFormattedMessage from '../../../Shared/DiverstFormattedMessage';


const styles = theme => ({});

export function NewsLink(props) {
  /* Render a NewsLink, its comments & a comment form */
  const { classes, ...rest } = props;
  const newsItem = props?.newsItem;
  const newsLink = newsItem?.news_link;
  return (
    <DiverstShowLoader isLoading={props.isFormLoading} isError={!props.isFormLoading && !newsLink}>
      {newsLink && (
        <React.Fragment>
          <NewsLinkListItem
            newsItem={newsItem}
          />
          <Box mb={4} />
          <NewsLinkCommentForm
            currentUserId={props.currentUserId}
            newsItem={props.newsItem}
            commentAction={props.commentAction}
            {...rest}
          />
          <Box mb={4} />
          <Typography variant='h6'>
            <DiverstFormattedMessage {...messages.comments} />
          </Typography>
          { /* eslint-disable-next-line arrow-body-style */}
          {newsLink?.comments && newsLink.comments.map((comment, i) => {
            return (
              <NewsComment
                key={comment.id}
                comment={comment}
                deleteCommentAction={props.deleteNewsLinkCommentBegin}
                newsItem={props.newsItem}
                customTexts={props.customTexts}
              />
            );
          })}
        </React.Fragment>
      )}
    </DiverstShowLoader>
  );
}

NewsLink.propTypes = {
  classes: PropTypes.object,
  newsItem: PropTypes.object,
  currentUserId: PropTypes.number,
  commentAction: PropTypes.func,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    newsLinkEdit: PropTypes.func
  }),
  deleteNewsLinkCommentBegin: PropTypes.func,
  customTexts: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(NewsLink);
