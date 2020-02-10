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
  Button, Card, CardActions, CardContent, Grid,
  Collapse, Divider,
} from '@material-ui/core';

import { buildValues } from 'utils/formHelpers';

import DiverstColorPicker from 'components/Shared/DiverstColorPicker';
import DiverstSwitch from 'components/Shared/DiverstSwitch';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

import { DEFAULT_BRANDING_COLOR, DEFAULT_CHARTS_COLOR } from 'containers/Shared/ThemeProvider';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function BrandingThemeInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <DiverstFormLoader isLoading={props.isLoading} isError={!props.theme}>
      <Card>
        <Form>
          <CardContent>
            <Grid container spacing={3} alignItems='center'>
              <Grid item xs={12} sm={6}>
                <Field
                  component={DiverstColorPicker}
                  required
                  id='primary_color'
                  name='primary_color'
                  label='Primary Color'
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
                  label='Use different color for graphs?'
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
                    label='Graphs Color'
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
    id: { default: '' },
    primary_color: { default: DEFAULT_CHARTS_COLOR },
    secondary_color: { default: DEFAULT_BRANDING_COLOR },
    use_secondary_color: { default: false },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        // Update theme through the enterprise controller
        props.enterpriseAction({ theme_attributes: values });
      }}

      render={formikProps => <BrandingThemeInner {...props} {...formikProps} />}
    />
  );
}

BrandingTheme.propTypes = {
  enterpriseAction: PropTypes.func,
  theme: PropTypes.object,
};

BrandingThemeInner.propTypes = {
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
  withStyles(styles)
)(BrandingTheme);
