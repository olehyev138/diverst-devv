import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import dig from 'object-dig';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/User/reducer';
import saga from 'containers/User/saga';

import { selectPaginatedPosts, selectPostsTotal, selectIsLoadingPosts } from 'containers/User/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { getUserPostsBegin, userUnmount } from 'containers/User/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import NewsFeed from 'components/News/NewsFeed';

export function NewsFeedPage(props, context) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });

  const [params, setParams] = useState({
    count: 5, page: 0, order: 'desc', order_by: 'created_at',
  });

  const rs = new RouteService(useContext);
  const links = {
    groupMessageShow: (groupId, id) => ROUTES.group.news.messages.show.path(groupId, id),
    newsLinkEdit: id => ROUTES.group.news.news_links.edit.path(rs.params('group_id'), id),
    socialLinkEdit: id => ROUTES.group.news.social_links.edit.path(rs.params('group_id'), id),
    newsLinkShow: (groupId, id) => ROUTES.group.news.news_links.show.path(rs.params('group_id'), id),
  };

  useEffect(() => {
    const userId = dig(props, 'currentUser', 'id');
    props.getUserPostsBegin(params);

    return () => {
      props.userUnmount();
    };
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getUserPostsBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <NewsFeed
        newsItems={props.newsItems}
        newsItemsTotal={props.newsItemsTotal}
        defaultParams={params}
        handlePagination={handlePagination}
        links={links}
        isLoading={props.isLoading}
        readonly
      />
    </React.Fragment>
  );
}

NewsFeedPage.propTypes = {
  currentUser: PropTypes.object,
  getUserPostsBegin: PropTypes.func.isRequired,
  userUnmount: PropTypes.func.isRequired,
  newsItems: PropTypes.array,
  newsItemsTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  currentGroup: PropTypes.shape({
    news_feed: PropTypes.shape({
      id: PropTypes.number
    })
  }),
};

const mapStateToProps = createStructuredSelector({
  newsItems: selectPaginatedPosts(),
  newsItemsTotal: selectPostsTotal(),
  currentUser: selectUser(),
  isLoading: selectIsLoadingPosts(),
});

const mapDispatchToProps = {
  getUserPostsBegin,
  userUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(NewsFeedPage);
