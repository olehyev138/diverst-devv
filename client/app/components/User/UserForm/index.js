/**
 *
 * User Form Component
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
  Divider
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/User/messages';
import { buildValues } from 'utils/formHelpers';

import FieldInputForm from 'components/User/FieldInputForm/Loadable';

/* eslint-disable object-curly-newline */
export function UserFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='first_name'
            name='first_name'
            value={values.first_name}
            label={<DiverstFormattedMessage {...messages.first_name} />}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='last_name'
            name='last_name'
            value={values.last_name}
            label={<DiverstFormattedMessage {...messages.last_name} />}
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
            to={props.links.usersIndex}
            component={WrappedNavLink}
          >
            <DiverstFormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
      <Divider />
      <FieldInputForm
        user={props.user}
        fieldData={props.fieldData}
        updateFieldDataBegin={props.updateFieldDataBegin}
      />
    </Card>
  );
}

export function UserForm(props) {
  const user = dig(props, 'user');

  const initialValues = buildValues(user, {
    first_name: { default: '' },
    last_name: { default: '' },
    id: { default: undefined }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.userAction(values);
      }}

      render={formikProps => <UserFormInner {...props} {...formikProps} />}
    />
  );
}

UserForm.propTypes = {
  userAction: PropTypes.func,
  user: PropTypes.object,
  currentUser: PropTypes.object,
};

UserFormInner.propTypes = {
  user: PropTypes.object,
  fieldData: PropTypes.array,
  updateFieldDataBegin: PropTypes.func,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  links: PropTypes.shape({
    usersIndex: PropTypes.string
  })
};

export default compose(
  memo,
)(UserForm);
