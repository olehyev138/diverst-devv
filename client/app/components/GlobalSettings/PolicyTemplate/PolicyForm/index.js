/**
 *
 * Policy Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';
import Interweave from 'interweave';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstLogoutDialog from 'components/Shared/DiverstLogoutDialog';
import { injectIntl, intlShape } from 'react-intl';
import { Field, Formik, Form } from 'formik';
import {
  Typography,
  Card,
  CardHeader,
  CardActions,
  CardContent,
  TextField,
  Grid,
  Divider,
  Box,
  Button,
  Checkbox,
  FormLabel,
  FormGroup,
  FormControlLabel,
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/User/UserPolicy/messages';
import { buildValues } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  padding: {
    padding: theme.spacing(3, 2),
    margin: theme.spacing(1, 0),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  data: {
    '&:not(:last-of-type)': { // Prevent last data item from adding bottom padding
      paddingBottom: theme.spacing(3),
    },
  },
  buttons: {
    marginLeft: 20,
    float: 'right',
  },
});

/* eslint-disable object-curly-newline */
export function PolicyFormInner({
  handleSubmit, handleChange, handleBlur, values, touched, errors,
  buttonText, setFieldValue, setFieldTouched, setFieldError, classes,
  ...props
}) {
  const { intl } = props;

  return (
    <React.Fragment>
      <DiverstFormLoader isLoading={props.isFormLoading} isError={!props.policy}>
        <Card>
          <Form>
            <CardContent>
              <Grid container spacing={4}>
                <Grid item xs={12}>

                  <Typography component='h2' variant='h5'>
                    Enterprise
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Logs</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='logs_view'
                          name='logs_view'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.logs_view}
                          checked={values.logs_view}
                        />
                      )}
                      label='View'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Permissions</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='permissions_manage'
                          name='permissions_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.permissions_manage}
                          checked={values.permissions_manage}
                        />
                      )}
                      label='Manage'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>SSO</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='sso_manage'
                          name='sso_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.sso_manage}
                          checked={values.sso_manage}
                        />
                      )}
                      label='Manage'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Global Calendar</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='global_calendar'
                          name='global_calendar'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.global_calendar}
                          checked={values.global_calendar}
                        />
                      )}
                      label='View'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Enterprise resources</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='enterprise_resources_index'
                          name='enterprise_resources_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.enterprise_resources_index}
                          checked={values.enterprise_resources_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='enterprise_resources_create'
                          name='enterprise_resources_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Create'
                          value={values.enterprise_resources_create}
                          checked={values.enterprise_resources_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='enterprise_resources_manage'
                          name='enterprise_resources_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.enterprise_resources_manage}
                          checked={values.enterprise_resources_manage}
                        />
                      )}
                      label='Manage'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Diversity and Culture Index</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='diversity_manage'
                          name='diversity_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.diversity_manage}
                          checked={values.diversity_manage}
                        />
                      )}
                      label='Manage'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Metrics dashboards</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='metrics_dashboards_index'
                          name='metrics_dashboards_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.metrics_dashboards_index}
                          checked={values.metrics_dashboards_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='metrics_dashboards_create'
                          name='metrics_dashboards_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Create'
                          value={values.metrics_dashboards_create}
                          checked={values.metrics_dashboards_create}
                        />
                      )}
                      label='Create'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Users</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='users_index'
                          name='users_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.users_index}
                          checked={values.users_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='users_manage'
                          name='users_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.users_manage}
                          checked={values.users_manage}
                        />
                      )}
                      label='Manage'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Segments</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='segments_index'
                          name='segments_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.segments_index}
                          checked={values.segments_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='segments_create'
                          name='segments_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Create'
                          value={values.segments_create}
                          checked={values.segments_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='segments_manage'
                          name='segments_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage All'
                          value={values.segments_manage}
                          checked={values.segments_manage}
                        />
                      )}
                      label='Manage All'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Mentorship</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='mentorship_manage'
                          name='mentorship_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.mentorship_manage}
                          checked={values.mentorship_manage}
                        />
                      )}
                      label='Manage'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Settings</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='auto_archive_manage'
                          name='auto_archive_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage Auto Archive Settings'
                          value={values.auto_archive_manage}
                          checked={values.auto_archive_manage}
                        />
                      )}
                      label='Manage Auto Archive Settings'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='enterprise_manage'
                          name='enterprise_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage Enterprise'
                          value={values.enterprise_manage}
                          checked={values.enterprise_manage}
                        />
                      )}
                      label='Manage Enterprise'
                    />
                  </FormGroup>
                </Grid>
              </Grid>
              <Box mb={2} />
              <Divider />
              <Box mb={2} />
              <Grid container spacing={2}>
                <Grid item xs={12}>
                  <Typography component='h2' variant='h5'>
                    General
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Campaigns</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='campaigns_index'
                          name='campaigns_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.campaigns_index}
                          checked={values.campaigns_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='campaigns_create'
                          name='campaigns_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.campaigns_create}
                          checked={values.campaigns_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='campaigns_manage'
                          name='campaigns_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.campaigns_manage}
                          checked={values.campaigns_manage}
                        />
                      )}
                      label='Manage all'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Surveys</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='polls_index'
                          name='polls_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.polls_index}
                          checked={values.polls_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='polls_create'
                          name='polls_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.polls_create}
                          checked={values.polls_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='polls_manage'
                          name='polls_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.polls_manage}
                          checked={values.polls_manage}
                        />
                      )}
                      label='Manage all'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Groups</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='groups_index'
                          name='groups_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.groups_index}
                          checked={values.groups_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='groups_create'
                          name='groups_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.groups_create}
                          checked={values.groups_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='groups_manage'
                          name='groups_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.groups_manage}
                          checked={values.groups_manage}
                        />
                      )}
                      label='Manage all'
                    />
                  </FormGroup>
                </Grid>
              </Grid>
              <Box mb={2} />
              <Divider />
              <Box mb={2} />
              <Grid container spacing={2}>
                <Grid item xs={12}>
                  <Typography component='h2' variant='h5'>
                    Group
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Events</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='initiatives_index'
                          name='initiatives_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.initiatives_index}
                          checked={values.initiatives_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='initiatives_create'
                          name='initiatives_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.initiatives_create}
                          checked={values.initiatives_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='initiatives_manage'
                          name='initiatives_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.initiatives_manage}
                          checked={values.initiatives_manage}
                        />
                      )}
                      label='Manage all'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Messages</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='group_messages_index'
                          name='group_messages_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.group_messages_index}
                          checked={values.group_messages_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='group_messages_create'
                          name='group_messages_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.group_messages_create}
                          checked={values.group_messages_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='group_messages_manage'
                          name='group_messages_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.group_messages_manage}
                          checked={values.group_messages_manage}
                        />
                      )}
                      label='Manage all'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Members</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='groups_members_index'
                          name='groups_members_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.groups_members_index}
                          checked={values.groups_members_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='groups_members_manage'
                          name='groups_members_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.groups_members_manage}
                          checked={values.groups_members_manage}
                        />
                      )}
                      label='Manage all'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Budgets</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='groups_budgets_index'
                          name='groups_budgets_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.groups_budgets_index}
                          checked={values.groups_budgets_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='groups_budgets_request'
                          name='groups_budgets_request'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.groups_budgets_request}
                          checked={values.groups_budgets_request}
                        />
                      )}
                      label='Request'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='budget_approval'
                          name='budget_approval'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.budget_approval}
                          checked={values.budget_approval}
                        />
                      )}
                      label='Approval'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='groups_budgets_manage'
                          name='groups_budgets_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.groups_budgets_manage}
                          checked={values.groups_budgets_manage}
                        />
                      )}
                      label='Manage'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>News</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='news_links_index'
                          name='news_links_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.news_links_index}
                          checked={values.news_links_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='news_links_create'
                          name='news_links_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.news_links_create}
                          checked={values.news_links_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='news_links_manage'
                          name='news_links_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.news_links_manage}
                          checked={values.news_links_manage}
                        />
                      )}
                      label='Manage all'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Leaders</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='group_leader_index'
                          name='group_leader_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.group_leader_index}
                          checked={values.group_leader_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='group_leader_manage'
                          name='group_leader_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.group_leader_manage}
                          checked={values.group_leader_manage}
                        />
                      )}
                      label='Manage'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Posts</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='group_posts_index'
                          name='group_posts_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.group_posts_index}
                          checked={values.group_posts_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='manage_posts'
                          name='manage_posts'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.manage_posts}
                          checked={values.manage_posts}
                        />
                      )}
                      label='Manage'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Layouts</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='groups_layouts_manage'
                          name='groups_layouts_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.groups_layouts_manage}
                          checked={values.groups_layouts_manage}
                        />
                      )}
                      label='Manage'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Settings</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='group_settings_manage'
                          name='group_settings_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.group_settings_manage}
                          checked={values.group_settings_manage}
                        />
                      )}
                      label='Manage Group Settings'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Insights</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='groups_insights_manage'
                          name='groups_insights_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.groups_insights_manage}
                          checked={values.groups_insights_manage}
                        />
                      )}
                      label='Manage Group Insights'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Social Links</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='social_links_index'
                          name='social_links_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.social_links_index}
                          checked={values.social_links_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='social_links_create'
                          name='social_links_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.social_links_create}
                          checked={values.social_links_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='social_links_manage'
                          name='social_links_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.social_links_manage}
                          checked={values.social_links_manage}
                        />
                      )}
                      label='Manage all'
                    />
                  </FormGroup>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <FormLabel component='legend'>Resources</FormLabel>
                  <FormGroup>
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='group_resources_index'
                          name='group_resources_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.group_resources_index}
                          checked={values.group_resources_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='group_resources_create'
                          name='group_resources_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.group_resources_create}
                          checked={values.group_resources_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='group_resources_manage'
                          name='group_resources_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          value={values.group_resources_manage}
                          checked={values.group_resources_manage}
                        />
                      )}
                      label='Manage all'
                    />
                  </FormGroup>
                </Grid>
              </Grid>
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                <DiverstFormattedMessage {...messages.form.update} />
              </DiverstSubmit>
              <Button
                component={WrappedNavLink}
                to={props.links.policiesIndex}
                disabled={props.isCommitting}
              >
                <DiverstFormattedMessage {...messages.form.cancel} />
              </Button>
            </CardActions>
          </Form>
        </Card>
      </DiverstFormLoader>
    </React.Fragment>
  );
}

