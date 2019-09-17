/**
 *
 * Group Settings Component
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

import messages from 'containers/Group/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, FormControl, Divider, Switch, FormControlLabel,
} from '@material-ui/core';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function GroupSettingsInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Grid container spacing={3}>
            <Grid item xs className={classes.noBottomPadding}>
              <Field
                component={TextField}
                required
                onChange={handleChange}
                fullWidth
                id='name'
                name='name'
                margin='normal'
                label={<FormattedMessage {...messages.name} />}
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
          <Button
            to={ROUTES.admin.manage.groups.index.path()}
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function GroupSettings(props) {
  const initialValues = buildValues(props.group, {
    id: { default: '' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupAction(mapFields(values, ['child_ids', 'parent_id']));
      }}

      render={formikProps => <GroupSettingsInner {...props} {...formikProps} />}
    />
  );
}

GroupSettings.propTypes = {
  groupAction: PropTypes.func,
  group: PropTypes.object,
};

GroupSettingsInner.propTypes = {
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
)(GroupSettings);
