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

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import {
  selectFormFolder, selectFolder,
  selectPaginatedSelectFolders, selectValid
} from 'containers/Resource/selectors';

import {
  getParentPage,
} from 'utils/resourceHelpers';

import {
  getFolderBegin, updateFolderBegin,
  foldersUnmount, getFoldersBegin,
  validateFolderPasswordBegin,
} from 'containers/Resource/actions';

import FolderForm from 'components/Resource/Folder/FolderForm';

import {
  Card, CardContent, Button, TextField,
  DialogActions, DialogContent, DialogContentText, DialogTitle
} from '@material-ui/core';
import { Field, Formik, Form } from 'formik';

export function FolderEditPage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const rs = new RouteService(useContext);
  const { location } = rs;

  let foldersIndexPath;
  let folderShowPath;
  let type;
  if (props.path.startsWith('/groups')) {
    type = 'group';
    foldersIndexPath = ROUTES.group.resources.folders.index.path(rs.params('group_id'));
    folderShowPath = id => ROUTES.group.resources.folders.show.path(rs.params('group_id'), id);
  } else {
    type = 'admin';
    foldersIndexPath = ROUTES.admin.manage.resources.folders.index.path();
    folderShowPath = id => ROUTES.admin.manage.resources.folders.show.path(id);
  }

  const { currentUser, currentGroup, currentFolder, currentFormFolder, currentEnterprise, valid } = props;

  const links = {
    foldersIndex: foldersIndexPath,
    folderShow: folderShowPath,
    cancelLink: getParentPage(currentFolder)
  };

  useEffect(() => {
    const folderId = rs.params('item_id');
    const groupId = rs.params('group_id');
    props.getFolderBegin({ id: folderId });
    if (type === 'group')
      props.getFoldersBegin({ group_id: groupId[0] });
    else if (type === 'admin')
      props.getFoldersBegin({ group_id: currentEnterprise.id });

    return () => props.foldersUnmount();
  }, []);

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
        <FolderForm
          getFoldersBegin={props.getFoldersBegin}
          selectFolders={props.folders}
          folderAction={props.updateFolderBegin}
          buttonText='Update'
          currentUser={currentUser}
          currentGroup={currentGroup}
          folder={currentFormFolder}
          links={links}
          type={type}
          from={location.fromFolder ? location.fromFolder : null}
        />
      )}
    </div>
  );
}

FolderEditPage.propTypes = {
  path: PropTypes.string,
  getFoldersBegin: PropTypes.func,
  selectFolders: PropTypes.array,
  getFolderBegin: PropTypes.func,
  updateFolderBegin: PropTypes.func,
  validateFolderPasswordBegin: PropTypes.func,
  foldersUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentFolder: PropTypes.object,
  currentFormFolder: PropTypes.object,
  currentEnterprise: PropTypes.object,
  folders: PropTypes.array,
  valid: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentFolder: selectFolder(),
  currentFormFolder: selectFormFolder(),
  folders: selectPaginatedSelectFolders(),
  currentEnterprise: selectEnterprise(),
  valid: selectValid(),
});

const mapDispatchToProps = {
  getFolderBegin,
  updateFolderBegin,
  getFoldersBegin,
  foldersUnmount,
  validateFolderPasswordBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(FolderEditPage);
