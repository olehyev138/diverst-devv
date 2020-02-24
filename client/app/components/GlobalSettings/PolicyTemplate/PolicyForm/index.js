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
import messages from 'containers/GlobalSettings/Policy/messages';
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
                          fullWidth
                          id='logs_view'
                          name='logs_view'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.logs_view}
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
                          fullWidth
                          id='permissions_manage'
                          name='permissions_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.permissions_manage}
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
                          fullWidth
                          id='sso_manage'
                          name='sso_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.sso_manage}
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
                          fullWidth
                          id='global_calendar'
                          name='global_calendar'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.global_calendar}
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
                          fullWidth
                          id='enterprise_resources_index'
                          name='enterprise_resources_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.enterprise_resources_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='enterprise_resources_create'
                          name='enterprise_resources_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Create'
                          value={values.enterprise_resources_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='enterprise_resources_manage'
                          name='enterprise_resources_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.enterprise_resources_manage}
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
                          fullWidth
                          id='diversity_manage'
                          name='diversity_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.diversity_manage}
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
                          fullWidth
                          id='metrics_dashboards_index'
                          name='metrics_dashboards_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.metrics_dashboards_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='metrics_dashboards_create'
                          name='metrics_dashboards_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Create'
                          value={values.metrics_dashboards_create}
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
                          fullWidth
                          id='users_index'
                          name='users_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.users_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='users_manage'
                          name='users_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.users_manage}
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
                          fullWidth
                          id='segments_index'
                          name='segments_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.segments_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='segments_create'
                          name='segments_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Create'
                          value={values.segments_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='segments_manage'
                          name='segments_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage All'
                          value={values.segments_manage}
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
                          fullWidth
                          id='mentorship_manage'
                          name='mentorship_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage'
                          value={values.mentorship_manage}
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
                          fullWidth
                          id='auto_archive_manage'
                          name='auto_archive_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage Auto Archive Settings'
                          value={values.auto_archive_manage}
                        />
                      )}
                      label='Manage Auto Archive Settings'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='enterprise_manage'
                          name='enterprise_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage Enterprise'
                          value={values.enterprise_manage}
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
                          fullWidth
                          id='campaigns_index'
                          name='campaigns_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.campaigns_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='campaigns_create'
                          name='campaigns_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Create'
                          value={values.campaigns_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='campaigns_manage'
                          name='campaigns_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage all'
                          value={values.campaigns_manage}
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
                          fullWidth
                          id='polls_index'
                          name='polls_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.polls_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='polls_create'
                          name='polls_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Create'
                          value={values.polls_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='polls_manage'
                          name='polls_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage all'
                          value={values.polls_manage}
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
                          fullWidth
                          id='groups_index'
                          name='groups_index'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='View'
                          value={values.groups_index}
                        />
                      )}
                      label='View'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='groups_create'
                          name='groups_create'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Create'
                          value={values.groups_create}
                        />
                      )}
                      label='Create'
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          fullWidth
                          id='groups_manage'
                          name='groups_manage'
                          margin='normal'
                          disabled={props.isCommitting}
                          label='Manage all'
                          value={values.groups_manage}
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
                variant='contained'
                size='large'
                color='primary'
                className={classes.buttons}
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
    branding_manage: { default: false },
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

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.policyAction(values);
      }}
    >
      {formikProps => <PolicyFormInner {...props} {...formikProps} />}
    </Formik>
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
