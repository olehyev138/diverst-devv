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
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import {
  selectFormFolder, selectPaginatedSelectFolders, selectValid,
  selectFormResource,
} from 'containers/Resource/selectors';

import {
  getFolderBegin, updateResourceBegin,
  resourcesUnmount, getFoldersBegin,
  getResourceBegin,
} from 'containers/Resource/actions';

import ResourceForm from 'components/Resource/Resource/ResourceForm';
import messages from '../messages';
import {
  getFolderShowPath,
  getFolderIndexPath,
} from 'utils/resourceHelpers';

export function FolderEditPage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const rs = new RouteService(useContext);
  const { location } = rs;

  const type = props.path.startsWith('/groups') ? 'group' : 'admin';

  const { currentUser, currentGroup, currentFolder, currentEnterprise, currentResource } = props;

  const links = {
    cancelPath: getFolderShowPath(currentFolder) || getFolderIndexPath(type, rs.params('group_id')[0]),
  };

  useEffect(() => {
    const resourceId = rs.params('item_id')[0];
    const folderId = rs.params('folder_id')[0];
    const groupId = rs.params('group_id')[0];
    props.getFolderBegin({ id: folderId });
    props.getResourceBegin({ id: resourceId });
    if (type === 'group')
      props.getFoldersBegin({ group_id: groupId[0] });
    else if (type === 'admin')
      props.getFoldersBegin({ enterprise_id: currentEnterprise.id });

    return () => props.resourcesUnmount();
  }, []);

  return (
    <ResourceForm
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
    />
  );
}

FolderEditPage.propTypes = {
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
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  currentFolder: selectFormFolder(),
  folders: selectPaginatedSelectFolders(),
  currentResource: selectFormResource(),
  currentEnterprise: selectEnterprise(),
  valid: selectValid(),
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
)(FolderEditPage);
