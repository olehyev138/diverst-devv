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

import { injectIntl, intlShape } from 'react-intl';

import RouteService from 'utils/routeHelpers';

import { selectUser, selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';
import {
  selectFormFolder, selectPaginatedSelectFolders, selectValid,
  selectFormResource, selectIsCommitting, selectIsFormLoading
} from 'containers/Resource/selectors';

import {
  getFolderBegin, updateResourceBegin,
  resourcesUnmount, getFoldersBegin,
  getResourceBegin,
} from 'containers/Resource/actions';

import ResourceForm from 'components/Resource/Resource/ResourceForm';
import messages from 'containers/Resource/Resource/messages';
import {
  getFolderShowPath,
  getFolderIndexPath,
} from 'utils/resourceHelpers';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function ResourceEditPage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const rs = new RouteService(useContext);
  const { location } = rs;

  const { currentUser, currentGroup, currentFolder, currentEnterprise, currentResource } = props;

  const links = {
    cancelPath: getFolderShowPath(currentFolder) || getFolderIndexPath('admin', rs.params('group_id')),
  };

  useEffect(() => {
    const resourceId = rs.params('item_id');
    const folderId = rs.params('folder_id');
    props.getFolderBegin({ id: folderId });
    props.getResourceBegin({ id: resourceId });
    props.getFoldersBegin({ enterprise_id: currentEnterprise.id });

    return () => props.resourcesUnmount();
  }, []);

  return (
    <ResourceForm
      edit
      getFoldersBegin={props.getFoldersBegin}
      selectFolders={props.folders}
      resourceAction={props.updateResourceBegin}
      buttonText={props.intl.formatMessage(messages.update)}
      currentUser={currentUser}
      currentGroup={currentGroup}
      resource={currentResource}
      currentFolder={currentFolder}
      links={links}
      permissions={props.permissions}
      type='admin'
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
    />
  );
}

ResourceEditPage.propTypes = {
  intl: intlShape.isRequired,
  path: PropTypes.string,
  getFoldersBegin: PropTypes.func,
  selectFolders: PropTypes.array,
  getFolderBegin: PropTypes.func,
  updateResourceBegin: PropTypes.func,
  resourcesUnmount: PropTypes.func,
  getResourceBegin: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentFolder: PropTypes.object,
  currentEnterprise: PropTypes.object,
  currentResource: PropTypes.object,
  permissions: PropTypes.object,
  folders: PropTypes.array,
  valid: PropTypes.bool,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  currentFolder: selectFormFolder(),
  folders: selectPaginatedSelectFolders(),
  currentResource: selectFormResource(),
  currentEnterprise: selectEnterprise(),
  valid: selectValid(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getFolderBegin,
  updateResourceBegin,
  getFoldersBegin,
  resourcesUnmount,
  getResourceBegin,
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
  ResourceEditPage,
  ['currentResource.permissions.update?', 'isFormLoading'],
  (props, rs) => getFolderIndexPath('admin'),
  permissionMessages.resource.enterpriseResource.resourceEditPage
));
