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

import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import { selectFolder, selectValid,
  selectPaginatedFolders, selectPaginatedResources,
  selectFoldersTotal, selectResourcesTotal, selectIsLoading,
  selectIsFormLoading, selectHasChanged
} from 'containers/Resource/selectors';

import {
  getFolderBegin, getFoldersBegin,
  deleteFolderBegin, foldersUnmount,
  validateFolderPasswordBegin,
  getResourcesBegin,
  deleteResourceBegin,
  archiveResourceBegin,
} from 'containers/Resource/actions';

import Folder from 'components/Resource/Folder/Folder';

import { Field, Form, Formik } from 'formik';
import { Button, Card, CardContent, TextField } from '@material-ui/core';
import dig from 'object-dig';
import {
  getParentPage,
  getFolderNewPath,
  getFolderEditPath,
  getFolderShowPath,
  getResourceNewPath,
  getResourceEditPath, getFolderIndexPath,
} from 'utils/resourceHelpers';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Resource/Folder/messages';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';

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

  const {
    currentUser,
    currentFolder,
    subFolders,
    resources,
    valid,
  } = props;

  const links = {
    folderShow: folder => getFolderShowPath(folder),
    folderNew: getFolderNewPath(currentFolder),
    parentFolder: getParentPage(currentFolder),
    folderEdit: folder => getFolderEditPath(folder),
    resourceNew: getResourceNewPath(currentFolder),
    resourceEdit: resource => getResourceEditPath(currentFolder, resource),
  };

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
        parent_id: parentId,
      };
      props.getFoldersBegin(newParams);
      setParams(newParams);
    }
  };

  const getResources = (folderId, scopes = null, resetParams = false) => {
    const groupId = dig(props, 'currentGroup', 'id');
    const enterpriseId = dig(props, 'currentEnterprise', 'id');

    if (resetParams)
      setParams(defaultParams);

    if (groupId) {
      const newParams = {
        ...params,
        group_id: groupId,
        folder_id: folderId,
      };
      props.getResourcesBegin({ ...newParams, query_scopes: ['not_archived'] });
      setParams(newParams);
    } else {
      const newParams = {
        ...params,
        folder_id: folderId,
      };
      props.getResourcesBegin({ ...newParams, query_scopes: ['not_archived'] });
      setParams(newParams);
    }
  };

  useEffect(() => {
    const folderId = rs.params('item_id');

    // get folder specified in path
    props.getFolderBegin({ id: folderId });
    getFolders(folderId);
    getResources(folderId);

    return () => props.foldersUnmount();
  }, []);

  useEffect(() => {
    if (props.hasChanged) {
      const folderId = rs.params('item_id');

      // get folder specified in path
      props.getFolderBegin({ id: folderId });
      getFolders(folderId);
      getResources(folderId);
    }
    return () => props.foldersUnmount();
  }, [props.hasChanged]);

  const handleFolderPagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getFoldersBegin(newParams);
    setParams(newParams);
  };

  const handleResourcePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getResourcesBegin({ ...newParams, query_scopes: ['not_archived'] });
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
                  <DiverstFormattedMessage {...messages.authenticate.label1} />
                  <br />
                  <DiverstFormattedMessage {...messages.authenticate.label2} />
                  <Field
                    component={TextField}
                    autoFocus
                    margin='dense'
                    id='password'
                    name='password'
                    label={<DiverstFormattedMessage {...messages.authenticate.password} />}
                    type='password'
                    value={values.password}
                    onChange={handleChange}
                    fullWidth
                  />
                </CardContent>
                <Card>
                  <Button color='primary' type='submit'>
                    <DiverstFormattedMessage {...messages.authenticate.button} />
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
          currentGroup={props.currentGroup}
          deleteFolderBegin={props.deleteFolderBegin}
          deleteResourceBegin={props.deleteResourceBegin}
          folder={currentFolder}
          folders={subFolders}
          foldersTotal={props.foldersTotal}
          resourcesTotal={props.resourcesTotal}
          handleResourcePagination={handleResourcePagination}
          handleFolderPagination={handleFolderPagination}
          archiveResourceBegin={props.archiveResourceBegin}
          type='group'
          resources={resources}
          isLoading={props.isLoading}
          isFormLoading={props.isFormLoading}
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
  archiveResourceBegin: PropTypes.func,
  foldersUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentFolder: PropTypes.object,
  currentEnterprise: PropTypes.object,
  subFolders: PropTypes.array,
  foldersTotal: PropTypes.number,
  resources: PropTypes.array,
  resourcesTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  valid: PropTypes.bool,
  hasChanged: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  currentFolder: selectFolder(),
  currentEnterprise: selectEnterprise(),
  subFolders: selectPaginatedFolders(),
  foldersTotal: selectFoldersTotal(),
  resources: selectPaginatedResources(),
  resourcesTotal: selectResourcesTotal(),
  isLoading: selectIsLoading(),
  isFormLoading: selectIsFormLoading(),
  valid: selectValid(),
  hasChanged: selectHasChanged(),
});

const mapDispatchToProps = {
  getFolderBegin,
  getFoldersBegin,
  deleteFolderBegin,
  foldersUnmount,
  validateFolderPasswordBegin,
  getResourcesBegin,
  deleteResourceBegin,
  archiveResourceBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  FolderPage,
  ['currentFolder.permissions.show?', 'isFormLoading'],
  (props, rs) => ROUTES.group.resources.index.path(rs.params('group_id')),
  'resource.groupFolder.folderPage'
));
