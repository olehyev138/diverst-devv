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
  Divider, Box, FormControl, FormControlLabel, Switch
} from '@material-ui/core';

import Select from 'components/Shared/DiverstSelect';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/User/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import UserFieldInputForm from 'components/User/UserFieldInputForm/Loadable';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstFileInput from 'components/Shared/DiverstFileInput';

/* eslint-disable object-curly-newline */
export function UserFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
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
                component={DiverstFileInput}
                id='avatar'
                name='avatar'
                margin='normal'
                fileName={props.user && props.user.avatar_file_name}
                fullWidth
                label={<DiverstFormattedMessage {...messages.avatar} />}
                disabled={props.isCommitting}
                value={values.avatar}
              />
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                disabled={props.isCommitting}
                margin='normal'
                multiline
                rows={4}
                variant='outlined'
                id='biography'
                name='biography'
                value={values.biography}
                label={<DiverstFormattedMessage {...messages.biography} />}
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
              <FormControl>
                <FormControlLabel
                  labelPlacement='right'
                  label={<DiverstFormattedMessage {...messages.active} />}
                  control={(
                    <Field
                      component={Switch}
                      onChange={handleChange}
                      color='primary'
                      id='active'
                      name='active'
                      margin='normal'
                      checked={values.active}
                      value={values.active}
                    />
                  )}
                />
              </FormControl>
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                {buttonText}
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
      {props.edit && (
        <React.Fragment>
          <Box mb={2} />
          <UserFieldInputForm
            edit
            user={props.user}
            fieldData={props.fieldData}
            updateFieldDataBegin={props.updateFieldDataBegin}
            admin={props.admin}
            isCommitting={props.isCommitting}
            isFormLoading={props.isFormLoading}
            messages={messages}
          />
        </React.Fragment>
      )}
    </React.Fragment>
  );
}

export function UserForm(props) {
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
    active: { default: false },
    avatar: { default: null },
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
      {formikProps => <UserFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

UserForm.propTypes = {
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
)(UserForm);
