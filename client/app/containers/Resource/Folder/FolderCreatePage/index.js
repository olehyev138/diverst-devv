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

import { selectPaginatedSelectFolders, selectIsCommitting } from 'containers/Resource/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';

import RouteService from 'utils/routeHelpers';

import { getFoldersBegin, createFolderBegin, foldersUnmount } from 'containers/Resource/actions';
import FolderForm from 'components/Resource/Folder/FolderForm';

import {
  getFolderShowPath,
  getFolderIndexPath
} from 'utils/resourceHelpers';
import messages from 'containers/Resource/Folder/messages';


export function FolderCreatePage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const { currentUser, currentGroup, currentEnterprise } = props;
  const rs = new RouteService(useContext);
  const { location } = rs;

  const type = props.path.startsWith('/groups') ? 'group' : 'admin';

  const links = {
    cancelLink: location.fromFolder ? getFolderShowPath(location.fromFolder.folder) : getFolderIndexPath(type, rs.params('group_id'))
  };

  useEffect(() => {
    const groupId = rs.params('group_id');
    if (type === 'group')
      props.getFoldersBegin({ group_id: groupId[0] });
    else if (type === 'admin')
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
      type={type}
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
  injectIntl
)(FolderCreatePage);
