/**
 *
 * Folder Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import Select from 'components/Shared/DiverstSelect';
import { compose } from 'redux';
import dig from 'object-dig';

import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Switch, FormControlLabel, FormControl, Grid, Divider
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Resource/Folder/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

/* eslint-disable object-curly-newline */
export function FolderFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const groupId = props.type === 'group' && props.currentGroup ? {
    group_id: props.currentGroup.id,
  } : {};

  const enterpriseId = props.type === 'admin' && props.currentEnterprise ? {
    enterprise_id: props.currentEnterprise.id
  } : {};

  const parentSelectAction = (searchKey = '') => {
    props.getFoldersBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      ...groupId,
      ...enterpriseId,
    });
  };

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.folder}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              disabled={props.isCommitting}
              id='name'
              name='name'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.form.name} />}
              value={values.name}
            />
            <Field
              component={Select}
              fullWidth
              disabled={props.isCommitting}
              id='parent_id'
              name='parent_id'
              label={<DiverstFormattedMessage {...messages.form.parent} />}
              margin='normal'
              value={values.parent_id}
              options={props.selectFolders}
              onMenuOpen={parentSelectAction}
              onChange={value => setFieldValue('parent_id', value)}
              onInputChange={value => parentSelectAction(value)}
              onBlur={() => setFieldTouched('parent_id', true)}
              isClearable
            />
            <Grid container spacing={3}>
              <Grid item>
                <FormControl
                  variant='outlined'
                  margin='normal'
                >
                  <FormControlLabel
                    labelPlacement='bottom'
                    checked={values.password_protected}
                    control={(
                      <Field
                        component={Switch}
                        color='primary'
                        onChange={handleChange}
                        disabled={props.isCommitting}
                        id='password_protected'
                        name='password_protected'
                        checked={values.password_protected}
                        value={values.password_protected}
                      />
                    )}
                    label={<DiverstFormattedMessage {...messages.form.password_question} />}
                  />
                </FormControl>
              </Grid>
              {(values.password_protected) && (
                <Grid item xs>
                  <Field
                    component={TextField}
                    onChange={handleChange}
                    fullWidth
                    disabled={props.isCommitting}
                    id='password'
                    name='password'
                    margin='normal'
                    value={values.password}
                    label={<DiverstFormattedMessage {...messages.form.password} />}
                  />
                </Grid>
              )}
            </Grid>
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              to={props.links.cancelLink}
              component={dig(props, 'links', 'cancelLink') ? WrappedNavLink : 'button'}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function FolderForm(props) {
  const folder = dig(props, 'folder');
  const initialValues = buildValues(folder, {
    id: { default: '' },
    name: { default: '' },
    parent: { default: props.from && props.from.action === 'new' ? { value: props.from.folder.id, label: props.from.folder.name } : null, customKey: 'parent_id' },
    password: { default: '' },
    password_protected: { default: false },
    owner_id: { default: dig(props, 'currentUser', 'id') || '' },
    group_id: { default: props.type === 'group' ? dig(props, 'currentGroup', 'id') : null },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, ['parent_id']);
        props.folderAction(payload);
      }}
    >
      {formikProps => <FolderFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

FolderForm.propTypes = {
  edit: PropTypes.bool,
  type: PropTypes.string,
  getFoldersBegin: PropTypes.func,
  selectFolders: PropTypes.array,
  folderAction: PropTypes.func,
  folder: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEnterprise: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  from: PropTypes.shape({
    folder: PropTypes.shape({
      id: PropTypes.number,
      name: PropTypes.string,
    }),
    action: PropTypes.string,
  }),
  links: PropTypes.shape({
    cancelLink: PropTypes.string,
  })
};

FolderFormInner.propTypes = {
  edit: PropTypes.bool,
  folder: PropTypes.object,
  type: PropTypes.string,
  getFoldersBegin: PropTypes.func,
  selectFolders: PropTypes.array,
  currentGroup: PropTypes.object,
  currentEnterprise: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  from: PropTypes.shape({
    folder: PropTypes.shape({
      id: PropTypes.number,
      name: PropTypes.string,
    }),
    action: PropTypes.string,
  }),
  links: PropTypes.shape({
    cancelLink: PropTypes.string,
  })
};

export default compose(
  memo,
)(FolderForm);
