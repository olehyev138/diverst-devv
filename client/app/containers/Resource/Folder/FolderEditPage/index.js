import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import { injectIntl, intlShape } from 'react-intl';

import reducer from 'containers/Resource/reducer';
import saga from 'containers/Resource/saga';

import RouteService from 'utils/routeHelpers';

import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import {
  selectFormFolder, selectFolder,
  selectPaginatedSelectFolders, selectValid,
  selectIsCommitting, selectIsFormLoading
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
  Card, CardContent, CardActions, Button, TextField, Divider, Typography,
} from '@material-ui/core';
import { Field, Formik, Form } from 'formik';
import messages from 'containers/Resource/Folder/messages';

export function FolderEditPage(props) {
  useInjectReducer({ key: 'resource', reducer });
  useInjectSaga({ key: 'resource', saga });

  const rs = new RouteService(useContext);
  const { location } = rs;

  const type = props.path.startsWith('/groups') ? 'group' : 'admin';

  const { currentUser, currentGroup, currentFolder, currentFormFolder, currentEnterprise, valid } = props;

  const links = {
    cancelLink: getParentPage(currentFolder)
  };

  useEffect(() => {
    const folderId = rs.params('item_id');
    const groupId = rs.params('group_id');
    props.getFolderBegin({ id: folderId });
    if (type === 'group')
      props.getFoldersBegin({ group_id: groupId[0] });
    else if (type === 'admin')
      props.getFoldersBegin({ enterprise_id: currentEnterprise.id });

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
                  <Typography>
                    This folder is password protected.
                  </Typography>
                  <Typography>
                    Please enter the password to access the resources.
                  </Typography>
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
                <Divider />
                <CardActions>
                  <Button color='primary' type='submit'>
                    AUTHENTICATE
                  </Button>
                </CardActions>
              </Card>
            </Form>
          )}
        />
      )}
      { valid === true && (
        <FolderForm
          edit
          getFoldersBegin={props.getFoldersBegin}
          selectFolders={props.folders}
          folderAction={props.updateFolderBegin}
          buttonText={props.intl.formatMessage(messages.update)}
          currentUser={currentUser}
          currentGroup={currentGroup}
          folder={currentFormFolder}
          links={links}
          type={type}
          from={location.fromFolder ? location.fromFolder : null}
          isCommitting={props.isCommitting}
          isFormLoading={props.isFormLoading}
        />
      )}
    </div>
  );
}

FolderEditPage.propTypes = {
  intl: intlShape.isRequired,
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
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  currentFolder: selectFolder(),
  currentFormFolder: selectFormFolder(),
  folders: selectPaginatedSelectFolders(),
  currentEnterprise: selectEnterprise(),
  valid: selectValid(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
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
  injectIntl
)(FolderEditPage);
