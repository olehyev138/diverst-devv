/**
 *
 * News Feed Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardActions, CardContent, Grid,
  TablePagination
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import GroupMessageListItem from 'components/News/GroupMessage/GroupMessageListItem';
import NewsLinkListItem from 'components/News/NewsLink/NewsLinkListItem';
import SocialLinkListItem from 'components/News/SocialLink/SocialLinkListItem';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/News/messages';

const styles = theme => ({
  newsItem: {
    width: '100%',
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function NewsFeed(props) {
  const { classes } = props;
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(+event.target.value);
    props.handlePagination({ count: +event.target.value, page });
  };

  /* Check news_feed_link type & render appropriate list item component */
  const renderNewsItem = (item) => {
    if (item.group_message)
      return (<GroupMessageListItem groupMessage={item.group_message} />);
    else if (item.news_link) // eslint-disable-line no-else-return
      return (<NewsLinkListItem newsLink={item.news_link} />);
    else if (item.social_link)
      return (<SocialLinkListItem socialLink={item.social_link} />);

    return undefined;
  };

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item>
          <Button
            variant='contained'
            to={ROUTES.admin.manage.groups.new.path}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            New Group Message
          </Button>
        </Grid>
        { /* eslint-disable-next-line arrow-body-style */ }
        {props.newsItems && Object.values(props.newsItems).map((item, i) => {
          return (
            <Grid item key={item.id} className={classes.newsItem}>
              { renderNewsItem(item) }
            </Grid>
          );
        })}
      </Grid>
      <TablePagination
        component='div'
        page={page}
        rowsPerPageOptions={[5, 10, 25]}
        rowsPerPage={rowsPerPage}
        count={props.newsItemsTotal || 0}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
        backIconButtonProps={{
          'aria-label': 'Previous Page',
        }}
        nextIconButtonProps={{
          'aria-label': 'Next Page',
        }}
      />
    </React.Fragment>
  );
}

NewsFeed.propTypes = {
  classes: PropTypes.object,
  newsItems: PropTypes.array,
  newsItemsTotal: PropTypes.number,
  handlePagination: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles)
)(NewsFeed);
