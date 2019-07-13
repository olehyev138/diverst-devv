import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import dig from 'object-dig';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/News/reducer';
import saga from 'containers/News/saga';

import { selectPaginatedNewsItems } from 'containers/News/selectors';
import { getNewsItemsBegin, newsFeedUnmount } from 'containers/News/actions';

import NewsFeed from 'components/News/NewsFeed';

export function NewsFeedPage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  // TODO: might be a better way to do this - renders 4 times

  const [newsFeedId, setNewsFeedId] = useState(undefined);
  const [params, setParams] = useState({
    count: 15, page: 0, order: 'asc', news_feed_id: newsFeedId
  });

  useEffect(() => {
    const id = dig(props, 'currentGroup', 'news_feed', 'id');

    if (id) {
      setNewsFeedId(id);
      props.getNewsItemsBegin({ ...params, news_feed_id: id });
    }

    return () => {
      props.newsFeedUnmount();
    };
  }, [props.currentGroup]);

  return (
    <React.Fragment>
      <NewsFeed newsItems={props.newsItems} />
    </React.Fragment>
  );
}

NewsFeedPage.propTypes = {
  getNewsItemsBegin: PropTypes.func.isRequired,
  newsFeedUnmount: PropTypes.func.isRequired,
  newsItems: PropTypes.array,
  currentGroup: PropTypes.shape({
    news_feed: PropTypes.shape({
      id: PropTypes.number
    })
  }),
};

const mapStateToProps = createStructuredSelector({
  newsItems: selectPaginatedNewsItems()
});

const mapDispatchToProps = {
  getNewsItemsBegin,
  newsFeedUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(NewsFeedPage);
