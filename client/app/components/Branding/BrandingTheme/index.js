/**
 *
 * BrandingTheme Component
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

import messages from 'containers/Branding/messages';
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
export function BrandingThemeInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
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

export function BrandingTheme(props) {
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

      render={formikProps => <BrandingThemeInner {...props} {...formikProps} />}
    />
  );
}

BrandingTheme.propTypes = {
  enterpriseAction: PropTypes.func,
  enterprise: PropTypes.object,
};

BrandingThemeInner.propTypes = {
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
)(BrandingTheme);
