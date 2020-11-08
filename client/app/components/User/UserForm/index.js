/**
 *
 * User Form Component
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField,
  Divider, Box, FormControl, FormControlLabel, Switch, Tab, Paper, Tooltip, Grid, Typography
} from '@material-ui/core';
import InfoOutlinedIcon from '@material-ui/icons/InfoOutlined';

import Select from 'components/Shared/DiverstSelect';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/User/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import UserFieldInputForm from 'components/User/UserFieldInputForm/Loadable';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from 'components/Shared/DiverstCancel';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstFileInput from 'components/Shared/DiverstFileInput';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

/* eslint-disable object-curly-newline */
export function UserFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.user}>
      <Card>
        <Form>
          <CardContent>
            {!props.permissions.users_manage
              ? (
                <Grid container justify='space-between' alignItems='center'>
                  <Grid item xs={11}>
                    <Field
                      component={TextField}
                      onChange={handleChange}
                      fullWidth
                      disabled
                      required
                      margin='normal'
                      id='email'
                      name='email'
                      value={values.email}
                      label={<DiverstFormattedMessage {...messages.email} />}
                    />
                  </Grid>
                  <Grid item>
                    <Tooltip title={<DiverstFormattedMessage {...messages.email_warning} />} placement='left'>
                      <InfoOutlinedIcon color='disabled' />
                    </Tooltip>
                  </Grid>
                </Grid>
              ) : (
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
              )}
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
              options={props?.user?.timezones || []}
              onChange={value => setFieldValue('time_zone', value)}
              onBlur={() => setFieldTouched('time_zone', true)}
            />
            <Permission show={permission(props, 'users_manage')}>
              <Box mb={2} />
              <Divider />
              <Box mb={2} />
              <Typography variant='h6'>
                <DiverstFormattedMessage {...messages.admin_fields} />
              </Typography>
              <FormControl>
                <FormControlLabel
                  labelPlacement='end'
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
              <Field
                component={Select}
                fullWidth
                disabled={props.isCommitting}
                id='user_role_id'
                name='user_role_id'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.user_role} />}
                value={values.user_role_id}
                options={props?.user?.available_roles || []}
                onChange={value => setFieldValue('user_role_id', value)}
                onBlur={() => setFieldTouched('user_role_id', true)}
              />
            </Permission>
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <DiverstCancel
              disabled={props.isCommitting}
              redirectFallback={(props.admin ? props.links.usersIndex : props.links.usersPath(values.id))}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </DiverstCancel>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function UserForm(props) {
  const [tab, setTab] = useState('general');

  const user = props?.user;
  const defaultRole = (user?.available_roles || []).find(item => item.default);

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

  const basicForm = (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, ['time_zone', 'user_role_id']);
        payload.redirectPath = props.admin ? props.links.usersIndex : props.links.usersPath(user.id);
        // eslint-disable-next-line no-unused-expressions
        !props.permissions.users_manage && delete payload.email;
        props.userAction(payload);
      }}
    >
      {formikProps => <UserFormInner {...props} {...formikProps} />}
    </Formik>
  );

  const fieldForm = (
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
  );

  return (
    <React.Fragment>
      {props.edit && (
        <React.Fragment>
          <Paper>
            <ResponsiveTabs
              value={tab}
              indicatorColor='primary'
              textColor='primary'
            >
              <Tab
                onClick={() => setTab('general')}
                label={<DiverstFormattedMessage {...messages.generalTab} />}
                value='general'
              />
              <Tab
                onClick={() => setTab('fields')}
                label={<DiverstFormattedMessage {...messages.fieldTab} />}
                value='fields'
              />
            </ResponsiveTabs>
          </Paper>
          <Box mb={2} />
        </React.Fragment>
      )}
      {tab === 'general' && basicForm}
      {tab === 'fields' && fieldForm}
    </React.Fragment>
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
  fieldData: PropTypes.array,
  updateFieldDataBegin: PropTypes.func,
  links: PropTypes.shape({
    usersIndex: PropTypes.string,
    usersPath: PropTypes.func,
  }),
  permissions: PropTypes.object,
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
  }),
  permissions: PropTypes.object,
};

export default compose(
  memo,
)(UserForm);
