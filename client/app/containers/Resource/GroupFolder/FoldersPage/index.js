import React, {
  memo, useEffect, useState
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
import { useParams, useLocation } from 'react-router-dom';

import { selectPaginatedFolders, selectFoldersTotal, selectIsFolderLoading } from 'containers/Resource/selectors';
import { selectEnterprise } from 'containers/Shared/App/selectors';
import { getFoldersBegin, foldersUnmount, deleteFolderBegin } from 'containers/Resource/actions';

import FoldersList from 'components/Resource/Folder/FoldersList';
import {
  getFolderEditPath,
  getFolderNewPath,
  getFolderShowPath
} from 'utils/resourceHelpers';

import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in FoldersList
  page: 0,
  order: 'desc',
  orderBy: 'id',
});

export function FoldersPage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const { group_id: groupId } = useParams();
  const path = useLocation().pathname;

  const type = path.startsWith('/groups') ? 'group' : 'admin';

  const links = {
    folderShow: folder => getFolderShowPath(folder),
    folderNew: getFolderNewPath(type, groupId),
    folderEdit: folder => getFolderEditPath(folder),
  };

  const [params, setParams] = useState(defaultParams);

  const getFolders = (scopes, resetParams = false) => {
    const groupId = dig(props, 'currentGroup', 'id');
    const enterpriseId = dig(props, 'currentEnterprise', 'id');

    if (resetParams)
      setParams(defaultParams);

    if (groupId) {
      const newParams = {
        ...params,
        group_id: groupId,
        parent_id: null,
      };
      props.getFoldersBegin(newParams);
      setParams(newParams);
    } else {
      const newParams = {
        ...params,
        parent_id: null,
      };
      props.getFoldersBegin(newParams);
      setParams(newParams);
    }
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
    <React.Fragment>
      <DiverstBreadcrumbs />
      <FoldersList
        folders={props.folders}
        foldersTotal={props.foldersTotal}
        deleteFolderBegin={props.deleteFolderBegin}
        handlePagination={handlePagination}
        isLoading={props.isLoading}
        links={links}
        type='group'
        currentGroup={props.currentGroup}
      />
    </React.Fragment>
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
  isLoading: selectIsFolderLoading(),
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
  ['currentGroup.permissions.resources_view?'],
  (props, params) => ROUTES.group.home.path(params.group_id),
  permissionMessages.resource.groupFolder.foldersPage
));
