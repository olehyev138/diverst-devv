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

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstLogoutDialog from 'components/Shared/DiverstLogoutDialog';
import messages from 'containers/GlobalSettings/EnterpriseConfiguration/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardHeader, CardActions, CardContent, Grid, Paper, Typography,
  TextField, Hidden, FormControl, Divider, Switch, FormControlLabel, Collapse,
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';
import { intl } from '../../../containers/Shared/LanguageProvider/GlobalLanguageProvider';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

const SETTINGS_OPTIONS = Object.freeze({
  unitsOfExpiration: [
    { label: <DiverstFormattedMessage {...messages.units.years} />, value: 'years' },
    { label: <DiverstFormattedMessage {...messages.units.months} />, value: 'months' },
    { label: <DiverstFormattedMessage {...messages.units.weeks} />, value: 'weeks' },
  ],
});

function setHeader(value) {
  switch (value) {
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
                label={<DiverstFormattedMessage {...messages.name} />}
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
                label={<DiverstFormattedMessage {...messages.timezone} />}
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
                label={<DiverstFormattedMessage {...messages.from_email} />}
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
                label={<DiverstFormattedMessage {...messages.from_display_name} />}
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
                label={<DiverstFormattedMessage {...messages.redirect_email_contact} />}
                value={values.redirect_email_contact}
              />
            </Grid>
            <Grid item xs={12} className={classes.noBottomPadding} margin={2}>
              <Grid container direction='row' justify='space-between' alignment='flex-start' spacing={2}>
                <Grid item xs>
                  <Card variant='outlined'>
                    <CardContent>
                      <Typography variant='h6' color='primary'>Module Settings</Typography>
                      <FormControl>
                        <FormControlLabel
                          labelPlacement='right'
                          label={<DiverstFormattedMessage {...messages.mentorship_module} />}
                          control={(
                            <Field
                              component={Switch}
                              onChange={handleChange}
                              color='primary'
                              id='mentorship_module_enabled'
                              name='mentorship_module_enabled'
                              margin='normal'
                              checked={values.mentorship_module_enabled}
                              value={values.mentorship_module_enabled}
                            />
                          )}
                        />
                      </FormControl>
                      <FormControl>
                        <FormControlLabel
                          labelPlacement='right'
                          label={<DiverstFormattedMessage {...messages.collaborate_module} />}
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
                      <FormControl>
                        <FormControlLabel
                          labelPlacement='right'
                          label={<DiverstFormattedMessage {...messages.scope_module} />}
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
                      <FormControl>
                        <FormControlLabel
                          labelPlacement='right'
                          label={<DiverstFormattedMessage {...messages.plan_module} />}
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
                    </CardContent>
                  </Card>
                </Grid>
                <Grid item xs>
                  <Card variant='outlined'>
                    <CardContent>
                      <Typography variant='h6' color='primary'>Function Settings</Typography>
                      <FormControl>
                        <FormControlLabel
                          labelPlacement='right'
                          label={<DiverstFormattedMessage {...messages.likes} />}
                          control={(
                            <Field
                              component={Switch}
                              onChange={handleChange}
                              color='primary'
                              id='enable_likes'
                              name='enable_likes'
                              margin='normal'
                              checked={values.enable_likes}
                              value={values.enable_likes}
                            />
                          )}
                        />
                      </FormControl>
                      <FormControl>
                        <FormControlLabel
                          labelPlacement='right'
                          label={<DiverstFormattedMessage {...messages.pending_comments} />}
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
                      <FormControl>
                        <FormControlLabel
                          labelPlacement='right'
                          label={<DiverstFormattedMessage {...messages.rewards} />}
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
                      <FormControl>
                        <FormControlLabel
                          labelPlacement='right'
                          label={<DiverstFormattedMessage {...messages.social_media} />}
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
                    </CardContent>
                  </Card>
                </Grid>
                <Grid item xs>
                  <Card variant='outlined'>
                    <CardContent>
                      <Typography variant='h6' color='primary'>Email Settings</Typography>
                      <FormControl>
                        <FormControlLabel
                          labelPlacement='right'
                          label={<DiverstFormattedMessage {...messages.onboarding_emails} />}
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
                      <FormControl>
                        <FormControlLabel
                          labelPlacement='right'
                          label={<DiverstFormattedMessage {...messages.all_emails} />}
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
                    </CardContent>
                  </Card>
                </Grid>
              </Grid>
              <Grid item xs={12}>
                <Grid container direction='row' justify='space-between' alignment='flex-start' spacing={3}>
                  <Grid item xs='auto'>
                    <FormControl>
                      <FormControlLabel
                        labelPlacement='right'
                        label={<DiverstFormattedMessage {...messages.auto_archive} />}
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
                  <Grid item xs>
                    <Collapse in={values.auto_archive}>
                      <Grid container direction='row' justify='flex-start' spacing={2}>
                        <Grid item>
                          <Field
                            component={Select}
                            id='unit_of_expiry_age'
                            name='unit_of_expiry_age'
                            margin='normal'
                            label={<DiverstFormattedMessage {...messages.expiry_units} />}
                            options={SETTINGS_OPTIONS.unitsOfExpiration}
                            value={{ value: values.unit_of_expiry_age, label: setHeader(values.unit_of_expiry_age) }}
                            onChange={value => setFieldValue('unit_of_expiry_age', value.value)}
                          />
                        </Grid>
                        <Grid item>
                          <TextField
                            id='expiry_age_for_resources'
                            name='expiry_age_for_resources'
                            type='number'
                            margin='normal'
                            label={<DiverstFormattedMessage {...messages.expiry_resources} />}
                            value={values.expiry_age_for_resources}
                            onChange={value => setFieldValue('expiry_age_for_resources', value.target.value)}
                          />
                        </Grid>
                      </Grid>
                    </Collapse>
                  </Grid>
                </Grid>
              </Grid>
            </Grid>
          </Grid>
        </CardContent>
        <Divider />
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            <DiverstFormattedMessage {...messages.save} />
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
    enable_likes: { default: false },
    enable_pending_comments: { default: false },
    collaborate_module_enabled: { default: false },
    scope_module_enabled: { default: false },
    has_enabled_onboarding_email: { default: false },
    disable_emails: { default: false },
    enable_rewards: { default: false },
    enable_social_media: { default: false },
    plan_module_enabled: { default: false },
    time_zone: { default: null },
    expiry_age_for_resources: { default: 0 },
    unit_of_expiry_age: { default: '' },
    auto_archive: { default: false }
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
          props.enterpriseAction(mapFields(values, ['time_zone']));
          handleClickOpen();
        }}
      >
        {formikProps => <EnterpriseConfigurationInner {...props} {...formikProps} />}
      </Formik>
      <DiverstLogoutDialog
        open={open}
        handleClose={handleClose}
      />
    </React.Fragment>
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
