/**
 *
 * SponsorForm Component
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
export function SponsorFormInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
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
                id='sponsor_name'
                name='sponsor_name'
                margin='normal'
                label='Sponsor Name'
                value={values.sponsor_name}
              />
            </Grid>
            <Grid item xs={12} className={classes.noBottomPadding}>
              <Field
                component={TextField}
                required
                onChange={handleChange}
                fullWidth
                id='sponsor_title'
                name='sponsor_title'
                margin='normal'
                label='Sponsor title'
                value={values.sponsor_title}
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
          <Button
            component={WrappedNavLink}
            to={props.links.sponsorIndex}
          >
            Cancel
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function SponsorForm(props) {
  const initialValues = buildValues(props.sponsor, {
    id: { default: '' },
    sponsor_name: { default: '' },
    sponsor_title: { default: '' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.sponsorAction(values);
      }}

      render={formikProps => <SponsorFormInner {...props} {...formikProps} />}
    />
  );
}

SponsorForm.propTypes = {
  sponsorAction: PropTypes.func,
  sponsor: PropTypes.object,
};

SponsorFormInner.propTypes = {
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  links: PropTypes.shape({
    sponsorIndex: PropTypes.string
  })
};

export default compose(
  memo,
  withStyles(styles)
)(SponsorForm);
