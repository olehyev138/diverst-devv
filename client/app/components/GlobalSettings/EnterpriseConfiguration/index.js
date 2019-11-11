/**
 *
 * EnterpriseConfiguration Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import dig from 'object-dig';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Field, Formik, Form } from 'formik';
import { FormattedMessage } from 'react-intl';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/GlobalSettings/EnterpriseConfiguration/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, Paper,
  TextField, Hidden, FormControl, Divider, Switch, FormControlLabel,
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function EnterpriseConfigurationInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Grid container>
            <Grid item xs={12} className={classes.noBottomPadding}>
              <Field
                component={TextField}
                required
                onChange={handleChange}
                fullWidth
                id='name'
                name='name'
                margin='normal'
                label='Name'
                value={values.name}
              />
            </Grid>
            <Grid item xs={12} className={classes.noBottomPadding}>
              <Field
                component={Select}
                fullWidth
                id='time_zone'
                name='time_zone'
                margin='normal'
                label='Time Zone'
                value={values.time_zone}
                options={dig(props, 'enterprise', 'timezones') || []}
                onChange={value => setFieldValue('time_zone', value)}
                onBlur={() => setFieldTouched('time_zone', true)}
              />
            </Grid>
            <Grid item xs={12} className={classes.noBottomPadding}>
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                id='default_from_email_address'
                name='default_from_email_address'
                margin='normal'
                label='Default from email'
                value={values.default_from_email_address}
              />
            </Grid>
            <Grid item xs={12} className={classes.noBottomPadding}>
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                id='default_from_email_display_name'
                name='default_from_email_display_name'
                margin='normal'
                label='Default from email display name'
                value={values.default_from_email_display_name}
              />
            </Grid>
            <Grid item xs={12} className={classes.noBottomPadding}>
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                id='redirect_email_contact'
                name='redirect_email_contact'
                margin='normal'
                label='Redirect email contact'
                value={values.redirect_email_contact}
              />
            </Grid>
            <Grid item xs={4} className={classes.noBottomPadding}>
              <FormControl>
                <FormControlLabel
                  labelPlacement='bottom'
                  label='Mentorship Module Enabled'
                  control={(
                    <Field
                      component={Switch}
                      onChange={handleChange}
                      color='primary'
                      id='mentorship_module_enabled'
                      name='mentorship_module_enabled'
                      margin='normal'
                      label='Mentorship Module Enabled'
                      checked={values.mentorship_module_enabled}
                      value={values.mentorship_module_enabled}
                    />
                  )}
                />
              </FormControl>
            </Grid>
            <Grid item xs={4} className={classes.noBottomPadding}>
              <FormControl>
                <FormControlLabel
                  labelPlacement='bottom'
                  label='Disable Likes'
                  control={(
                    <Field
                      component={Switch}
                      onChange={handleChange}
                      color='primary'
                      id='disable_likes'
                      name='disable_likes'
                      margin='normal'
                      checked={values.disable_likes}
                      value={values.disable_likes}
                    />
                  )}
                />
              </FormControl>
            </Grid>
            <Grid item xs={4} className={classes.noBottomPadding}>
              <FormControl>
                <FormControlLabel
                  labelPlacement='bottom'
                  label='Enable Pending Comments'
                  control={(
                    <Field
                      component={Switch}
                      onChange={handleChange}
                      color='primary'
                      id='enable_pending_comments'
                      name='enable_pending_comments'
                      margin='normal'
                      checked={values.enable_pending_comments}
                      value={values.enable_pending_comments}
                    />
                  )}
                />
              </FormControl>
            </Grid>
            <Grid item xs={4} className={classes.noBottomPadding}>
              <FormControl>
                <FormControlLabel
                  labelPlacement='bottom'
                  label='Collaborate module enabled'
                  control={(
                    <Field
                      component={Switch}
                      onChange={handleChange}
                      color='primary'
                      id='collaborate_module_enabled'
                      name='collaborate_module_enabled'
                      margin='normal'
                      checked={values.collaborate_module_enabled}
                      value={values.collaborate_module_enabled}
                    />
                  )}
                />
              </FormControl>
            </Grid>
            <Grid item xs={4} className={classes.noBottomPadding}>
              <FormControl>
                <FormControlLabel
                  labelPlacement='bottom'
                  label='Scope module enabled'
                  control={(
                    <Field
                      component={Switch}
                      onChange={handleChange}
                      color='primary'
                      id='scope_module_enabled'
                      name='scope_module_enabled'
                      margin='normal'
                      checked={values.scope_module_enabled}
                      value={values.scope_module_enabled}
                    />
                  )}
                />
              </FormControl>
            </Grid>
            <Grid item xs={4} className={classes.noBottomPadding}>
              <FormControl>
                <FormControlLabel
                  labelPlacement='bottom'
                  label='Enable onboarding emails?'
                  control={(
                    <Field
                      component={Switch}
                      onChange={handleChange}
                      color='primary'
                      id='has_enabled_onboarding_email'
                      name='has_enabled_onboarding_email'
                      margin='normal'
                      checked={values.has_enabled_onboarding_email}
                      value={values.has_enabled_onboarding_email}
                    />
                  )}
                />
              </FormControl>
            </Grid>
            <Grid item xs={4} className={classes.noBottomPadding}>
              <FormControl>
                <FormControlLabel
                  labelPlacement='bottom'
                  label='Disable all emails?'
                  control={(
                    <Field
                      component={Switch}
                      onChange={handleChange}
                      color='primary'
                      id='disable_emails'
                      name='disable_emails'
                      margin='normal'
                      checked={values.disable_emails}
                      value={values.disable_emails}
                    />
                  )}
                />
              </FormControl>
            </Grid>
            <Grid item xs={4} className={classes.noBottomPadding}>
              <FormControl>
                <FormControlLabel
                  labelPlacement='bottom'
                  label='Enable rewards?'
                  control={(
                    <Field
                      component={Switch}
                      onChange={handleChange}
                      color='primary'
                      id='enable_rewards'
                      name='enable_rewards'
                      margin='normal'
                      checked={values.enable_rewards}
                      value={values.enable_rewards}
                    />
                  )}
                />
              </FormControl>
            </Grid>
            <Grid item xs={4} className={classes.noBottomPadding}>
              <FormControl>
                <FormControlLabel
                  labelPlacement='bottom'
                  label='Enable social media?'
                  control={(
                    <Field
                      component={Switch}
                      onChange={handleChange}
                      color='primary'
                      id='enable_social_media'
                      name='enable_social_media'
                      margin='normal'
                      checked={values.enable_social_media}
                      value={values.enable_social_media}
                    />
                  )}
                />
              </FormControl>
            </Grid>
            <Grid item xs={4} className={classes.noBottomPadding}>
              <FormControl>
                <FormControlLabel
                  labelPlacement='bottom'
                  label='Plan module enabled?'
                  control={(
                    <Field
                      component={Switch}
                      onChange={handleChange}
                      color='primary'
                      id='plan_module_enabled'
                      name='plan_module_enabled'
                      margin='normal'
                      checked={values.plan_module_enabled}
                      value={values.plan_module_enabled}
                    />
                  )}
                />
              </FormControl>
            </Grid>
          </Grid>
        </CardContent>
        <Divider />
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            Save
          </Button>
          <Button>
            Cancel
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function EnterpriseConfiguration(props) {
  const initialValues = buildValues(props.enterprise, {
    id: { default: '' },
    name: { default: '' },
    default_from_email_address: { default: '' },
    default_from_email_display_name: { default: '' },
    redirect_email_contact: { default: '' },
    mentorship_module_enabled: { default: false },
    disable_likes: { default: false },
    enable_pending_comments: { default: false },
    collaborate_module_enabled: { default: false },
    scope_module_enabled: { default: false },
    has_enabled_onboarding_email: { default: false },
    disable_emails: { default: false },
    enable_rewards: { default: false },
    enable_social_media: { default: false },
    plan_module_enabled: { default: false },
    time_zone: { default: null }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.enterpriseAction(mapFields(values, ['time_zone']));
      }}

      render={formikProps => <EnterpriseConfigurationInner {...props} {...formikProps} />}
    />
  );
}

EnterpriseConfiguration.propTypes = {
  enterpriseAction: PropTypes.func,
  enterprise: PropTypes.object,
};

EnterpriseConfigurationInner.propTypes = {
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles)
)(EnterpriseConfiguration);