/**
 *
 * Group Settings Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Field, Formik, Form } from 'formik';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';

import messages from 'containers/Group/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import Select from 'components/Shared/DiverstSelect';
import {
  Button, Card, CardActions, CardContent, Grid, Checkbox,
  TextField, FormControl, Divider, Switch, FormControlLabel,
} from '@material-ui/core';

import DiverstColorPicker from 'components/Shared/DiverstColorPicker';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFileInput from 'components/Shared/DiverstFileInput';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* Define valid options for group settings - validated on backend */
const SETTINGS_OPTIONS = Object.freeze({
  pendingUsers: [
    { label: 'Enabled', value: 'enabled' },
    { label: 'Disabled', value: 'disabled' }
  ],
  membersVisibility: [
    { label: 'Global', value: 'global' },
    { label: 'Group', value: 'group' },
    { label: 'Managers Only', value: 'managers_only' }
  ],
  eventAttendanceVisibility: [
    { label: 'Global', value: 'global' },
    { label: 'Group', value: 'group' },
    { label: 'Managers Only', value: 'managers_only' }
  ],
  messagesVisibility: [
    { label: 'Global', value: 'global' },
    { label: 'Group', value: 'group' },
    { label: 'Managers Only', value: 'managers_only' }
  ],
  latestNewsVisibility: [
    { label: 'Public', value: 'public' },
    { label: 'Group', value: 'group' },
    { label: 'Leaders Only', value: 'leaders_only' }
  ],
  upcomingEventsVisibility: [
    { label: 'Public', value: 'public' },
    { label: 'Group', value: 'group' },
    { label: 'Leaders Only', value: 'leaders_only' },
    { label: 'Non member', value: 'non_member' }
  ],
});

/* eslint-disable object-curly-newline */
export function GroupSettingsInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const prettify = str => (str.charAt(0).toUpperCase() + str.slice(1)).replace(/_/g, ' ');
  return (
    <Card>
      <Form>
        <CardContent>
          <Grid container spacing={3} justify='space-around'>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='pending_users'
                name='pending_users'
                margin='normal'
                label='Pending Users'
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.pendingUsers}
                value={{ value: values.pending_users, label: prettify(values.pending_users) }}
                onChange={value => setFieldValue('pending_users', value.value)}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='members_visibility'
                name='members_visibility'
                margin='normal'
                label='Members Visibility'
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.membersVisibility}
                value={{ value: values.members_visibility, label: prettify(values.members_visibility) }}
                onChange={value => setFieldValue('members_visibility', value.value)}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='event_attendance_visibility'
                name='event_attendance_visibility'
                margin='normal'
                label='Event Attendance Visibility'
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.eventAttendanceVisibility}
                value={{ value: values.event_attendance_visibility, label: prettify(values.event_attendance_visibility) }}
                onChange={value => setFieldValue('event_attendance_visibility', value.value)}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='messages_visibility'
                name='messages_visibility'
                margin='normal'
                label='Messages Visibility'
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.messagesVisibility}
                value={{ value: values.messages_visibility, label: prettify(values.messages_visibility) }}
                onChange={value => setFieldValue('messages_visibility', value.value)}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='latest_news_visibility'
                name='latest_news_visibility'
                margin='normal'
                label='Latest News Visibility'
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.latestNewsVisibility}
                value={{ value: values.latest_news_visibility, label: prettify(values.latest_news_visibility) }}
                onChange={value => setFieldValue('latest_news_visibility', value.value)}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='upcoming_events_visibility'
                name='upcoming_events_visibility'
                margin='normal'
                label='Upcoming Events Visibility'
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.upcomingEventsVisibility}
                value={{ value: values.upcoming_events_visibility, label: prettify(values.upcoming_events_visibility) }}
                onChange={value => setFieldValue('upcoming_events_visibility', value.value)}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={DiverstFileInput}
                id='banner'
                name='banner'
                margin='normal'
                fileName={props.group.banner_file_name}
                fullWidth
                label='Add Banner'
                disabled={props.isCommitting}
                value={values.banner}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={DiverstColorPicker}
                id='calendar_color'
                name='calendar_color'
                label='Calendar Colour'
                disabled={props.isCommitting}
                value={values.calendar_color}
                onChange={value => setFieldValue('calendar_color', value)}
                FormControlProps={{
                  margin: 'normal'
                }}
              />
            </Grid>
          </Grid>
        </CardContent>
        <Divider />
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            <DiverstFormattedMessage {...messages.settings_save} />
          </DiverstSubmit>
        </CardActions>
      </Form>
    </Card>
  );
}

export function GroupSettings(props) {
  const initialValues = buildValues(props.group, {
    id: { default: '' },
    pending_users: { default: '' },
    members_visibility: { default: '' },
    event_attendance_visibility: { default: '' },
    messages_visibility: { default: '' },
    latest_news_visibility: { default: '' },
    upcoming_events_visibility: { default: '' },
    calendar_color: { default: '' },
    auto_archive: { default: '' },
    banner: { default: null },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupAction(mapFields(values, ['child_ids', 'parent_id']));
      }}
    >
      {formikProps => <GroupSettingsInner {...props} {...formikProps} />}
    </Formik>
  );
}

GroupSettings.propTypes = {
  groupAction: PropTypes.func,
  group: PropTypes.object,
  isCommitting: PropTypes.bool,
};

GroupSettingsInner.propTypes = {
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  group: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupSettings);
