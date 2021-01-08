/**
 *
 * Policy Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstLogoutDialog from 'components/Shared/DiverstLogoutDialog';
import { injectIntl, intlShape } from 'react-intl';
import { Field, Formik, Form } from 'formik';
import {
  Typography, Card, CardActions, CardContent, Grid, Divider, Box,
  Checkbox, FormLabel, FormGroup, FormControlLabel,
} from '@material-ui/core';

import messages from 'containers/User/UserPolicy/messages';
import { buildValues } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from 'components/Shared/DiverstCancel';
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


  const underToSpace = string => string.split('_').join(' ');

  function policyRender(policy) {
    return Object.keys(policy).map(key => (
      <FormControlLabel
        control={(
          <Field
            component={Checkbox}
            onChange={handleChange}
            id={policy[key]}
            name={policy[key]}
            margin='normal'
            disabled={props.isCommitting}
            label={key}
            value={values[policy[key]]}
            checked={values[policy[key]]}
          />
        )}
        label={key}
        key={key}
      />
    ));
  }

  function policiesRender(policies) {
    return Object.keys(policies).map(key => (
      <Grid item xs={12} sm={6} md={3} key={key}>
        <FormLabel component='legend'>{key}</FormLabel>
        <FormGroup>
          {policyRender(policies[key])}
        </FormGroup>
      </Grid>
    ));
  }

  const enterprisePolicies = Object.freeze({
    [intl.formatMessage(messages.enterprise_policies.logs, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'logs_view',
    },
    [intl.formatMessage(messages.enterprise_policies.permissions, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'permissions_manage',
    },
    [intl.formatMessage(messages.enterprise_policies.sso, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'sso_manage',
    },
    [intl.formatMessage(messages.enterprise_policies.calendar, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'global_calendar',
    },
    [intl.formatMessage(messages.enterprise_policies.resources, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'enterprise_resources_index',
      [intl.formatMessage(messages.permissions.create, props.customTexts)]: 'enterprise_resources_create',
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'enterprise_resources_manage',
    },
    [intl.formatMessage(messages.enterprise_policies.diversity, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'diversity_manage',
    },
    [intl.formatMessage(messages.enterprise_policies.branding, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'branding_manage',
    },
    [intl.formatMessage(messages.enterprise_policies.metrics, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'metrics_dashboards_index',
      [intl.formatMessage(messages.permissions.create, props.customTexts)]: 'metrics_dashboards_create',
    },
    [intl.formatMessage(messages.enterprise_policies.users, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'users_index',
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'users_manage',
    },
    [intl.formatMessage(messages.enterprise_policies.segments, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'segments_index',
      [intl.formatMessage(messages.permissions.create, props.customTexts)]: 'segments_create',
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'segments_manage',
    },
    // TODO : Disabled module
    //    [intl.formatMessage(messages.enterprise_policies.mentorship, props.customTexts)]: {
    //      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'mentorship_manage',
    //    [intl.formatMessage(messages.enterprise_policies.settings, props.customTexts)]: {
    //    },
    [intl.formatMessage(messages.enterprise_policies.settings, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.auto_archive, props.customTexts)]: 'auto_archive_manage',
      [intl.formatMessage(messages.permissions.enterprise, props.customTexts)]: 'enterprise_manage',
    },
  });

  const generalPolicies = Object.freeze({
    // TODO : Disabled module
    //   [intl.formatMessage(messages.general_policies.campaigns, props.customTexts)]: {
    //      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'campaigns_index',
    //      [intl.formatMessage(messages.permissions.create, props.customTexts)]: 'campaigns_create',
    //      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'campaigns_manage',
    //    },
    [intl.formatMessage(messages.general_policies.surveys, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'polls_index',
      [intl.formatMessage(messages.permissions.create, props.customTexts)]: 'polls_create',
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'polls_manage',
    },
    [intl.formatMessage(messages.general_policies.groups, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'groups_index',
      [intl.formatMessage(messages.permissions.create, props.customTexts)]: 'groups_create',
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'groups_manage',
    },
  });

  const groupPolicies = Object.freeze({
    [intl.formatMessage(messages.group_policies.events, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'initiatives_index',
      [intl.formatMessage(messages.permissions.create, props.customTexts)]: 'initiatives_create',
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'initiatives_manage',
    },
    [intl.formatMessage(messages.group_policies.resource, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'group_resources_index',
      [intl.formatMessage(messages.permissions.create, props.customTexts)]: 'group_resources_create',
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'group_resources_manage',
    },
    [intl.formatMessage(messages.group_policies.news, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'group_posts_index',
      [intl.formatMessage(messages.permissions.message, props.customTexts)]: 'group_messages_create',
      [intl.formatMessage(messages.permissions.news_link, props.customTexts)]: 'news_links_create',
      [intl.formatMessage(messages.permissions.social_link, props.customTexts)]: 'social_links_create',
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'manage_posts',
    },
    [intl.formatMessage(messages.group_policies.budgets, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'groups_budgets_index',
      [intl.formatMessage(messages.permissions.request, props.customTexts)]: 'groups_budgets_request',
      [intl.formatMessage(messages.permissions.approval, props.customTexts)]: 'budget_approval',
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'groups_budgets_manage',
    },
    [intl.formatMessage(messages.group_policies.members, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'groups_members_index',
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'groups_members_manage',
    },
    [intl.formatMessage(messages.group_policies.leaders, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.view, props.customTexts)]: 'group_leader_index',
      [intl.formatMessage(messages.permissions.manage, props.customTexts)]: 'group_leader_manage',
    },
    [intl.formatMessage(messages.group_policies.settings, props.customTexts)]: {
      [intl.formatMessage(messages.permissions.settings, props.customTexts)]: 'group_settings_manage',
      [intl.formatMessage(messages.permissions.layouts, props.customTexts)]: 'groups_layouts_manage',
      [intl.formatMessage(messages.permissions.insights, props.customTexts)]: 'groups_insights_manage',
    },
  });

  return (
    <React.Fragment>
      <DiverstFormLoader isLoading={props.isFormLoading} isError={!props.policy}>
        <Card>
          <Form>
            <CardContent>
              <Grid container spacing={4}>
                <Grid item xs={12}>
                  <Typography component='h2' variant='h5'>
                    <DiverstFormattedMessage {...messages.type.enterprise} />
                  </Typography>
                </Grid>
                {policiesRender(enterprisePolicies)}
              </Grid>
              <Box mb={2} />
              <Divider />
              <Box mb={2} />
              <Grid container spacing={2}>
                <Grid item xs={12}>
                  <Typography component='h2' variant='h5'>
                    <DiverstFormattedMessage {...messages.type.general} />
                  </Typography>
                </Grid>
                {policiesRender(generalPolicies)}
              </Grid>
              <Box mb={2} />
              <Divider />
              <Box mb={2} />
              <Grid container spacing={2}>
                <Grid item xs={12}>
                  <Typography component='h2' variant='h5'>
                    <DiverstFormattedMessage {...messages.type.group} />
                  </Typography>
                </Grid>
                {policiesRender(groupPolicies)}
              </Grid>
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                <DiverstFormattedMessage {...messages.form.update} />
              </DiverstSubmit>
              <DiverstCancel
                redirectFallback={props.links.policiesIndex}
                disabled={props.isCommitting}
              >
                <DiverstFormattedMessage {...messages.form.cancel} />
              </DiverstCancel>
            </CardActions>
          </Form>
        </Card>
      </DiverstFormLoader>
    </React.Fragment>
  );
}

export function PolicyForm(props) {
  const policy = props?.policy;

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
    branding_manage: { default: false },
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
  buttonText: PropTypes.object,
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
  customTexts: PropTypes.object,
  intl: intlShape.isRequired,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles),
)(PolicyForm);
