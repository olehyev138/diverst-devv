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
            label={underToSpace(key)}
            value={values[policy[key]]}
            checked={values[policy[key]]}
          />
        )}
        label={underToSpace(key)}
        key={key}
      />
    ));
  }

  function policiesRender(policies) {
    return Object.keys(policies).map(key => (
      <Grid item xs={12} sm={6} md={3} key={key}>
        <FormLabel component='legend'>{underToSpace(key)}</FormLabel>
        <FormGroup>
          {policyRender(policies[key])}
        </FormGroup>
      </Grid>
    ));
  }

  const enterprisePolicies = Object.freeze({
    Logs: {
      View: 'logs_view',
    },
    Permissions: {
      Manage: 'permissions_manage',
    },
    SSO: {
      Manage: 'sso_manage',
    },
    Global_Calendar: {
      View: 'global_calendar',
    },
    Enterprise_Resources: {
      View: 'enterprise_resources_index',
      Create: 'enterprise_resources_create',
      Manage: 'enterprise_resources_manage',
    },
    Diversity_and_Culture_Index: {
      Manage: 'diversity_manage',
    },
    Branding: {
      Manage: 'branding_manage',
    },
    Metrics_Dashboards: {
      View: 'metrics_dashboards_index',
      Create: 'metrics_dashboards_create',
    },
    Users: {
      View: 'users_index',
      Manage: 'users_manage',
    },
    Segments: {
      View: 'segments_index',
      Create: 'segments_create',
      Manage: 'segments_manage',
    },
    Mentorship: {
      Manage: 'mentorship_manage',
    },
    Settings: {
      Manage_Auto_Archive_Settings: 'auto_archive_manage',
      Manage_Enterprise: 'enterprise_manage',
    },
  });

  const generalPolicies = Object.freeze({
    Campaigns: {
      View: 'campaigns_index',
      Create: 'campaigns_create',
      Manage: 'campaigns_manage',
    },
    Surveys: {
      View: 'polls_index',
      Create: 'polls_create',
      Manage: 'polls_manage',
    },
    Groups: {
      View: 'groups_index',
      Create: 'groups_create',
      Manage: 'groups_manage',
    },
  });

  const groupPolicies = Object.freeze({
    Events: {
      View: 'initiatives_index',
      Create: 'initiatives_create',
      Manage: 'initiatives_manage',
    },
    Resource: {
      View: 'group_resources_index',
      Create: 'group_resources_create',
      Manage: 'group_resources_manage',
    },
    News: {
      View: 'group_posts_index',
      Create_Message: 'group_messages_create',
      Create_News_Link: 'news_links_create',
      Create_Social_Link: 'social_links_create',
      Manage: 'posts_manage',
    },
    Budgets: {
      View: 'groups_budgets_index',
      Request: 'groups_budgets_request',
      Approval: 'budget_approval',
      Manage: 'groups_budgets_manage',
    },
    Members: {
      View: 'groups_members_index',
      Manage: 'groups_members_manage',
    },
    Leaders: {
      View: 'group_leader_index',
      Manage: 'group_leader_manage',
    },
    Settings: {
      Manage_Group_Settings: 'group_settings_manage',
      Manage_Layouts: 'groups_layouts_manage',
      Manage_Insights: 'groups_insights_manage',
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
                    Enterprise
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
                    General
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
                    Group
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
