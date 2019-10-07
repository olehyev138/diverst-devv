/**
 *
 * News Feed Component
 *
 */

import React, {
  memo, useRef, useState, useEffect, useContext
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';

import {
  Box,
  Button, Card, CardActions, CardContent, Grid,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import GroupMessageListItem from 'components/News/GroupMessage/GroupMessageListItem';
import NewsLinkListItem from 'components/News/NewsLink/NewsLinkListItem';
import SocialLinkListItem from 'components/News/SocialLink/SocialLinkListItem';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/News/messages';

import Pagination from 'components/Shared/Pagination';

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
  const [page, setPage] = useState(props.defaultParams.page);
  const [rowsPerPage, setRowsPerPage] = useState(props.defaultParams.count);
  const routeContext = useContext(RouteContext);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (event) => {
    const topIndex = rowsPerPage * page;
    setRowsPerPage(+event.target.value);
    const newPage = Math.floor(topIndex / +event.target.value);
    setPage(newPage);
    props.handlePagination({ count: +event.target.value, page: newPage });
  };

  /* Check news_feed_link type & render appropriate list item component */
  const renderNewsItem = (item) => {
    if (item.group_message)
      return (<GroupMessageListItem links={props.links} newsItem={item} readonly={props.readonly} groupId={item.news_feed.group_id} />);
    else if (item.news_link) // eslint-disable-line no-else-return
      return (<NewsLinkListItem newsLink={item.news_link} readonly={props.readonly} />);
    else if (item.social_link)
      return (<SocialLinkListItem socialLink={item.social_link} readonly={props.readonly} />);

    return undefined;
  };

  return (
    <React.Fragment>
      {!props.readonly && (
        <div>
          <Grid container spacing={3} justify='flex-end'>
            <Grid item>
              <Button
                variant='contained'
                to={props.links.groupMessageNew}
                color='primary'
                size='large'
                component={WrappedNavLink}
              >
                New Group Message
              </Button>
            </Grid>
            <Grid item>
              <Button
                variant='contained'
                to={ROUTES.admin.manage.groups.new.path()}
                color='primary'
                size='large'
                component={WrappedNavLink}
              >
                New News Link
              </Button>
            </Grid>
            <Grid item>
              <Button
                variant='contained'
                to={ROUTES.admin.manage.groups.new.path()}
                color='primary'
                size='large'
                component={WrappedNavLink}
              >
                New Social Link
              </Button>
            </Grid>
          </Grid>
          <Box mb={2} />
        </div>
      )}
      <Grid container>
        { /* eslint-disable-next-line arrow-body-style */ }
        {props.newsItems && Object.values(props.newsItems).map((item, i) => {
          return (
            <Grid item key={item.id} className={classes.newsItem}>
              {renderNewsItem(item)}
              <Box mb={3} />
            </Grid>
          );
        })}
      </Grid>
      <Pagination
        page={page}
        rowsPerPage={rowsPerPage}
        count={props.newsItemsTotal}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
      />
    </React.Fragment>
  );
}

NewsFeed.propTypes = {
  defaultParams: PropTypes.object,
  classes: PropTypes.object,
  newsItems: PropTypes.array,
  newsItemsTotal: PropTypes.number,
  handlePagination: PropTypes.func,
  links: PropTypes.shape({
    groupMessageNew: PropTypes.string
  }),
  readonly: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(NewsFeed);
