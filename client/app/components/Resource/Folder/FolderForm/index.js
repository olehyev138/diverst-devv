/**
 *
 * Folder Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import { FormattedMessage } from 'react-intl';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Switch
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Resource/Folder/messages';
import { buildValues } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function FolderFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
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
            label={<FormattedMessage {...messages.form.name} />}
            value={values.subject}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='parent'
            name='parent'
            value={values.content}
            label={<FormattedMessage {...messages.form.parent} />}
          />
          <Field
            component={Switch}
            onChange={handleChange}
            id='protected'
            name='protected'
            value={values.password_protected}
            label={<FormattedMessage {...messages.form.protected} />}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='password'
            name='password'
            value={values.password}
            label={<FormattedMessage {...messages.form.password} />}
          />
        </CardContent>
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            {buttonText}
          </Button>
          <Button
            to={props.links.foldersIndex}
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
  const folder = dig(props, 'resourceItem', 'group_message');

  const initialValues = buildValues(folder, {
    name: { default: '' },
    parent: { default: '' },
    password: { default: '' },
    password_protected: { default: false },
    owner_id: { default: dig(props, 'currentUser', 'id') || '' },
    group_id: { default: dig(props, 'currentGroup', 'id') || '' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.folderAction(values);
      }}

      render={formikProps => <FolderFormInner {...props} {...formikProps} />}
    />
  );
}

FolderForm.propTypes = {
  folderAction: PropTypes.func,
  folder: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object
};

FolderFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  links: PropTypes.shape({
    foldersIndex: PropTypes.string
  })
};

export default compose(
  memo,
)(FolderForm);
