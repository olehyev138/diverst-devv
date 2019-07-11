import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

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

  const [params, setParams] = useState({ count: 15, page: 0, order: 'asc' });

  useEffect(() => {
    props.getNewsItemsBegin(params);

    return () => {
      props.newsFeedUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <NewsFeed />
    </React.Fragment>
  );
}

NewsFeedPage.propTypes = {
  getNewsItemsBegin: PropTypes.func.isRequired,
  newsFeedUnmount: PropTypes.func.isRequired
};

const mapStateToProps = createStructuredSelector({
  newsItems: selectPaginatedNewsItems()
});

const mapDispatchToProps =  {
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
