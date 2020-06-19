import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams, useLocation } from 'react-router-dom';

import { injectIntl, intlShape } from 'react-intl';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Resource/reducer';
import saga from 'containers/Resource/saga';

import { selectPaginatedSelectFolders, selectFolder, selectIsCommitting } from 'containers/Resource/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';

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

import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function ResourceCreatePage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const { group_id: groupId, folder_id: folderId } = useParams();
  const location = useLocation();

  const { currentUser, currentGroup, currentEnterprise, currentFolder } = props;

  const type = location.pathname.startsWith('/groups') ? 'group' : 'admin';

  const links = {
    cancelPath: getFolderShowPath(currentFolder) || getFolderIndexPath(type, groupId),
  };

  useEffect(() => {
    props.getFolderBegin({ id: folderId });
    if (type === 'group')
      props.getFoldersBegin({ group_id: groupId });
    else if (type === 'admin')
      props.getFoldersBegin({ enterprise_id: currentEnterprise.id });
    return () => props.resourcesUnmount();
  }, []);

  return (
    <React.Fragment>
      <DiverstBreadcrumbs />
      <ResourceForm
        getFoldersBegin={props.getFoldersBegin}
        selectFolders={props.searchFolders}
        resourceAction={props.createResourceBegin}
        buttonText={props.intl.formatMessage(messages.create)}
        currentUser={currentUser}
        currentGroup={currentGroup}
        currentFolder={currentFolder}
        links={links}
        type={type}
      />
    </React.Fragment>
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
  ['currentGroup.permissions.resources_create?'],
  (props, params, location) => getFolderIndexPath(location.pathname.startsWith('/groups') ? 'group' : 'admin', params.group_id),
  permissionMessages.resource.groupResource.resourceCreatePage
));
