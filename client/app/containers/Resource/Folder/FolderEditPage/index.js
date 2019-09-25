import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Resource/reducer';
import saga from 'containers/Resource/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectFolder } from 'containers/Resource/selectors';

import {
  getFolderBegin, updateFolderBegin,
  foldersUnmount
} from 'containers/Resource/actions';

import FolderForm from 'components/Resource/Folder/FolderForm';

export function FolderEditPage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const rs = new RouteService(useContext);

  let foldersIndexPath;
  if (props.path.startsWith('/groups'))
    foldersIndexPath = ROUTES.group.resources.folders.index.path(rs.params('group_id'));
  else
    foldersIndexPath = ROUTES.admin.manage.resources.folders.index.path();

  const links = {
    foldersIndex: foldersIndexPath,
  };

  useEffect(() => {
    const folderId = rs.params('item_id');
    props.getFolderBegin({ id: folderId });

    return () => props.foldersUnmount();
  }, []);

  const { currentUser, currentGroup, currentFolder } = props;

  return (
    <FolderForm
      folderAction={props.updateFolderBegin}
      buttonText='Update'
      currentUser={currentUser}
      currentGroup={currentGroup}
      folder={currentFolder}
      links={links}
    />
  );
}

FolderEditPage.propTypes = {
  path: PropTypes.string,
  getFolderBegin: PropTypes.func,
  updateFolderBegin: PropTypes.func,
  foldersUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentFolder: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentFolder: selectFolder(),
});

const mapDispatchToProps = {
  getFolderBegin,
  updateFolderBegin,
  foldersUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(FolderEditPage);
