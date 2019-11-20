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

/* eslint-disable object-curly-newline */
export function UserRoleFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
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
                label='Role Name'
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
                label='Priority'
              />
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                {buttonText}
              </DiverstSubmit>
              <Button
                disabled={props.isCommitting}
                to='#'
                component={WrappedNavLink}
              >
                Cancel
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
    priority: { default: -1 },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.userRoleAction(values);
      }}

      render={formikProps => <UserRoleFormInner {...props} {...formikProps} />}
    />
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
    usersIndex: PropTypes.string,
    usersPath: PropTypes.func,
  })
};

export default compose(
  memo,
)(UserRoleForm);
