import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useLocation, useParams } from 'react-router-dom';

import { injectIntl, intlShape } from 'react-intl';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Resource/reducer';
import saga from 'containers/Resource/saga';

import { selectPaginatedSelectFolders, selectIsCommitting } from 'containers/Resource/selectors';
import { selectUser, selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';

import { getFoldersBegin, createFolderBegin, foldersUnmount } from 'containers/Resource/actions';
import FolderForm from 'components/Resource/Folder/FolderForm';

import {
  getFolderShowPath,
  getFolderIndexPath
} from 'utils/resourceHelpers';
import messages from 'containers/Resource/Folder/messages';
import Conditional from 'components/Compositions/Conditional';

export function FolderCreatePage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const { currentUser, currentGroup, currentEnterprise } = props;

  const location = useLocation();
  const { group_id: groupId } = useParams();

  const links = {
    cancelLink: location.fromFolder ? getFolderShowPath(location.fromFolder.folder) : getFolderIndexPath('admin', groupId)
  };

  useEffect(() => {
    props.getFoldersBegin({ enterprise: currentEnterprise.id });
    return () => props.foldersUnmount();
  }, []);

  return (
    <FolderForm
      getFoldersBegin={props.getFoldersBegin}
      selectFolders={props.folders}
      folderAction={props.createFolderBegin}
      buttonText={props.intl.formatMessage(messages.create)}
      currentUser={currentUser}
      currentGroup={currentGroup}
      links={links}
      type='admin'
      permissions={props.permissions}
      from={location.fromFolder ? location.fromFolder : null}
      isCommitting={props.isCommitting}
    />
  );
}

FolderCreatePage.propTypes = {
  intl: intlShape.isRequired,
  path: PropTypes.string,
  getFoldersBegin: PropTypes.func,
  selectFolders: PropTypes.array,
  createFolderBegin: PropTypes.func,
  foldersUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEnterprise: PropTypes.object,
  permissions: PropTypes.object,
  folders: PropTypes.array,
  isCommitting: PropTypes.bool,
  location: PropTypes.shape({
    state: PropTypes.object,
  })
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  folders: selectPaginatedSelectFolders(),
  currentEnterprise: selectEnterprise(),
  isCommitting: selectIsCommitting(),
  permissions: selectPermissions(),
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
  injectIntl,
)(Conditional(
  FolderCreatePage,
  ['permissions.enterprise_folders_create'],
  (props, params, location) => location.fromFolder
    ? getFolderShowPath(location.fromFolder.folder)
    : getFolderIndexPath('admin'),
  'resource.enterpriseFolder.folderCreatePage'
));
