/**
 *
 * Resource Form Component
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
import messages from 'containers/Resource/Resource/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

/* eslint-disable object-curly-newline */
export function ResourceFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
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
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.resource}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              disabled={props.isCommitting}
              id='title'
              name='title'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.form.title} />}
              value={values.title}
            />
            <Field
              component={Select}
              fullWidth
              disabled={props.isCommitting}
              id='folder_id'
              name='folder_id'
              label={<DiverstFormattedMessage {...messages.form.folder} />}
              margin='normal'
              value={values.folder_id}
              options={props.selectFolders}
              onMenuOpen={parentSelectAction}
              onChange={value => setFieldValue('folder_id', value)}
              onInputChange={value => parentSelectAction(value)}
              onBlur={() => setFieldTouched('folder_id', true)}
              isClearable
            />
            <h4>
              Resource Type:
            </h4>
            <FormControl
              variant='outlined'
            >
              <FormControlLabel
                labelPlacement='top'
                checked={values.type}
                control={(
                  <Field
                    component={Switch}
                    color='primary'
                    onChange={handleChange}
                    disabled={props.isCommitting}
                    id='type'
                    name='type'
                    margin='normal'
                    checked={values.type}
                    value={values.type}
                  />
                )}
                label='URL / File'
              />
            </FormControl>
            {values.type && (
              <h3>
                To Be Added: File Upload
              </h3>
            )}
            {!values.type && (
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                disabled={props.isCommitting}
                id='url'
                name='url'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.form.url} />}
                value={values.url}
              />
            )}
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              to={props.links.cancelPath}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function ResourceForm(props) {
  const resource = dig(props, 'resource');
  const initialValues = buildValues(resource, {
    id: { default: '' },
    title: { default: '' },
    folder: { default: props.currentFolder ? { value: props.currentFolder.id, label: props.currentFolder.name } : null, customKey: 'folder_id' },
    url: { default: '' },
    type: { default: false },
    group_id: { default: props.type === 'group' ? dig(props, 'currentGroup', 'id') : null },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, ['folder_id']);
        props.resourceAction(payload);
      }}
    >
      {formikProps => <ResourceFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

ResourceForm.propTypes = {
  edit: PropTypes.bool,
  type: PropTypes.string,
  getFoldersBegin: PropTypes.func,
  selectFolders: PropTypes.array,
  resourceAction: PropTypes.func,
  resource: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEnterprise: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  currentFolder: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
  }),
  from: PropTypes.shape({
    resource: PropTypes.shape({
      id: PropTypes.number,
      name: PropTypes.string,
    }),
    action: PropTypes.string,
  }),
  links: PropTypes.shape({
    cancelPath: PropTypes.string,
  })
};

ResourceFormInner.propTypes = {
  edit: PropTypes.bool,
  resource: PropTypes.object,
  type: PropTypes.string,
  getFoldersBegin: PropTypes.func,
  selectFolders: PropTypes.array,
  currentGroup: PropTypes.object,
  currentEnterprise: PropTypes.object,
  currentFolder: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
  }),
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
    resource: PropTypes.shape({
      id: PropTypes.number,
      name: PropTypes.string,
    }),
    action: PropTypes.string,
  }),
  links: PropTypes.shape({
    cancelPath: PropTypes.string,
  })
};

export default compose(
  memo,
)(ResourceForm);
