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
  Divider, Typography, Box
} from '@material-ui/core';

import Select from 'components/Shared/DiverstSelect';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/User/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import UserFieldInputForm from 'components/User/UserFieldInputForm/Loadable';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import FieldInputForm from 'components/Shared/Fields/FieldInputForm/Loadable';

/* eslint-disable object-curly-newline */
export function InviteFormInner({ formikProps, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  return (
    <React.Fragment>
      <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.user}>
        <Card>
          <Form>
            <CardContent>
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                disabled={props.isCommitting}
                required
                margin='normal'
                id='email'
                name='email'
                value={values.email}
                label={<DiverstFormattedMessage {...messages.email} />}
              />
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                disabled={props.isCommitting}
                margin='normal'
                id='first_name'
                name='first_name'
                value={values.first_name}
                label={<DiverstFormattedMessage {...messages.first_name} />}
              />
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                disabled={props.isCommitting}
                margin='normal'
                id='last_name'
                name='last_name'
                value={values.last_name}
                label={<DiverstFormattedMessage {...messages.last_name} />}
              />
              <Field
                component={Select}
                fullWidth
                disabled={props.isCommitting}
                id='time_zone'
                name='time_zone'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.time_zone} />}
                value={values.time_zone}
                options={dig(props, 'user', 'timezones') || []}
                onChange={value => setFieldValue('time_zone', value)}
                onBlur={() => setFieldTouched('time_zone', true)}
              />
              <Field
                component={Select}
                fullWidth
                disabled={props.isCommitting}
                id='user_role_id'
                name='user_role_id'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.user_role} />}
                value={values.user_role_id}
                options={dig(props, 'user', 'available_roles') || []}
                onChange={value => setFieldValue('user_role_id', value)}
                onBlur={() => setFieldTouched('user_role_id', true)}
              />
            </CardContent>
            {/* Consider For Later */}
            {false && (
              <FieldInputForm
                fieldData={dig(props, 'user', 'field_data') || []}
                isCommitting={props.isCommitting}
                isFetching={props.isFormLoading}

                messages={messages}
                formikProps={formikProps}

                join
                noCard
              />
            )}
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                {props.buttonText}
              </DiverstSubmit>
              <Button
                disabled={props.isCommitting}
                to={props.admin ? props.links.usersIndex : props.links.usersPath(values.id)}
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

export function InviteForm(props) {
  const user = dig(props, 'user');
  const defaultRole = (dig(user, 'available_roles') || []).find(item => item.default);

  const initialValues = buildValues(user, {
    first_name: { default: '' },
    email: { default: '' },
    last_name: { default: '' },
    biography: { default: '' },
    time_zone: { default: null },
    user_role_id: { default: defaultRole },
    id: { default: undefined },
    field_data: { default: [], customKey: 'fieldData' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, ['time_zone', 'user_role_id']);
        payload.redirectPath = props.admin ? props.links.usersIndex : props.links.usersPath(user.id);
        props.userAction(payload);
      }}
    >
      {formikProps => <InviteFormInner {...props} formikProps={formikProps} />}
    </Formik>
  );
}

InviteForm.propTypes = {
  userAction: PropTypes.func,
  user: PropTypes.object,
  currentUser: PropTypes.object,
  admin: PropTypes.bool,
  edit: PropTypes.bool,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    usersIndex: PropTypes.string,
    usersPath: PropTypes.func,
  })
};

InviteFormInner.propTypes = {
  user: PropTypes.object,
  fieldData: PropTypes.array,
  formikProps: PropTypes.shape({
    updateFieldDataBegin: PropTypes.func,
    handleSubmit: PropTypes.func,
    handleChange: PropTypes.func,
    handleBlur: PropTypes.func,
    values: PropTypes.object,
    setFieldValue: PropTypes.func,
    setFieldTouched: PropTypes.func,
  }),
  buttonText: PropTypes.string,
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
)(InviteForm);
