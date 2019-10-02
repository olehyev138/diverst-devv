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

import { selectGroup } from 'containers/Group/selectors';
import { selectPaginatedSelectFolders, selectFolder } from 'containers/Resource/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  getFolderBegin, createResourceBegin,
  resourcesUnmount, getFoldersBegin,
} from 'containers/Resource/actions';
import ResourceForm from 'components/Resource/Resource/ResourceForm';

import messages from '../messages';

export function ResourceCreatePage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const { currentUser, currentGroup, currentEnterprise, currentFolder } = props;
  const rs = new RouteService(useContext);

  let folderShowPath;
  let type;
  if (props.path.startsWith('/groups')) {
    type = 'group';
    folderShowPath = id => ROUTES.group.resources.folders.show.path(rs.params('group_id'), id);
  } else {
    type = 'admin';
    folderShowPath = id => ROUTES.admin.manage.resources.folders.show.path(id);
  }

  const links = {
    folderShow: folderShowPath,
  };

  useEffect(() => {
    const groupId = rs.params('group_id')[0];
    const folderId = rs.params('folder_id')[0];
    props.getFolderBegin({ id: folderId });
    if (type === 'group')
      props.getFoldersBegin({ group_id: groupId });
    else if (type === 'admin')
      props.getFoldersBegin({ group_id: currentEnterprise.id });
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
  location: PropTypes.shape({
    state: PropTypes.object,
  })
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  searchFolders: selectPaginatedSelectFolders(),
  currentFolder: selectFolder(),
  currentEnterprise: selectEnterprise(),
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
)(ResourceCreatePage);
