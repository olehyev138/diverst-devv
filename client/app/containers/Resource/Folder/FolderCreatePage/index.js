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
import { selectUser } from 'containers/Shared/App/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { createFolderBegin, foldersUnmount } from 'containers/Resource/actions';
import FolderForm from 'components/Resource/Folder/FolderForm';

export function FolderCreatePage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const { currentUser, currentGroup } = props;
  const rs = new RouteService(useContext);

  let foldersIndexPath;
  if (props.path.startsWith('/groups'))
    foldersIndexPath = ROUTES.group.resources.folders.index.path(rs.params('group_id'));
  else
    foldersIndexPath = ROUTES.admin.manage.resources.folders.index.path();

  const links = {
    foldersIndex: foldersIndexPath,
  };

  useEffect(() => () => {
    props.foldersUnmount();
  }, []);

  return (
    <FolderForm
      folderAction={props.createFolderBegin}
      buttonText='Create'
      currentUser={currentUser}
      currentGroup={currentGroup}
      links={links}
    />
  );
}

FolderCreatePage.propTypes = {
  path: PropTypes.string,
  createFolderBegin: PropTypes.func,
  foldersUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser()
});

const mapDispatchToProps = {
  createFolderBegin,
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