export function PolicyForm(props) {
  const policy = dig(props, 'policy');

  const initialValues = buildValues(policy, {
    id: { default: '' },
    campaigns_index: { default: false },
    campaigns_create: { default: false },
    campaigns_manage: { default: false },
    polls_index: { default: false },
    polls_create: { default: false },
    polls_manage: { default: false },
    group_messages_index: { default: false },
    group_messages_create: { default: false },
    group_messages_manage: { default: false },
    groups_index: { default: false },
    groups_create: { default: false },
    groups_manage: { default: false },
    groups_members_index: { default: false },
    groups_members_manage: { default: false },
    groups_budgets_index: { default: false },
    groups_budgets_request: { default: false },
    metrics_dashboards_index: { default: false },
    metrics_dashboards_create: { default: false },
    news_links_index: { default: false },
    news_links_create: { default: false },
    news_links_manage: { default: false },
    enterprise_resources_index: { default: false },
    enterprise_resources_create: { default: false },
    enterprise_resources_manage: { default: false },
    segments_index: { default: false },
    segments_create: { default: false },
    segments_manage: { default: false },
    users_index: { default: false },
    users_manage: { default: false },
    initiatives_index: { default: false },
    initiatives_create: { default: false },
    initiatives_manage: { default: false },
    logs_view: { default: false },
    sso_manage: { default: false },
    permissions_manage: { default: false },
    group_leader_manage: { default: false },
    global_calendar: { default: false },
    manage_posts: { default: false },
    diversity_manage: { default: false },
    budget_approval: { default: false },
    enterprise_manage: { default: false },
    groups_budgets_manage: { default: false },
    group_leader_index: { default: false },
    groups_insights_manage: { default: false },
    groups_layouts_manage: { default: false },
    group_resources_index: { default: false },
    group_resources_create: { default: false },
    group_resources_manage: { default: false },
    social_links_index: { default: false },
    social_links_create: { default: false },
    social_links_manage: { default: false },
    group_settings_manage: { default: false },
    group_posts_index: { default: false },
    mentorship_manage: { default: false },
    auto_archive_manage: { default: false },
  });

  const [open, setOpen] = React.useState(false);

  function handleClickOpen() {
    setOpen(true);
  }

  function handleClose() {
    setOpen(false);
  }

  return (
    <React.Fragment>
      <Formik
        initialValues={initialValues}
        enableReinitialize
        onSubmit={(values, actions) => {
          props.policyAction(values);
        }}
      >
        {formikProps => <PolicyFormInner {...props} {...formikProps} />}
      </Formik>
      <DiverstLogoutDialog
        open={open}
        handleClose={handleClose}
      />
    </React.Fragment>
  );
}

PolicyForm.propTypes = {
  edit: PropTypes.bool,
  policyAction: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,

  classes: PropTypes.object,
  intl: intlShape.isRequired,
};

PolicyFormInner.propTypes = {
  edit: PropTypes.bool,
  policy: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  touched: PropTypes.object,
  errors: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  setFieldError: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    policiesIndex: PropTypes.string,
    policyEdit: PropTypes.string,
  }),

  classes: PropTypes.object,
  intl: intlShape.isRequired,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles),
)(PolicyForm);
