import React, {
  memo
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Card, CardActions, CardContent, Grid,
  TextField, Divider, Typography, FormControl, FormControlLabel, Switch,
} from '@material-ui/core';
import { Field, Formik, Form } from 'formik';
import { withStyles } from '@material-ui/core/styles';

import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstLogoutDialog from 'components/Shared/DiverstLogoutDialog';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

import messages from 'containers/GlobalSettings/EnterpriseConfiguration/messages';

import DiverstFileInput from 'components/Shared/DiverstFileInput';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function SSOSettingsInner({ classes, handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={DiverstFileInput}
            fileName={props.enterprise && props.enterprise.xml_sso_config_file_name}
            disabled={props.isCommitting}
            fullWidth
            id='xml_sso_config'
            name='xml_sso_config'
            margin='normal'
            label={<DiverstFormattedMessage {...messages.xml_sso_config} />}
            value={values.xml_sso_config}
            fileType='text/xml'
          />
        </CardContent>
        <Divider />
        <CardContent>
          <Grid container>
            <Grid item xs={12} className={classes.noBottomPadding}>
              <Field
                component={TextField}
                required
                onChange={handleChange}
                fullWidth
                id='idp_entity_id'
                name='idp_entity_id'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.idp_url} />}
                value={values.idp_entity_id}
              />
            </Grid>
            <Grid container>
              <Grid item xs={12} className={classes.noBottomPadding}>
                <Field
                  component={TextField}
                  required
                  onChange={handleChange}
                  fullWidth
                  id='idp_sso_target_url'
                  name='idp_sso_target_url'
                  margin='normal'
                  label={<DiverstFormattedMessage {...messages.login_url} />}
                  value={values.idp_sso_target_url}
                />
              </Grid>
              <Grid item xs={12} className={classes.noBottomPadding}>
                <Field
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  id='idp_slo_target_url'
                  name='idp_slo_target_url'
                  margin='normal'
                  label={<DiverstFormattedMessage {...messages.logout_url} />}
                  value={values.idp_slo_target_url}
                />
              </Grid>
              <Grid item xs={12} className={classes.noBottomPadding}>
                <Field
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  id='idp_cert'
                  name='idp_cert'
                  margin='normal'
                  label={<DiverstFormattedMessage {...messages.certificate} />}
                  value={values.idp_cert}
                />
              </Grid>
              <Grid item xs={12} className={classes.noBottomPadding}>
                <Field
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  id='sp_entity_id'
                  name='sp_entity_id'
                  margin='normal'
                  label={<DiverstFormattedMessage {...messages.sp_url} />}
                  value={values.sp_entity_id}
                />
              </Grid>
            </Grid>
          </Grid>
        </CardContent>
        <Card variant='outlined'>
          <CardContent>
            <Typography variant='h6' color='primary'><DiverstFormattedMessage {...messages.saml_setting} /></Typography>
            <FormControl>
              <FormControlLabel
                labelPlacement='end'
                label={<DiverstFormattedMessage {...messages.saml_enable} />}
                control={(
                  <Field
                    component={Switch}
                    onChange={handleChange}
                    color='primary'
                    id='has_enabled_saml'
                    name='has_enabled_saml'
                    margin='normal'
                    checked={values.has_enabled_saml}
                    value={values.has_enabled_saml}
                  />
                )}
              />
            </FormControl>
          </CardContent>
        </Card>
        <Divider />
        <CardActions>
          <DiverstSubmit
            isCommitting={props.isCommitting}
          >
            <DiverstFormattedMessage {...messages.save} />
          </DiverstSubmit>
        </CardActions>
      </Form>
    </Card>
  );
}

export function SSOSettings(props) {
  const initialValues = buildValues(props.enterprise, {
    id: { default: '' },
    xml_sso_config: { default: null },
    idp_entity_id: { default: '' },
    idp_sso_target_url: { default: '' },
    idp_slo_target_url: { default: '' },
    idp_cert: { default: '' },
    sp_entity_id: { default: '' },
    has_enabled_saml: { default: false }
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
        render={formikProps => <SSOSettingsInner {...props} {...formikProps} />}
      />
      <DiverstLogoutDialog
        open={open}
        handleClose={handleClose}
      />
    </React.Fragment>
  );
}

SSOSettings.propTypes = {
  enterpriseAction: PropTypes.func,
  enterprise: PropTypes.object,
};

SSOSettingsInner.propTypes = {
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  isCommitting: PropTypes.bool,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  enterprise: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(SSOSettings);
