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
import { withStyles } from '@material-ui/core/styles';
import { buildValues, mapFields } from 'utils/formHelpers';
import Select from 'components/Shared/DiverstSelect';
import {
  Button, Card, CardActions, CardContent, Grid, Checkbox,
  TextField, FormControl, Divider, Switch, FormControlLabel,
} from '@material-ui/core';
import DiverstColorPicker from 'components/Shared/DiverstColorPicker';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFileInput from 'components/Shared/DiverstFileInput';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupManage/messages';
import groupmessages from 'containers/Group/messages';
import { injectIntl, intlShape } from 'react-intl';
import { intl } from '../../../../containers/Shared/LanguageProvider/GlobalLanguageProvider';
import DiverstRichTextInput from 'components/Shared/DiverstRichTextInput';

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
    { label: 'Public', value: 'global' },
    { label: 'Group', value: 'group' },
    { label: 'Leaders Only', value: 'managers_only' }
  ],
  eventAttendanceVisibility: [
    { label: 'Public', value: 'global' },
    { label: 'Group', value: 'group' },
    { label: 'Leaders Only', value: 'managers_only' }
  ],
  messagesVisibility: [
    { label: 'Public', value: 'global' },
    { label: 'Group', value: 'group' },
    { label: 'Leaders Only', value: 'managers_only' }
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

function setHeader(value) {
  switch (value) {
    case 'leaders_only':
    case 'managers_only':
      return intl.formatMessage(messages.visibility.leaders);
    case 'global':
      return intl.formatMessage(messages.visibility.public);
    case 'group':
      return intl.formatMessage(messages.visibility.group);
    case 'non_member':
      return intl.formatMessage(messages.visibility.non_member);
    case 'disabled':
      return intl.formatMessage(messages.visibility.disabled);
    case 'enabled':
      return intl.formatMessage(messages.visibility.enabled);
    default:
      return '';
  }
}


/* eslint-disable object-curly-newline */
export function GroupSettingsInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const prettify = str => (str.charAt(0).toUpperCase() + str.slice(1)).replace(/_/g, ' ');
  const { intl } = props;
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            required
            onChange={handleChange}
            fullWidth
            id='name'
            name='name'
            margin='normal'
            disabled={props.isCommitting}
            label={<DiverstFormattedMessage {...groupmessages.name} />}
            value={values.name}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='short_description'
            name='short_description'
            margin='normal'
            disabled={props.isCommitting}
            value={values.short_description}
            label={<DiverstFormattedMessage {...groupmessages.short_description} />}
          />
          <Field
            component={DiverstRichTextInput}
            required
            onChange={value => setFieldValue('description', value)}
            fullWidth
            id='description'
            name='description'
            margin='normal'
            label={<DiverstFormattedMessage {...groupmessages.description} />}
            value={values.description}
          />
          <Grid container spacing={3} justify='space-around'>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='pending_users'
                name='pending_users'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.settings.pending_users} />}
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.pendingUsers}
                value={{ value: values.pending_users, label: setHeader(values.pending_users) }}
                onChange={value => setFieldValue('pending_users', value.value)}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='members_visibility'
                name='members_visibility'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.settings.members_visibility} />}
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.membersVisibility}
                value={{ value: values.members_visibility, label: setHeader(values.members_visibility) }}
                onChange={value => setFieldValue('members_visibility', value.value)}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='event_attendance_visibility'
                name='event_attendance_visibility'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.settings.event_attendance_visibility} />}
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.eventAttendanceVisibility}
                value={{ value: values.event_attendance_visibility, label: setHeader(values.event_attendance_visibility) }}
                onChange={value => setFieldValue('event_attendance_visibility', value.value)}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='messages_visibility'
                name='messages_visibility'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.settings.messages_visibility} />}
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.messagesVisibility}
                value={{ value: values.messages_visibility, label: setHeader(values.messages_visibility) }}
                onChange={value => setFieldValue('messages_visibility', value.value)}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='latest_news_visibility'
                name='latest_news_visibility'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.settings.latest_news_visibility} />}
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.latestNewsVisibility}
                value={{ value: values.latest_news_visibility, label: setHeader(values.latest_news_visibility) }}
                onChange={value => setFieldValue('latest_news_visibility', value.value)}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={Select}
                id='upcoming_events_visibility'
                name='upcoming_events_visibility'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.settings.upcoming_events_visibility} />}
                disabled={props.isCommitting}
                options={SETTINGS_OPTIONS.upcomingEventsVisibility}
                value={{ value: values.upcoming_events_visibility, label: setHeader(values.upcoming_events_visibility) }}
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
                label={<DiverstFormattedMessage {...messages.settings.banner} />}
                disabled={props.isCommitting}
                value={values.banner}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={DiverstFileInput}
                id='logo'
                name='logo'
                margin='normal'
                fileName={props.group.logo_file_name}
                fullWidth
                label={intl.formatMessage(messages.settings.logo)}
                disabled={props.isCommitting}
                value={values.logo}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={DiverstColorPicker}
                id='calendar_color'
                name='calendar_color'
                label={intl.formatMessage(messages.settings.calendar_color)}
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
            <DiverstFormattedMessage {...messages.settings.save} />
          </DiverstSubmit>
        </CardActions>
      </Form>
    </Card>
  );
}

export function GroupSettings(props) {
  const initialValues = buildValues(props.group, {
    id: { default: '' },
    name: { default: '' },
    short_description: { default: '' },
    description: { default: '' },
    pending_users: { default: '' },
    members_visibility: { default: '' },
    event_attendance_visibility: { default: '' },
    messages_visibility: { default: '' },
    latest_news_visibility: { default: '' },
    upcoming_events_visibility: { default: '' },
    calendar_color: { default: '' },
    auto_archive: { default: '' },
    banner: { default: null },
    logo: { default: null },
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
  intl: intlShape,
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
  injectIntl,
  memo,
  withStyles(styles)
)(GroupSettings);
