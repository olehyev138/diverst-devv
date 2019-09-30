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

import { selectPaginatedFolders, selectFoldersTotal } from 'containers/Resource/selectors';
import { selectEnterprise } from 'containers/Shared/App/selectors';
import { getFoldersBegin, foldersUnmount } from 'containers/Resource/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import FoldersList from 'components/Resource/Folder/FoldersList';

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

  let foldersIndexPath;
  let folderShowPath;
  let folderNewPath;
  let folderEditPath;
  if (props.path.startsWith('/groups')) {
    foldersIndexPath = ROUTES.group.resources.folders.index.path(rs.params('group_id'));
    folderShowPath = id => ROUTES.group.resources.folders.show.path(rs.params('group_id'), id);
    folderNewPath = ROUTES.group.resources.folders.new.path(rs.params('group_id'));
    folderEditPath = id => ROUTES.group.resources.folders.edit.path(rs.params('group_id'), id);
  } else {
    foldersIndexPath = ROUTES.admin.manage.resources.folders.index.path();
    folderShowPath = id => ROUTES.admin.manage.resources.folders.show.path(id);
    folderNewPath = ROUTES.group.admin.manage.folders.new.path(rs.params());
    folderEditPath = id => ROUTES.admin.manage.resources.folders.edit.path(id);
  }

  const links = {
    foldersIndex: foldersIndexPath,
    folderShow: folderShowPath,
    folderNew: folderNewPath,
    folderEdit: folderEditPath,
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
        enterprise_id: enterpriseId,
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
    <FoldersList
      folders={props.folders}
      foldersTotal={props.foldersTotal}
      handlePagination={handlePagination}
      links={links}
    />
  );
}

FoldersPage.propTypes = {
  path: PropTypes.string,
  getFoldersBegin: PropTypes.func.isRequired,
  foldersUnmount: PropTypes.func.isRequired,
  folders: PropTypes.array,
  foldersTotal: PropTypes.number,
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
});

const mapDispatchToProps = {
  getFoldersBegin,
  foldersUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(FoldersPage);
