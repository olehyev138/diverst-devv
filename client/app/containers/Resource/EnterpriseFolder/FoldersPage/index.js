import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import dig from 'object-dig';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Resource/reducer';
import saga from 'containers/Resource/saga';

import { selectPaginatedFolders, selectFoldersTotal, selectIsLoading } from 'containers/Resource/selectors';
import { selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';
import { getFoldersBegin, foldersUnmount, deleteFolderBegin } from 'containers/Resource/actions';

import RouteService from 'utils/routeHelpers';

import FoldersList from 'components/Resource/Folder/FoldersList';
import {
  getFolderEditPath, getFolderIndexPath,
  getFolderNewPath,
  getFolderShowPath
} from 'utils/resourceHelpers';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in FoldersList
  page: 0,
  order: 'desc',
  orderBy: 'id',
});

export function FoldersPage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const rs = new RouteService(useContext);

  const links = {
    folderShow: folder => getFolderShowPath(folder),
    folderNew: getFolderNewPath('admin', rs.params('group_id')),
    folderEdit: folder => getFolderEditPath(folder),
  };

  const [params, setParams] = useState(defaultParams);

  const getFolders = (scopes, resetParams = false) => {
    const enterpriseId = dig(props, 'currentEnterprise', 'id');

    if (resetParams)
      setParams(defaultParams);

    const newParams = {
      ...params,
      parent_id: null,
    };
    props.getFoldersBegin(newParams);
    setParams(newParams);
  };

  useEffect(() => {
    getFolders();

    return () => {
      props.foldersUnmount();
    };
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getFoldersBegin(newParams);
    setParams(newParams);
  };

  return (
    <FoldersList
      folders={props.folders}
      foldersTotal={props.foldersTotal}
      deleteFolderBegin={props.deleteFolderBegin}
      handlePagination={handlePagination}
      isLoading={props.isLoading}
      links={links}
      type='admin'
      permissions={props.permissions}
      currentGroup={props.currentGroup}
    />
  );
}

FoldersPage.propTypes = {
  path: PropTypes.string,
  getFoldersBegin: PropTypes.func.isRequired,
  deleteFolderBegin: PropTypes.func,
  foldersUnmount: PropTypes.func.isRequired,
  folders: PropTypes.array,
  foldersTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  permissions: PropTypes.object,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),
  currentEnterprise: PropTypes.shape({
    id: PropTypes.number,
  }),
};

const mapStateToProps = createStructuredSelector({
  folders: selectPaginatedFolders(),
  foldersTotal: selectFoldersTotal(),
  currentEnterprise: selectEnterprise(),
  isLoading: selectIsLoading(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getFoldersBegin,
  foldersUnmount,
  deleteFolderBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  FoldersPage,
  ['permissions.enterprise_folders_view'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  'You don\'t have permission to view folders'
));
