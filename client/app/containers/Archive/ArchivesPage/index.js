import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Archive/reducer';
import saga from 'containers/Archive/saga';

import RouteService from 'utils/routeHelpers';

import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import { selectFolder, selectValid,
  selectPaginatedFolders, selectPaginatedResources,
  selectFoldersTotal, selectResourcesTotal, selectIsLoading,
  selectIsFormLoading, selectHasChanged
} from 'containers/Resource/selectors';

import {
  getFolderBegin, getFoldersBegin,
  deleteFolderBegin, foldersUnmount,
  validateFolderPasswordBegin,
  getResourcesBegin,
  deleteResourceBegin,
  archiveResourceBegin,
} from 'containers/Resource/actions';

import ArchiveList from 'components/Archive/ArchiveList';
import dig from "object-dig";

const defaultParams = Object.freeze({
  count: 5,
  page: 0,
  posts: 0,
  resources: 1,
  events: 2,
});

const ArchiveTypes = Object.freeze({
  posts: 0,
  resources: 1,
  events: 2,
});

export function ArchivePage(props) {
  //useInjectReducer({ key: 'events', reducer });
  //useInjectSaga({ key: 'events', saga });

  const [tab, setTab] = useState(defaultParams.posts);

  const getArchives = (scopes, resetParams = false) => {

    /* fetch the archives currently needed
    const id = dig(props, 'currentGroup', 'id');

    if (resetParams)
      setParams(defaultParams);

    if (id) {
      const newParams = {
        ...params,
        group_id: id,
        query_scopes: scopes
      };
      props.getEventsBegin(newParams);
      setParams(newParams);
    }
     */
  };

  const handleChangeTab = (event, newTab) => {
    setTab(newTab);
    switch (newTab) {
      case ArchiveTypes.posts:
        getArchives(['posts'], true);
        break;
      case ArchiveTypes.resources:
        getArchives(['resources'], true);
        break;
      case ArchiveTypes.events:
        getArchives(['events'], true);
        break;
      default:
        break;
    }
  };

  return (
    <ArchiveList
      currentTab={tab}
      handleChangeTab={handleChangeTab}
    />
  );
}

ArchivePage.propTypes = {

};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  currentFolder: selectFolder(),
  currentEnterprise: selectEnterprise(),
  subFolders: selectPaginatedFolders(),
  foldersTotal: selectFoldersTotal(),
  resources: selectPaginatedResources(),
  resourcesTotal: selectResourcesTotal(),
  isLoading: selectIsLoading(),
  isFormLoading: selectIsFormLoading(),
  valid: selectValid(),
  hasChanged: selectHasChanged(),
});

const mapDispatchToProps = {

};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ArchivePage);
