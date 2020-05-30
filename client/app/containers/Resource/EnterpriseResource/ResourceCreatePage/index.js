import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { injectIntl, intlShape } from 'react-intl';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Resource/reducer';
import saga from 'containers/Resource/saga';

import { selectPaginatedSelectFolders, selectFolder, selectIsCommitting } from 'containers/Resource/selectors';
import { selectUser, selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';

import RouteService from 'utils/routeHelpers';

import {
  getFolderBegin, createResourceBegin,
  resourcesUnmount, getFoldersBegin,
} from 'containers/Resource/actions';
import ResourceForm from 'components/Resource/Resource/ResourceForm';

import messages from 'containers/Resource/Resource/messages';
import {
  getFolderShowPath,
  getFolderIndexPath
} from 'utils/resourceHelpers';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function ResourceCreatePage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const { currentUser, currentGroup, currentEnterprise, currentFolder } = props;
  const rs = new RouteService(useContext);

  const links = {
    cancelPath: getFolderShowPath(currentFolder) || getFolderIndexPath('admin', rs.params('group_id')),
  };

  useEffect(() => {
    const folderId = rs.params('folder_id');
    props.getFolderBegin({ id: folderId });
    return () => props.resourcesUnmount();
  }, []);

  return (
    <ResourceForm
      getFoldersBegin={props.getFoldersBegin}
      selectFolders={props.searchFolders}
      resourceAction={props.createResourceBegin}
      buttonText={props.intl.formatMessage(messages.create)}
      currentUser={currentUser}
      currentEnterprise={currentEnterprise}
      currentFolder={currentFolder}
      permissions={props.permissions}
      links={links}
      type='admin'
    />
  );
}

ResourceCreatePage.propTypes = {
  intl: intlShape.isRequired,
  path: PropTypes.string,
  getFolderBegin: PropTypes.func,
  getFoldersBegin: PropTypes.func,
  createResourceBegin: PropTypes.func,
  resourcesUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEnterprise: PropTypes.object,
  currentFolder: PropTypes.object,
  permissions: PropTypes.object,
  searchFolders: PropTypes.array,
  folders: PropTypes.array,
  isCommitting: PropTypes.bool,
  location: PropTypes.shape({
    state: PropTypes.object,
  })
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  searchFolders: selectPaginatedSelectFolders(),
  currentFolder: selectFolder(),
  currentEnterprise: selectEnterprise(),
  isCommitting: selectIsCommitting(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  createResourceBegin,
  getFoldersBegin,
  getFolderBegin,
  resourcesUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  injectIntl
)(Conditional(
  ResourceCreatePage,
  ['permissions.enterprise_folders_create'],
  (props, rs) => getFolderIndexPath('admin'),
  permissionMessages.resource.enterpriseResource.resourceCreatePage
));
