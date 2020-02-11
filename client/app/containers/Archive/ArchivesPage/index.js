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
import dig from 'object-dig';
import { selectArchives, selectArchivesTotal, selectHasChanged } from '../selectors';
import { injectIntl, intlShape } from 'react-intl';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';
import messages from 'containers/Archive/messages';

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

const resourceColumns = [
  {
    title: intl.formatMessage(messages.title),
    field: 'title',
    query_field: 'title'
  },
  {
    title: intl.formatMessage(messages.url),
    field: 'url',
    query_field: 'url',
  },
  {
    title: intl.formatMessage(messages.creation),
    field: 'created_at',
    query_field: 'created_at',
    render: rowData => formatDateTimeString(rowData.created_at, DateTime.DATE_SHORT)
  },
];

const eventColumns = [
  {
    title: intl.formatMessage(messages.event),
    field: 'name',
    query_field: 'name'
  },
  {
    title: intl.formatMessage(messages.group),
    field: 'group_name',
    //TODO DISABLE THIS COLUMN ORDERING
    query_field: 'group_name'
  },
  {
    title: intl.formatMessage(messages.creation),
    field: 'created_at',
    query_field: 'created_at',
    render: rowData => formatDateTimeString(rowData.created_at, DateTime.DATE_SHORT)
  },
];


export function ArchivePage(props) {
  useInjectReducer({ key: 'archives', reducer });
  useInjectSaga({ key: 'archives', saga });

  const [tab, setTab] = useState(ArchiveTypes.posts);
  const [params, setParams] = useState(defaultParams);
  const [columns, setColumns] = useState(resourceColumns);

  useEffect(() => {
    if (props.hasChanged)
      props.getArchivesBegin(params);
  }, [props.hasChanged]);

  const getArchives = (type, resetParams = false) => {
    if (resetParams)
      setParams(defaultParams);

    const newParams = {
      ...params,
      resource: type
    };
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
        setColumns(resourceColumns);
        break;
      case ArchiveTypes.events:
        getArchives('events', true);
        setColumns(eventColumns);
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
      columns={columns}
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
};

const mapStateToProps = createStructuredSelector({
  archives: selectArchives(),
  archivesTotal: selectArchivesTotal(),
  hasChanged: selectHasChanged()
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
