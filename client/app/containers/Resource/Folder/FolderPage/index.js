import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Resource/reducer';
import saga from 'containers/Resource/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectFolder, selectValid,
  selectPaginatedFolders, selectPaginatedResources,
  selectFoldersTotal, selectResourcesTotal,
} from 'containers/Resource/selectors';

import {
  getFolderBegin, getFoldersBegin,
  deleteFolderBegin, foldersUnmount,
  validateFolderPasswordBegin,
  getResourcesBegin,
  deleteResourceBegin,
} from 'containers/Resource/actions';

import Folder from 'components/Resource/Folder/Folder';

import { Field, Form, Formik } from 'formik';
import { Button, Card, CardContent, TextField } from '@material-ui/core';
import dig from 'object-dig';

const defaultParams = Object.freeze({
  count: 5, // TODO: Make this a constant and use it also in Folder
  page: 0,
  order: 'desc',
  orderBy: 'id',
});

export function FolderPage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const rs = new RouteService(useContext);
  let foldersIndexPath;
  let folderNewPath;
  let folderEditPath;
  let folderShowPath;
  let resourceEditPath;
  let resourceNewPath;
  if (props.path.startsWith('/groups')) {
    foldersIndexPath = ROUTES.group.resources.folders.index.path(rs.params('group_id'));
    folderShowPath = id => ROUTES.group.resources.folders.show.path(rs.params('group_id'), id);
    folderNewPath = ROUTES.group.resources.folders.new.path(rs.params('group_id'));
    folderEditPath = id => ROUTES.group.resources.folders.edit.path(rs.params('group_id'), id);
    resourceEditPath = id => ROUTES.group.resources.resources.edit.path(rs.params('group_id'), rs.params('item_id'), id);
    resourceNewPath = ROUTES.group.resources.resources.new.path(rs.params('group_id'), rs.params('item_id'));
  } else {
    foldersIndexPath = ROUTES.admin.manage.resources.folders.index.path();
    folderShowPath = id => ROUTES.admin.manage.resources.folders.show.path(id);
    folderNewPath = ROUTES.group.admin.manage.folders.new.path(rs.params());
    folderEditPath = id => ROUTES.admin.manage.resources.folders.edit.path(id);
    resourceEditPath = id => ROUTES.admin.manage.resources.resources.edit.path(rs.params('group_id'), rs.params('item_id'), id);
    resourceNewPath = ROUTES.group.admin.manage.resources.new.path(rs.params('group_id'), rs.params('item_id'));
  }

  const links = {
    foldersIndex: foldersIndexPath,
    folderShow: folderShowPath,
    folderNew: folderNewPath,
    folderEdit: folderEditPath,
    resourceNew: resourceNewPath,
    resourceEdit: resourceEditPath,
  };

  const {
    currentUser,
    currentFolder,
    subFolders,
    resources,
    valid } = props;

  const [params, setParams] = useState(defaultParams);

  const getFolders = (parentId, scopes, resetParams = false) => {
    const groupId = dig(props, 'currentGroup', 'id');
    const enterpriseId = dig(props, 'currentEnterprise', 'id');

    if (resetParams)
      setParams(defaultParams);

    if (groupId) {
      const newParams = {
        ...params,
        group_id: groupId,
        parent_id: parentId,
      };
      props.getFoldersBegin(newParams);
      setParams(newParams);
    } else {
      const newParams = {
        ...params,
        enterprise_id: enterpriseId,
        parent_id: parentId,
      };
      props.getFoldersBegin(newParams);
      setParams(newParams);
    }
  };

  const getResources = (folderId, scopes, resetParams = false) => {
    const groupId = dig(props, 'currentGroup', 'id');
    const enterpriseId = dig(props, 'currentEnterprise', 'id');

    if (resetParams)
      setParams(defaultParams);

    if (groupId) {
      const newParams = {
        ...params,
        folder_id: folderId,
      };
      props.getFoldersBegin(newParams);
      setParams(newParams);
    } else {
      const newParams = {
        ...params,
        enterprise_id: enterpriseId,
        folder_id: folderId,
      };
      props.getFoldersBegin(newParams);
      setParams(newParams);
    }
  };

  useEffect(() => {
    const folderId = rs.params('item_id')[0];

    // get folder specified in path
    props.getFolderBegin({ id: folderId });
    getFolders(folderId);
    props.getResourcesBegin({ folder_id: folderId });

    return () => props.foldersUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getFoldersBegin(newParams);
    setParams(newParams);
  };

  return (
    <div>
      { valid === false && (
        <Formik
          initialValues={{
            password: '',
          }}
          enableReinitialize
          onSubmit={(values, actions) => {
            const folderId = rs.params('item_id');
            props.validateFolderPasswordBegin({
              id: folderId[0],
              password: values.password
            });
          }}
          render={({ values, handleChange, handleSubmit }) => (
            <Form onSubmit={handleSubmit}>
              <Card>
                <CardContent>
                  This folder is password protected.
                  <br />
                  Please enter the password to access the resources.
                  <Field
                    component={TextField}
                    autoFocus
                    margin='dense'
                    id='password'
                    name='password'
                    label='Password'
                    type='password'
                    value={values.password}
                    onChange={handleChange}
                    fullWidth
                  />
                </CardContent>
                <Card>
                  <Button color='primary' type='submit'>
                    AUTHENTICATE
                  </Button>
                </Card>
              </Card>
            </Form>
          )}
        />
      )}
      { valid === true && (
        <Folder
          currentUserId={currentUser.id}
          deleteFolderBegin={props.deleteFolderBegin}
          deleteResourceBegin={props.deleteResourceBegin}
          folder={currentFolder}
          folders={subFolders}
          foldersTotal={props.foldersTotal}
          resourcesTotal={props.resourcesTotal}
          handlePagination={handlePagination}
          resources={resources}
          links={links}
        />
      )}
    </div>
  );
}

FolderPage.propTypes = {
  path: PropTypes.string,
  getFolderBegin: PropTypes.func,
  getFoldersBegin: PropTypes.func,
  deleteFolderBegin: PropTypes.func,
  deleteResourceBegin: PropTypes.func,
  validateFolderPasswordBegin: PropTypes.func,
  getResourcesBegin: PropTypes.func,
  foldersUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentFolder: PropTypes.object,
  subFolders: PropTypes.array,
  foldersTotal: PropTypes.number,
  resources: PropTypes.array,
  resourcesTotal: PropTypes.number,
  valid: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentFolder: selectFolder(),
  subFolders: selectPaginatedFolders(),
  foldersTotal: selectFoldersTotal(),
  resources: selectPaginatedResources(),
  resourcesTotal: selectResourcesTotal(),
  valid: selectValid(),
});

const mapDispatchToProps = {
  getFolderBegin,
  getFoldersBegin,
  deleteFolderBegin,
  foldersUnmount,
  validateFolderPasswordBegin,
  getResourcesBegin,
  deleteResourceBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(FolderPage);
