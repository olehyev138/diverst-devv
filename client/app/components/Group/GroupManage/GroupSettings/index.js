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
  TextField, FormControl, Divider, Switch, FormControlLabel, Collapse,
} from '@material-ui/core';
import DiverstColorPicker from 'components/Shared/DiverstColorPicker';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFileInput from 'components/Shared/DiverstFileInput';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupManage/messages';
import groupmessages from 'containers/Group/messages';
import { injectIntl, intlShape } from 'react-intl';

import DiverstRichTextInput from 'components/Shared/DiverstRichTextInput';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* Define valid options for group settings - validated on backend */
const SETTINGS_OPTIONS = Object.freeze({
  pendingUsers: [
    { label: <DiverstFormattedMessage {...messages.visibility.enabled} />, value: 'enabled' },
    { label: <DiverstFormattedMessage {...messages.visibility.disabled} />, value: 'disabled' }
  ],
  membersVisibility: [
    { label: <DiverstFormattedMessage {...messages.visibility.public} />, value: 'public' },
    { label: <DiverstFormattedMessage {...messages.visibility.group} />, value: 'group' },
    { label: <DiverstFormattedMessage {...messages.visibility.leaders} />, value: 'leaders_only' },
  ],
  eventAttendanceVisibility: [
    { label: <DiverstFormattedMessage {...messages.visibility.public} />, value: 'public' },
    { label: <DiverstFormattedMessage {...messages.visibility.group} />, value: 'group' },
    { label: <DiverstFormattedMessage {...messages.visibility.leaders} />, value: 'leaders_only' },
  ],
  messagesVisibility: [
    { label: <DiverstFormattedMessage {...messages.visibility.public} />, value: 'public' },
    { label: <DiverstFormattedMessage {...messages.visibility.group} />, value: 'group' },
    { label: <DiverstFormattedMessage {...messages.visibility.leaders} />, value: 'leaders_only' },
  ],
  latestNewsVisibility: [
    { label: <DiverstFormattedMessage {...messages.visibility.public} />, value: 'public' },
    { label: <DiverstFormattedMessage {...messages.visibility.group} />, value: 'group' },
    { label: <DiverstFormattedMessage {...messages.visibility.leaders} />, value: 'leaders_only' },
  ],
  upcomingEventsVisibility: [
    { label: <DiverstFormattedMessage {...messages.visibility.public} />, value: 'public' },
    { label: <DiverstFormattedMessage {...messages.visibility.group} />, value: 'group' },
    { label: <DiverstFormattedMessage {...messages.visibility.leaders} />, value: 'leaders_only' },
    { label: <DiverstFormattedMessage {...messages.visibility.non_member} />, value: 'non_member' }
  ],
  unitsOfExpiration: [
    { label: <DiverstFormattedMessage {...messages.units.years} />, value: 'years' },
    { label: <DiverstFormattedMessage {...messages.units.months} />, value: 'months' },
    { label: <DiverstFormattedMessage {...messages.units.weeks} />, value: 'weeks' },
  ],
});

function setHeader(value) {
  switch (value) {
    case 'leaders_only':
      return <DiverstFormattedMessage {...messages.visibility.leaders} />;
    case 'public':
      return <DiverstFormattedMessage {...messages.visibility.public} />;
    case 'group':
      return <DiverstFormattedMessage {...messages.visibility.group} />;
    case 'non_member':
      return <DiverstFormattedMessage {...messages.visibility.non_member} />;
    case 'disabled':
      return <DiverstFormattedMessage {...messages.visibility.disabled} />;
    case 'enabled':
      return <DiverstFormattedMessage {...messages.visibility.enabled} />;
    case 'years':
      return <DiverstFormattedMessage {...messages.units.years} />;
    case 'months':
      return <DiverstFormattedMessage {...messages.units.months} />;
    case 'weeks':
      return <DiverstFormattedMessage {...messages.units.weeks} />;
    default:
      return '';
  }
}


/* eslint-disable object-curly-newline */
export function GroupSettingsInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
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
                fileType='image'
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
                label={<DiverstFormattedMessage {...messages.settings.logo} />}
                disabled={props.isCommitting}
                value={values.logo}
                fileType='image'
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={DiverstColorPicker}
                id='calendar_color'
                name='calendar_color'
                label={intl.formatMessage(messages.settings.calendar_color, props.customTexts)}
                disabled={props.isCommitting}
                value={values.calendar_color}
                onChange={value => setFieldValue('calendar_color', value)}
                FormControlProps={{
                  margin: 'normal'
                }}
              />
            </Grid>
            <Grid item xs='auto'>
              <FormControl>
                <FormControlLabel
                  labelPlacement='top'
                  label={<DiverstFormattedMessage {...messages.settings.auto_archive} />}
                  control={(
                    <Field
                      component={Switch}
                      onChange={value => setFieldValue('auto_archive', !values.auto_archive)}
                      color='primary'
                      id='auto_archive'
                      name='auto_archive'
                      margin='normal'
                      checked={values.auto_archive}
                      value={values.auto_archive}
                    />
                  )}
                />
              </FormControl>
            </Grid>
            <Collapse in={values.auto_archive}>
              <Grid container spacing={3} justify='space-around'>
                <Grid item>
                  <Field
                    component={Select}
                    id='unit_of_expiry_age'
                    name='unit_of_expiry_age'
                    margin='normal'
                    label={<DiverstFormattedMessage {...messages.settings.expiry_units} />}
                    disabled={props.isCommitting}
                    options={SETTINGS_OPTIONS.unitsOfExpiration}
                    value={{ value: values.unit_of_expiry_age, label: setHeader(values.unit_of_expiry_age) }}
                    onChange={value => setFieldValue('unit_of_expiry_age', value.value)}
                  />
                </Grid>
                <Grid item>
                  <TextField
                    id='expiry_age_for_news'
                    variant='outlined'
                    name='expiry_age_for_news'
                    type='number'
                    InputProps={{ inputProps: { min: 0 } }}
                    margin='normal'
                    label={<DiverstFormattedMessage {...messages.settings.expiry_events} />}
                    value={values.expiry_age_for_news}
                    onChange={value => setFieldValue('expiry_age_for_news', value.target.value)}
                  />
                </Grid>
                <Grid item>
                  <TextField
                    id='expiry_age_for_events'
                    variant='outlined'
                    name='expiry_age_for_events'
                    type='number'
                    InputProps={{ inputProps: { min: 0 } }}
                    margin='normal'
                    label={<DiverstFormattedMessage {...messages.settings.expiry_events} />}
                    value={values.expiry_age_for_events}
                    onChange={value => setFieldValue('expiry_age_for_events', value.target.value)}
                  />
                </Grid>
                <Grid item>
                  <TextField
                    id='expiry_age_for_resources'
                    variant='outlined'
                    name='expiry_age_for_resources'
                    type='number'
                    InputProps={{ inputProps: { min: 0 } }}
                    margin='normal'
                    label={<DiverstFormattedMessage {...messages.settings.expiry_resources} />}
                    value={values.expiry_age_for_resources}
                    onChange={value => setFieldValue('expiry_age_for_resources', value.target.value)}
                  />
                </Grid>
              </Grid>
            </Collapse>
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
    auto_archive: { default: false },
    unit_of_expiry_age: { default: '' },
    expiry_age_for_news: { default: 0 },
    expiry_age_for_events: { default: 0 },
    expiry_age_for_resources: { default: 0 },
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
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  group: PropTypes.object,
  customTexts: PropTypes.object
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(GroupSettings);
