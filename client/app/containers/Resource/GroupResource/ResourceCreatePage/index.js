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
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';

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

  const type = props.path.startsWith('/groups') ? 'group' : 'admin';

  const links = {
    cancelPath: getFolderShowPath(currentFolder) || getFolderIndexPath(type, rs.params('group_id')),
  };

  useEffect(() => {
    const groupId = rs.params('group_id');
    const folderId = rs.params('folder_id');
    props.getFolderBegin({ id: folderId });
    if (type === 'group')
      props.getFoldersBegin({ group_id: groupId });
    else if (type === 'admin')
      props.getFoldersBegin({ enterprise_id: currentEnterprise.id });
    return () => props.resourcesUnmount();
  }, []);

  return (
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
  (props, rs) => getFolderIndexPath(props.path.startsWith('/groups') ? 'group' : 'admin', rs.params('group_id')),
  permissionMessages.resource.groupResource.resourceCreatePage
));
