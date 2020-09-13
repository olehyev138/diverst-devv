import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Resource/reducer';
import saga from 'containers/Resource/saga';

import { injectIntl, intlShape } from 'react-intl';

import { selectUser, selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';
import {
  selectFormFolder, selectPaginatedSelectFolders, selectValid,
  selectFormResource, selectIsCommitting, selectIsResourceFormLoading
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

  const { group_id: groupId, folder_id: folderId, item_id: resourceId } = useParams();

  const { currentUser, currentGroup, currentFolder, currentEnterprise, currentResource } = props;

  const links = {
    cancelPath: getFolderShowPath(currentFolder) || getFolderIndexPath('admin', groupId),
  };

  useEffect(() => {
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
      currentEnterprise={currentEnterprise}
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
  isFormLoading: selectIsResourceFormLoading(),
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
  (props, params) => getFolderIndexPath('admin'),
  permissionMessages.resource.enterpriseResource.resourceEditPage
));