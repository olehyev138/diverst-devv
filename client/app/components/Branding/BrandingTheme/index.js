/**
 *
 * BrandingTheme Component
 *
 */

import React, { memo, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Field, Formik, Form } from 'formik';

import { withStyles } from '@material-ui/core/styles';
import {
  Card, CardActions, CardContent, Grid,
  Collapse, Divider, TextField
} from '@material-ui/core';

import { buildValues } from 'utils/formHelpers';

import DiverstColorPicker from 'components/Shared/DiverstColorPicker';
import DiverstSwitch from 'components/Shared/DiverstSwitch';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstFileInput from 'components/Shared/DiverstFileInput';
import DiverstLogoutDialog from 'components/Shared/DiverstLogoutDialog';

import { DEFAULT_BRANDING_COLOR, DEFAULT_CHARTS_COLOR } from 'containers/Shared/ThemeProvider';

import { omit } from 'lodash';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Branding/messages';
import { injectIntl, intlShape } from 'react-intl';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function BrandingThemeInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const { intl } = props;
  return (
    // The theme can be null if the enterprise has no theme, so the error is if it is undefined
    <DiverstFormLoader isLoading={props.isLoading} isError={props.theme === undefined}>
      <Card>
        <Form>
          <CardContent>
            <Grid container spacing={3} alignItems='center'>
              <Grid item xs={12} sm={6}>
                <Field
                  component={DiverstColorPicker}
                  id='primary_color'
                  name='primary_color'
                  label={intl.formatMessage(messages.Theme.primarycolor)}
                  disabled={props.isCommitting}
                  value={values.primary_color}
                  onChange={value => setFieldValue('primary_color', value)}
                  FormControlProps={{
                    margin: 'normal',
                    fullWidth: true,
                  }}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <Field
                  component={DiverstSwitch}
                  id='use_secondary_color'
                  name='use_secondary_color'
                  label={intl.formatMessage(messages.Theme.colorswitch)}
                  margin='normal'
                  disabled={props.isCommitting}
                  value={values.use_secondary_color}
                  onChange={(_, value) => setFieldValue('use_secondary_color', value)}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <Collapse in={values.use_secondary_color}>
                  <Field
                    component={DiverstColorPicker}
                    required
                    fullWidth
                    id='secondary_color'
                    name='secondary_color'
                    label={intl.formatMessage(messages.Theme.graphcolor)}
                    disabled={props.isCommitting}
                    value={values.secondary_color}
                    onChange={value => setFieldValue('secondary_color', value)}
                    FormControlProps={{
                      margin: 'normal',
                      fullWidth: true,
                    }}
                  />
                </Collapse>
              </Grid>
            </Grid>
          </CardContent>
          <Divider />
          <CardContent>
            <Grid container spacing={4} alignItems='center'>
              <Grid item>
                <Field
                  component={DiverstFileInput}
                  fileName={props.theme && props.theme.logo_file_name}
                  disabled={props.isCommitting}
                  fullWidth
                  id='logo'
                  name='logo'
                  margin='normal'
                  value={values.logo}
                  label={<DiverstFormattedMessage {...messages.Theme.logo} />}
                />
              </Grid>
              <Grid item md xs={12}>
                <Field
                  component={TextField}
                  onChange={handleChange}
                  disabled={props.isCommitting}
                  fullWidth
                  variant='outlined'
                  id='logo_redirect_url'
                  name='logo_redirect_url'
                  margin='normal'
                  size='small'
                  value={values.logo_redirect_url}
                  label={<DiverstFormattedMessage {...messages.Theme.url} />}
                />
              </Grid>
            </Grid>
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function BrandingTheme(props) {
  const initialValues = buildValues(props.theme, {
    primary_color: { default: DEFAULT_BRANDING_COLOR },
    secondary_color: { default: DEFAULT_CHARTS_COLOR },
    use_secondary_color: { default: false },
    logo: { default: null },
    logo_redirect_url: { default: '' },
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
          let payload;
          if (values.use_secondary_color === false) // Don't send secondary color unless they choose to enable it
            payload = omit(values, 'secondary_color');
          else
            payload = values;

          // Update theme through the enterprise controller
          props.enterpriseAction({ theme_attributes: payload });
        }}

        render={formikProps => <BrandingThemeInner {...props} {...formikProps} />}
      />
      <DiverstLogoutDialog
        open={open}
        handleClose={handleClose}
      />
    </React.Fragment>
  );
}

BrandingTheme.propTypes = {
  enterpriseAction: PropTypes.func,
  theme: PropTypes.object,
};

BrandingThemeInner.propTypes = {
  intl: intlShape,
  classes: PropTypes.object,
  theme: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isLoading: PropTypes.bool,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(BrandingTheme);
