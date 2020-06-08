/**
 *
 * SponsorForm Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Field, Formik, Form } from 'formik';
import { FormattedMessage } from 'react-intl';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, Paper,
  TextField, Hidden, FormControl, Divider, Switch, FormControlLabel,
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Branding/messages';

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
                label={<DiverstFormattedMessage {...messages.Sponsors.name} />}
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
                label={<DiverstFormattedMessage {...messages.Sponsors.title} />}
                value={values.sponsor_title}
              />
            </Grid>
            <Grid item xs={12} className={classes.noBottomPadding}>
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                id='sponsor_message'
                name='sponsor_messsage'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.Sponsors.message} />}
                value={values.sponsor_message}
              />
            </Grid>
            <Grid item className={classes.noBottomPadding}>
              <Field
                component={DiverstFileInput}
                id='sponsor_media'
                name='sponsor_media'
                margin='normal'
                fileName={props.sponsor && props.sponsor.sponsor_media_file_name}
                fullWidth
                label={<DiverstFormattedMessage {...messages.Sponsors.media} />}
                value={values.sponsor_media}
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
            {<DiverstFormattedMessage {...messages.save} />}
          </Button>
          <Button
            component={WrappedNavLink}
            to={props.links.sponsorIndex}
          >
            {<DiverstFormattedMessage {...messages.cancel} />}
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
    sponsor_message: { default: '' },
    sponsor_media: { default: null },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        values.sponsorableId = props.sponsorableId;
        props.sponsorAction(values);
      }}

      render={formikProps => <SponsorFormInner {...props} {...formikProps} />}
    />
  );
}

SponsorForm.propTypes = {
  sponsorAction: PropTypes.func,
  sponsor: PropTypes.object,
  sponsorableId: PropTypes.number,
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
  sponsor: PropTypes.object,
  links: PropTypes.shape({
    sponsorIndex: PropTypes.string
  })
};

export default compose(
  memo,
  withStyles(styles)
)(SponsorForm);
