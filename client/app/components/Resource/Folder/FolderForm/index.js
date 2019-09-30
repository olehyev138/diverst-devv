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

import { FormattedMessage } from 'react-intl';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Switch, FormControlLabel, FormControl, Grid
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Resource/Folder/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function FolderFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const getGroupId = () => {
    if (props.type === 'group' && props.currentGroup)
      return props.currentGroup.id;
    return null;
  };

  const getEnterpriseId = () => {
    if (props.type === 'admin' && props.currentEnterprise)
      return props.currentEnterprise.id;
    return null;
  };

  const parentSelectAction = (searchKey = '') => {
    props.getFoldersBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      group_id: getGroupId(),
      enterprise_id: getEnterpriseId(),
    });
  };

  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='name'
            name='name'
            margin='normal'
            label={<FormattedMessage {...messages.form.name} />}
            value={values.name}
          />
          <Field
            component={Select}
            fullWidth
            id='parent_id'
            name='parent_id'
            label={<FormattedMessage {...messages.form.parent} />}
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
                      id='password_protected'
                      name='password_protected'
                      margin='normal'
                      checked={values.password_protected}
                      value={values.password_protected}
                    />
                  )}
                  label='Password?'
                />
              </FormControl>
            </Grid>
            { (values.password_protected) && (
              <Grid item xs>
                <Field
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  id='password'
                  name='password'
                  margin='normal'
                  value={values.password}
                  label={<FormattedMessage {...messages.form.password} />}
                />
              </Grid>
            )}
          </Grid>
        </CardContent>
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            {buttonText}
          </Button>
          <Button
            to={props.from ? props.links.folderShow(props.from.id) : props.links.foldersIndex}
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function FolderForm(props) {
  const folder = dig(props, 'folder');
  const initialValues = buildValues(folder, {
    id: { default: '' },
    name: { default: '' },
    parent: { default: props.from ? {value: props.from.id, label: props.from.name} : null, customKey: 'parent_id' },
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
        const payload = mapFields(values, ['child_ids', 'parent_id']);
        payload.path = props.from ? props.links.folderShow(props.from.id) : null;
        props.folderAction(payload);
      }}

      render={formikProps => <FolderFormInner {...props} {...formikProps} />}
    />
  );
}

FolderForm.propTypes = {
  type: PropTypes.string,
  getFoldersBegin: PropTypes.func,
  selectFolders: PropTypes.array,
  folderAction: PropTypes.func,
  folder: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEnterprise: PropTypes.object,
  from: PropTypes.object,
  links: PropTypes.shape({
    foldersIndex: PropTypes.string,
    folderShow: PropTypes.func,
  })
};

FolderFormInner.propTypes = {
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
  from: PropTypes.shape({
    id: PropTypes.number,
  }),
  links: PropTypes.shape({
    foldersIndex: PropTypes.string,
    folderShow: PropTypes.func,
  })
};

export default compose(
  memo,
)(FolderForm);
