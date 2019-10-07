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
import reducer from 'containers/News/reducer';
import saga from 'containers/News/saga';

import { selectPaginatedNewsItems, selectNewsItemsTotal, selectIsLoading } from 'containers/News/selectors';
import { getNewsItemsBegin, newsFeedUnmount } from 'containers/News/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import NewsFeed from 'components/News/NewsFeed';

export function NewsFeedPage(props, context) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  const [params, setParams] = useState({
    count: 5, page: 0, order: 'asc', news_feed_id: -1
  });

  const rs = new RouteService(useContext);
  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(rs.params('group_id')),
    groupMessageIndex: id => ROUTES.group.news.messages.index.path(rs.params('group_id'), id),
    groupMessageNew: ROUTES.group.news.messages.new.path(rs.params('group_id')),
    groupMessageEdit: id => ROUTES.group.news.messages.edit.path(rs.params('group_id'), id)
  };

  useEffect(() => {
    const id = dig(props, 'currentGroup', 'news_feed', 'id');

    if (id) {
      const newParams = { ...params, news_feed_id: id };
      props.getNewsItemsBegin(newParams);
      setParams(newParams);
    }

    return () => {
      props.newsFeedUnmount();
    };
  }, [props.currentGroup]);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getNewsItemsBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <NewsFeed
        newsItems={props.newsItems}
        newsItemsTotal={props.newsItemsTotal}
        isLoading={props.isLoading}
        defaultParams={params}
        handlePagination={handlePagination}
        links={links}
      />
    </React.Fragment>
  );
}

NewsFeedPage.propTypes = {
  getNewsItemsBegin: PropTypes.func.isRequired,
  newsFeedUnmount: PropTypes.func.isRequired,
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
  newsItems: selectPaginatedNewsItems(),
  newsItemsTotal: selectNewsItemsTotal(),
  isLoading: selectIsLoading(),
});

const mapDispatchToProps = {
  getNewsItemsBegin,
  newsFeedUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(NewsFeedPage);
