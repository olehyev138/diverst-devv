import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Resource/reducer';
import saga from 'containers/Resource/saga';

import { selectGroup } from 'containers/Group/selectors';
import { selectPaginatedSelectFolders } from 'containers/Resource/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { getFoldersBegin, createFolderBegin, foldersUnmount } from 'containers/Resource/actions';
import FolderForm from 'components/Resource/Folder/FolderForm';

export function FolderCreatePage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const { currentUser, currentGroup, currentEnterprise } = props;
  const rs = new RouteService(useContext);
  const { location } = rs;

  let foldersIndexPath;
  let folderShowPath;
  let type;
  if (props.path.startsWith('/groups')) {
    type = 'group';
    foldersIndexPath = ROUTES.group.resources.folders.index.path(rs.params('group_id'));
    folderShowPath = id => ROUTES.group.resources.folders.show.path(rs.params('group_id'), id);
  } else {
    type = 'admin';
    foldersIndexPath = ROUTES.admin.manage.resources.folders.index.path();
    folderShowPath = id => ROUTES.admin.manage.resources.folders.show.path(id);
  }

  const links = {
    foldersIndex: foldersIndexPath,
    folderShow: folderShowPath,
    cancelLink: location.fromFolder ? folderShowPath(location.fromFolder.folder.id) : foldersIndexPath
  };

  useEffect(() => {
    const groupId = rs.params('group_id');
    if (type === 'group')
      props.getFoldersBegin({ group_id: groupId[0] });
    else if (type === 'admin')
      props.getFoldersBegin({ group_id: currentEnterprise.id });
    return () => props.foldersUnmount();
  }, []);

  return (
    <FolderForm
      getFoldersBegin={props.getFoldersBegin}
      selectFolders={props.folders}
      folderAction={props.createFolderBegin}
      buttonText='Create'
      currentUser={currentUser}
      currentGroup={currentGroup}
      links={links}
      type={type}
      from={location.fromFolder ? location.fromFolder : null}
    />
  );
}

FolderCreatePage.propTypes = {
  path: PropTypes.string,
  getFoldersBegin: PropTypes.func,
  selectFolders: PropTypes.array,
  createFolderBegin: PropTypes.func,
  foldersUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEnterprise: PropTypes.object,
  folders: PropTypes.array,
  location: PropTypes.shape({
    state: PropTypes.object,
  })
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  folders: selectPaginatedSelectFolders(),
  currentEnterprise: selectEnterprise(),
});

const mapDispatchToProps = {
  createFolderBegin,
  getFoldersBegin,
  foldersUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(FolderCreatePage);
