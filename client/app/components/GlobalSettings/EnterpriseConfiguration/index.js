/**
 *
 * EnterpriseConfiguration Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'components/Shared/DiverstSelect';
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
            <Grid item xs={12} className={classes.noBottomPadding}>
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
    mentorship_module_enabled: { default: true },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.enterpriseAction(values);
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
