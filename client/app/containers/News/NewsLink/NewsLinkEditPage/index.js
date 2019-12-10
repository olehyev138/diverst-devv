import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/News/reducer';
import saga from 'containers/News/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectNewsItem, selectIsCommitting, selectIsFormLoading } from 'containers/News/selectors';

import {
  getNewsItemBegin, updateNewsLinkBegin,
  newsFeedUnmount
} from 'containers/News/actions';

import NewsLinkForm from 'components/News/NewsLink/NewsLinkForm';

export function NewsLinkEditPage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  const rs = new RouteService(useContext);
  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(rs.params('group_id')),
  };

  useEffect(() => {
    const newsItemId = rs.params('item_id');
    props.getNewsItemBegin({ id: newsItemId });

    return () => props.newsFeedUnmount();
  }, []);

  const { currentUser, currentGroup, currentNewsItem } = props;
  return (
    <NewsLinkForm
      edit
      newsLinkAction={props.updateNewsLinkBegin}
      buttonText='Update'
      currentUser={currentUser}
      currentGroup={currentGroup}
      newsItem={currentNewsItem}
      links={links}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
    />
  );
}

NewsLinkEditPage.propTypes = {
  getNewsItemBegin: PropTypes.func,
  updateNewsLinkBegin: PropTypes.func,
  newsFeedUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentNewsItem: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentNewsItem: selectNewsItem(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  getNewsItemBegin,
  updateNewsLinkBegin,
  newsFeedUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(NewsLinkEditPage);
