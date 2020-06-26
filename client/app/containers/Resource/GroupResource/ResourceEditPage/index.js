import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams, useLocation } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Resource/reducer';
import saga from 'containers/Resource/saga';

import { injectIntl, intlShape } from 'react-intl';

import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
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

import { getFolderShowPath, getFolderIndexPath, } from 'utils/resourceHelpers';

import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function ResourceEditPage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const { item_id: resourceId, folder_id: folderId, group_id: groupId } = useParams();
  const location = useLocation();

  const type = location.pathname.startsWith('/groups') ? 'group' : 'admin';

  const { currentUser, currentGroup, currentFolder, currentEnterprise, currentResource } = props;

  const links = {
    cancelPath: getFolderShowPath(currentFolder) || getFolderIndexPath(type, groupId),
  };

  useEffect(() => {
    props.getFolderBegin({ id: folderId });
    props.getResourceBegin({ id: resourceId });
    if (type === 'group')
      props.getFoldersBegin({ group_id: groupId[0] });
    else if (type === 'admin')
      props.getFoldersBegin({ enterprise_id: currentEnterprise.id });

    return () => props.resourcesUnmount();
  }, []);

  return (
    <React.Fragment>
      <DiverstBreadcrumbs />
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
        type={type}
        isCommitting={props.isCommitting}
        isFormLoading={props.isFormLoading}
      />
    </React.Fragment>
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
  (props, params, location) => getFolderIndexPath(location.pathname.startsWith('/groups') ? 'group' : 'admin', params.group_id),
  permissionMessages.resource.groupResource.resourceEditPage,
  true
));
