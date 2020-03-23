import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Archive/reducer';
import saga from 'containers/Archive/saga';
import { getArchivesBegin, restoreArchiveBegin } from 'containers/Archive/actions';
import ArchiveList from 'components/Archive/ArchiveList';
import { selectArchives, selectArchivesTotal, selectHasChanged, selectIsLoading } from '../selectors';

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in EventsList
  page: 0,
  order: 'asc',
  orderBy: 'id',
  query_scopes: ['archived']
});

const ArchiveTypes = Object.freeze({
  posts: 0,
  resources: 1,
  events: 2,
});


export function ArchivePage(props) {
  useInjectReducer({ key: 'archives', reducer });
  useInjectSaga({ key: 'archives', saga });

  const [tab, setTab] = useState(ArchiveTypes.posts);
  const [params, setParams] = useState(defaultParams);

  useEffect(() => {
    if (props.hasChanged)
      props.getArchivesBegin(params);
  }, [props.hasChanged]);

  useEffect(() => {
    getArchives('posts', true);
  }, []);

  const getArchives = (type, resetParams = false) => {
    const newParams = resetParams
      ? { ...defaultParams, resource: type }
      : { ...params, resource: type };
    props.getArchivesBegin(newParams);
    setParams(newParams);
  };


  const handleChangeTab = (event, newTab) => {
    setTab(newTab);
    switch (newTab) {
      case ArchiveTypes.posts:
        getArchives('posts', true);
        break;
      case ArchiveTypes.resources:
        getArchives('resources', true);
        break;
      case ArchiveTypes.events:
        getArchives('events', true);
        break;
      default:
        break;
    }
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getArchivesBegin(newParams);
    setParams(newParams);
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getArchivesBegin(newParams);
    setParams(newParams);
  };

  const handleRestore = (payload) => {
    const newParams = {
      ...params,
      id: payload
    };
    props.restoreArchiveBegin(newParams);
  };

  return (
    <ArchiveList
      currentTab={tab}
      handleChangeTab={handleChangeTab}
      handlePagination={handlePagination}
      handleOrdering={handleOrdering}
      archives={props.archives}
      archivesTotal={props.archivesTotal}
      handleRestore={handleRestore}
      isLoading={props.isLoading}
    />
  );
}

ArchivePage.propTypes = {
  archives: PropTypes.array,
  archivesTotal: PropTypes.number,
  hasChanged: PropTypes.bool,
  getArchivesBegin: PropTypes.func,
  restoreArchiveBegin: PropTypes.func,
  columns: PropTypes.array,
  isLoading: PropTypes.bool
};

const mapStateToProps = createStructuredSelector({
  archives: selectArchives(),
  archivesTotal: selectArchivesTotal(),
  hasChanged: selectHasChanged(),
  isLoading: selectIsLoading()
});

const mapDispatchToProps = {
  getArchivesBegin,
  restoreArchiveBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ArchivePage);
