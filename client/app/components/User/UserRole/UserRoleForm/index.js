/**
 *
 * UserRole Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField,
  Divider, Typography, Box
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/User/UserRole/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import Select from 'components/Shared/DiverstSelect';

/* eslint-disable object-curly-newline */
export function UserRoleFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  /* This should always match the roles defined in the backend model */
  const ROLE_TYPES = [
    { label: <DiverstFormattedMessage {...messages.role.admin} />, value: 'admin' },
    { label: <DiverstFormattedMessage {...messages.role.group} />, value: 'group' },
    { label: <DiverstFormattedMessage {...messages.role.user} />, value: 'user' }
  ];

  return (
    <React.Fragment>
      <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.userRole}>
        <Card>
          <Form>
            <CardContent>
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                disabled={props.isCommitting}
                margin='normal'
                id='role_name'
                name='role_name'
                value={values.role_name}
                label={<DiverstFormattedMessage {...messages.role_name} />}
              />
              <Field
                component={Select}
                fullWidth
                disabled={props.isCommitting}
                id='role_type'
                name='role_type'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.role_type} />}
                value={values.role_type}
                options={ROLE_TYPES}
                onChange={value => setFieldValue('role_type', value)}
                onBlur={() => setFieldTouched('role_type', true)}
              />
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                disabled={props.isCommitting}
                margin='normal'
                id='priority'
                name='priority'
                value={values.priority}
                label={<DiverstFormattedMessage {...messages.priority} />}
              />
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                {buttonText}
              </DiverstSubmit>
              <Button
                disabled={props.isCommitting}
                to={props.links.userRolesIndex}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.cancel} />
              </Button>
            </CardActions>
          </Form>
        </Card>
      </DiverstFormLoader>
    </React.Fragment>
  );
}

export function UserRoleForm(props) {
  const userRole = dig(props, 'userRole');

  const initialValues = buildValues(userRole, {
    id: { default: undefined },
    role_name: { default: '' },
    role_type: { default: '' },
    priority: { default: 0 },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.userRoleAction(mapFields(values, ['role_type']));
      }}
    >
      {formikProps => <UserRoleFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

UserRoleForm.propTypes = {
  userRoleAction: PropTypes.func,
  userRole: PropTypes.object,
  edit: PropTypes.bool,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    usersIndex: PropTypes.string,
    usersPath: PropTypes.func,
  })
};

UserRoleFormInner.propTypes = {
  userRole: PropTypes.object,
  fieldData: PropTypes.array,
  updateFieldDataBegin: PropTypes.func,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  admin: PropTypes.bool,
  edit: PropTypes.bool,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    userRolesIndex: PropTypes.string,
  })
};

export default compose(
  memo,
)(UserRoleForm);
